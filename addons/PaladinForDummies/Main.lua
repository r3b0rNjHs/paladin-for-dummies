-- Arranque: base de datos (AceDB), eventos, opciones y comandos.
--
-- Solo se activa con paladines. Los ajustes van en un perfil de AceDB (por
-- defecto compartido por todos tus personajes) y las peleas en el personaje.
-- En combate la recomendación se congela; solo se anotan tus lanzamientos para
-- el repaso (Recorder.lua). Los errores van a BugSack/BugGrabber, o a la ventana
-- de errores del juego, y se guardan para el informe (/pfd report).
local ADDON_NAME, ns = ...
local L = ns.L

local SituationReader = ns.Adapters.SituationReader
local RuleEngine = ns.Core.RuleEngine
local Seals, Rules = ns.Data.Seals, ns.Data.Rules

local DEFAULTS = {
  profile = {
    language = "auto",
    tone = "fun", -- Locales: chistes en algunos mensajes (nunca en los avisos)
    devMode = false,
    advisor = { shown = true, locked = false, scale = 1, visibility = "fade" }, -- core/HudState.lua
    echo = { shown = true, scale = 1 }, -- solo se ve mientras tienes copias de Unsealed Wrath
    macros = { auto = false, disabled = {} },
    review = { chatSummary = false },
    reduceMotion = false,
  },
  char = { fights = {}, errors = {}, welcomed = false },
}
local MAX_ERRORS = 50

local db              -- objeto AceDB
local profile, char   -- db.profile y db.char
local enabled = false -- solo con paladines
local ui              -- ventana del asesor (ui/RecommendationFrame.lua)
local echoes          -- indicador de Unsealed Wrath (ui/EchoTracker.lua)
local frozen = false
local last = {}       -- última situación calculada
local reported = {}   -- errores ya enviados al gestor de errores en esta sesión

local function p(...)
  print("|cfff5b041Paladin for Dummies|r:", ...)
end

---------------------------------------------------------------------------
-- Errores
---------------------------------------------------------------------------

-- Se guardan en el personaje (para /pfd report) y se envían una vez por sesión
-- al gestor de errores (BugSack si está instalado). En el chat, solo con el modo
-- desarrollador.
local function reportError(context, err)
  local message = tostring(err)
  if char then
    char.errors = char.errors or {}
    table.insert(char.errors, { time = time(), context = context, message = message })
    while #char.errors > MAX_ERRORS do table.remove(char.errors, 1) end
  end
  if profile and profile.devMode then p("Error (" .. context .. "):", message) end

  local key = context .. "\001" .. message
  if not reported[key] and geterrorhandler then
    reported[key] = true
    pcall(geterrorhandler(), ("Paladin for Dummies (%s): %s"):format(context, message))
  end
end

local function safely(label, fn, ...)
  local ok, err = pcall(fn, ...)
  if not ok then reportError(label, err) end
end

---------------------------------------------------------------------------
-- Información del juego
---------------------------------------------------------------------------

local function addonVersion()
  local get = C_AddOns and C_AddOns.GetAddOnMetadata
  if not get then return nil end
  local ok, v = pcall(get, ADDON_NAME, "Version")
  return ok and v or nil
end

local function clientInfo()
  local ok, version, build, date, toc = pcall(GetBuildInfo)
  if not ok then return nil end
  return { version = version, build = build, date = date, toc = toc }
end

local function spellNameOf(spellId)
  if not (C_Spell and C_Spell.GetSpellName) then return nil end
  local ok, name = pcall(C_Spell.GetSpellName, spellId)
  if not ok or type(name) ~= "string" or (issecretvalue and issecretvalue(name)) then return nil end
  return name
end

local function isPaladin()
  local ok, _, classFile = pcall(UnitClass, "player")
  return ok and classFile == "PALADIN"
end

---------------------------------------------------------------------------
-- Macros
---------------------------------------------------------------------------

local MACRO_ACTION_TEXT = {
  created = "creada",
  updated = "actualizada",
  unchanged = "sin cambios",
  full = "no hay hueco libre en tus macros de personaje",
  notCreated = "el juego no la creó (avísame con /pfd report)",
}

-- Crea o actualiza las macros marcadas (core/Macros.lua). Solo fuera de
-- combate; si no, queda pendiente. No llama a las
-- funciones de macros si el texto de las macros no ha cambiado desde la última
-- vez. verbose = contarlo en el chat.
local macrosPending = false
local lastMacroSignature
local function syncMacros(verbose)
  if not (profile and profile.macros.auto and last.situation) then return end
  local built, skipped = ns.Core.Macros.build({
    seals = Seals,
    macroSpells = ns.Data.MacroSpells,
    knownSpells = last.situation.player.knownSpells,
    judgementSpellId = ns.Data.Spells.judgement,
    holyStrikeSpellId = ns.Data.Spells.holyStrike,
    nameOf = spellNameOf,
  })
  local macros = {}
  for _, m in ipairs(built) do
    if not profile.macros.disabled[m.name] then macros[#macros + 1] = m end
  end
  local parts = {}
  for _, m in ipairs(macros) do parts[#parts + 1] = m.name .. "\001" .. m.body end
  local signature = table.concat(parts, "\002")
  if not verbose and not macrosPending and signature == lastMacroSignature then return end

  local results, reason, counts = ns.Adapters.MacroWriter.write(_G, macros)
  char.macroStatus = { time = time(), results = results, skipped = skipped, reason = reason, counts = counts }

  if verbose then
    for _, s in ipairs(skipped) do
      if not profile.macros.disabled[s.name] then p(("Macro %s: no creada, %s."):format(s.name, s.reason)) end
    end
  end
  if not results then
    macrosPending = true
    if verbose then
      p("Estás en combate: las macros se crearán al salir.")
    end
    return
  end
  macrosPending = false
  lastMacroSignature = signature
  for _, r in ipairs(results) do
    if r.action == "error" then
      reportError("la macro " .. r.name, r.error)
    elseif verbose or r.action == "created" or r.action == "full" or r.action == "notCreated" then
      p(("Macro %s: %s."):format(r.name, MACRO_ACTION_TEXT[r.action] or r.action))
    end
  end
end

---------------------------------------------------------------------------
-- Recomendación
---------------------------------------------------------------------------

local function saveSnapshot()
  char.snapshot = {
    savedAt = time(),
    addonVersion = addonVersion(),
    client = clientInfo(),
    situation = last.situation,
    diagnostics = last.diagnostics,
    recommendation = last.recommendation,
  }
end

-- Cuándo se ve el asesor: la opción "Mostrar" y core/HudState.lua.
local function updateAdvisorVisibility()
  if not ui then return end
  local target = last.situation and last.situation.target
  local alpha = ns.Core.HudState.advisorAlpha({
    mode = profile.advisor.visibility,
    inCombat = frozen and true or false,
    hasTarget = target and target.exists and true or false,
  })
  ui:ApplyVisibility(profile.advisor.shown, alpha)
end

local function refresh()
  if frozen or not ui then return end
  safely("la recomendación", function()
    local situation, diagnostics = SituationReader.read(_G, ns.Data.TrackedSpells, { specOverride = char.specOverride })
    -- Rangos nuevos del grimorio: que el motor, las macros y el registro de
    -- peleas los reconozcan (cada rango tiene su propio spellID).
    ns.Data.LearnRanks(diagnostics.discoveredRanks)
    local recommendation = RuleEngine.recommend(situation, Rules, Seals)
    last = { situation = situation, diagnostics = diagnostics, recommendation = recommendation }
    ui:ShowRecommendation(recommendation)
    updateAdvisorVisibility()
    saveSnapshot()
    syncMacros(false)
  end)
end

-- Los eventos que piden recalcular llegan a menudo en ráfagas (SPELLS_CHANGED,
-- GROUP_ROSTER_UPDATE...): se agrupan en un solo cálculo.
local refreshQueued = false
local function scheduleRefresh()
  if refreshQueued then return end
  refreshQueued = true
  local function run()
    refreshQueued = false
    refresh()
  end
  if C_Timer and C_Timer.After then C_Timer.After(0.1, run) else run() end
end

local function setFrozen(value)
  frozen = value
  if ui then ui:SetFrozen(value) end
  updateAdvisorVisibility()
  if not value then
    refresh()
    if macrosPending then syncMacros(true) end
  end
end

---------------------------------------------------------------------------
-- Indicador de Unsealed Wrath
---------------------------------------------------------------------------

local function createEchoes()
  local container, err = ns.UI.EchoTracker.create(profile.echo, function(key, slotErr)
    reportError("el indicador de Echo (" .. key .. ")", slotErr)
  end)
  char.echoStatus = { time = time(), created = container ~= nil, error = err and tostring(err) or nil }
  if not container then
    reportError("el indicador de Echo", err)
    return nil
  end
  container:SetScale(profile.echo.scale)
  return container
end

local function setEchoShown(value)
  profile.echo.shown = value and true or false
  if value then
    echoes = echoes or createEchoes()
    if echoes then echoes:Show() end
  elseif echoes then
    echoes:Hide()
  end
end

local function toggleEchoMove()
  setEchoShown(true)
  if not echoes then return end
  echoes:SetUnlocked(not echoes.unlocked)
  p(echoes.unlocked and L.ECHO_UNLOCKED or L.ECHO_LOCKED)
end

---------------------------------------------------------------------------
-- Perfil: aplicar los ajustes a las ventanas
---------------------------------------------------------------------------

local function applyProfile()
  profile, char = db.profile, db.char
  ui:UseStore(profile.advisor)
  updateAdvisorVisibility()
  ui:SetScale(profile.advisor.scale)
  ui:SetLocked(profile.advisor.locked)
  if echoes then
    echoes:UseStore(profile.echo)
    echoes:SetScale(profile.echo.scale)
  end
  setEchoShown(profile.echo.shown)
  if ns.UI.Options.refresh then ns.UI.Options.refresh() end
end

---------------------------------------------------------------------------
-- Estadísticas, informe y depuración
---------------------------------------------------------------------------

local function printStats()
  for _, line in ipairs(ns.Recorder.statsLines(char)) do p(line) end
end

local function showReport()
  local s = last.situation
  local d = last.diagnostics or {}
  local ranks = {}
  for key, seal in pairs(Seals) do
    local known = {}
    for _, id in ipairs(seal.spellIds) do
      if s and s.player.knownSpells[id] then known[#known + 1] = id end
    end
    if #known > 0 then ranks[key] = known end
  end
  local summary = ns.Core.FightStats.summarize(char.fights)
  local fights = char.fights
  local text = ns.Core.Report.build({
    addonVersion = addonVersion(),
    client = clientInfo(),
    locale = GetLocale and GetLocale(),
    language = ns.Locales.active,
    level = s and s.player.level,
    spec = s and s.player.spec,
    specSource = d.specSource,
    weaponSpeed = s and s.player.weapon and s.player.weapon.speed
      and math.floor(s.player.weapon.speed * 100 + 0.5) / 100,
    spellPower = s and s.player.spellPower,
    ranks = ranks,
    settings = {
      advisor = profile.advisor.shown, echo = profile.echo.shown, macros = profile.macros.auto,
      chatSummary = profile.review.chatSummary, devMode = profile.devMode,
    },
    fightCount = #fights,
    commandPerMinute = summary.command and summary.command.perMinute,
    lastFight = fights[#fights] and ns.Recorder.describe(fights[#fights]),
    errors = char.errors,
    date = function(t) return date and date("%Y-%m-%d %H:%M", t) or tostring(t) end,
  })
  ns.UI.ReportWindow.show(text)
end

local function sortedKeys(set)
  local out = {}
  for k in pairs(set or {}) do out[#out + 1] = tostring(k) end
  table.sort(out)
  return table.concat(out, ", ")
end

local function describeSlot(name, entry)
  if not entry then return name .. ": (ninguno)" end
  return ("%s: %s (spellID %d, regla %s)"):format(name, entry.seal, entry.spellId, entry.ruleId)
end

-- /pfd debug (modo desarrollador): lo que ve el addon.
local function debug()
  local s, d, r = last.situation, last.diagnostics, last.recommendation
  if not s then p("Todavía no hay ninguna situación calculada.") return end
  p(("Spec: %s (fuente: %s)%s | nivel %s | contenido: %s"):format(
    tostring(s.player.spec), tostring(d.specSource),
    d.unknownSpecId and (" | ID de spec desconocido: %s, rol %s"):format(d.unknownSpecId, tostring(d.specRole)) or "",
    tostring(s.player.level), tostring(s.content)))
  p("Hechizos conocidos (spellIDs):", sortedKeys(s.player.knownSpells))
  if s.target.exists then
    local function show(field)
      if d.secret[field] then return "<secret>" end
      return tostring(s.target[field])
    end
    p(("Objetivo: tipo %s, clasificación %s, nivel %s"):format(
      show("creatureType"), show("classification"), show("level")))
  else
    p("Objetivo: ninguno atacable")
  end
  local w = s.player.weapon or {}
  local function stat(field, value)
    if d.secret[field] then return "<secret>" end
    if type(value) == "number" then return ("%g"):format(math.floor(value * 100 + 0.5) / 100) end
    return tostring(value)
  end
  p(("Arma: velocidad %s, daño %s-%s | poder con hechizos (Sagrado): %s"):format(
    stat("weaponSpeed", w.speed), stat("weaponDamage", w.minDamage), stat("weaponDamage", w.maxDamage),
    stat("spellPower", s.player.spellPower)))
  p(describeSlot("Sello", r.seal))
  p(describeSlot("Sentencia", r.judgement))
  if frozen then p("(congelado: estás en combate)") end
end

---------------------------------------------------------------------------
-- Opciones (ui/Options.lua)
---------------------------------------------------------------------------

local optionHandlers = {
  getAdvisorShown = function() return profile.advisor.shown end,
  setAdvisorShown = function(value)
    profile.advisor.shown = value
    updateAdvisorVisibility()
  end,
  getAdvisorVisibility = function() return profile.advisor.visibility end,
  setAdvisorVisibility = function(value)
    profile.advisor.visibility = value
    updateAdvisorVisibility()
  end,
  getReduceMotion = function() return profile.reduceMotion end,
  setReduceMotion = function(value) profile.reduceMotion = value and true or false end,
  getAdvisorLocked = function() return profile.advisor.locked end,
  setAdvisorLocked = function(value)
    profile.advisor.locked = value
    ui:SetLocked(value)
  end,
  getAdvisorScale = function() return profile.advisor.scale end,
  setAdvisorScale = function(value)
    profile.advisor.scale = value
    ui:SetScale(value)
  end,
  resetAdvisorPosition = function() ui:ResetPosition() end,

  getEchoShown = function() return profile.echo.shown end,
  setEchoShown = setEchoShown,
  getEchoScale = function() return profile.echo.scale end,
  setEchoScale = function(value)
    profile.echo.scale = value
    if echoes then echoes:SetScale(value) end
  end,
  toggleEchoMove = toggleEchoMove,
  resetEchoPosition = function()
    profile.echo.position = nil
    if echoes then echoes:ApplyPosition() end
    p(L.ECHO_RESET)
  end,

  getMacrosAuto = function() return profile.macros.auto end,
  setMacrosAuto = function(value)
    profile.macros.auto = value
    if value then syncMacros(true) end
  end,
  macroNames = ns.Core.Macros.ALL_NAMES,
  getMacroEnabled = function(name) return not profile.macros.disabled[name] end,
  setMacroEnabled = function(name, value) profile.macros.disabled[name] = (not value) or nil end,
  syncMacrosNow = function()
    profile.macros.auto = true
    refresh()
    syncMacros(true)
    ns.UI.Options.refresh()
  end,

  getChatSummary = function() return profile.review.chatSummary end,
  setChatSummary = function(value) profile.review.chatSummary = value end,
  printStats = printStats,
  resetFights = function()
    wipe(char.fights)
    p(L.FIGHTS_DELETED)
  end,

  getLanguage = function() return profile.language end,
  setLanguage = function(value)
    profile.language = value
    p(L.OPT_LANGUAGE_DESC)
  end,
  -- "Tus números" de la guía, con las peleas guardadas de este personaje.
  guideNumbers = function()
    local fights = char.fights or {}
    if #fights == 0 then return L.GUIDE_NUMBERS_EMPTY end
    local s = ns.Core.FightStats.summarize(fights, ns.Core.FightStyle.classify)
    local gold = ns.UI.Style.color
    local lines = { L.GUIDE_NUMBERS_FIGHTS:format(gold("gold", s.fights)) }
    if s.command then lines[#lines + 1] = L.GUIDE_NUMBERS_COMMAND:format(gold("gold", s.command.perMinute)) end
    local twist = s.byStyle and s.byStyle.twist
    if twist then lines[#lines + 1] = L.GUIDE_NUMBERS_TWIST:format(gold("gold", twist.fights)) end
    lines[#lines + 1] = "\n" .. L.GUIDE_NUMBERS_NOTE
    return table.concat(lines, "\n\n")
  end,
  getTone = function() return profile.tone end,
  setTone = function(value)
    profile.tone = value
    ns.Locales.setTone(value)
  end,
  getDevMode = function() return profile.devMode end,
  setDevMode = function(value) profile.devMode = value end,
  showReport = showReport,
  resetSettings = function() db:ResetProfile() end,
}

-- El juego no deja abrir el panel de opciones en combate (OpenSettingsPanel
-- queda bloqueado, visto en Forever el 12 nov): se abre al terminar la pelea.
local optionsPending = false

local function inCombat()
  local ok, value = pcall(InCombatLockdown)
  return ok and value == true
end

local function openOptions()
  if inCombat() then
    if not optionsPending then p(L.OPTIONS_AFTER_COMBAT) end
    optionsPending = true
    return
  end
  optionsPending = false
  if not ns.UI.Options.open() then p(L.OPTIONS_UNAVAILABLE) end
end

-- Entrada del menú de addons del minimapa (AddonCompartmentFunc en el .toc).
function PaladinForDummies_OnAddonCompartmentClick()
  if enabled then openOptions() else p(L.NOT_A_PALADIN) end
end

---------------------------------------------------------------------------
-- Arranque
---------------------------------------------------------------------------

local function initDatabase()
  local saved = PaladinForDummiesDB
  local legacy = ns.Core.Migrations.isLegacy(saved) and saved or nil
  if legacy then PaladinForDummiesDB = nil end

  db = LibStub("AceDB-3.0"):New("PaladinForDummiesDB", DEFAULTS, true)
  if legacy then
    local migrated = ns.Core.Migrations.fromLegacy(legacy)
    ns.Core.Migrations.apply(db.profile, migrated.profile)
    ns.Core.Migrations.apply(db.char, migrated.char)
  end
  profile, char = db.profile, db.char

  db.RegisterCallback(ns, "OnProfileChanged", applyProfile)
  db.RegisterCallback(ns, "OnProfileCopied", applyProfile)
  db.RegisterCallback(ns, "OnProfileReset", applyProfile)
end

local REFRESH_EVENTS = {
  "PLAYER_ENTERING_WORLD",
  "PLAYER_TARGET_CHANGED",
  "SPELLS_CHANGED",
  "PLAYER_LEVEL_UP",
  "GROUP_ROSTER_UPDATE",
  "ZONE_CHANGED_NEW_AREA",
  "PLAYER_SPECIALIZATION_CHANGED",
  "PLAYER_TALENT_UPDATE",
  "CHARACTER_POINTS_CHANGED",
}

local events = CreateFrame("Frame")

local function enable()
  initDatabase()
  ns.Locales.use(ns.Locales.resolve(profile.language, GetLocale and GetLocale() or "enUS"))
  ns.Locales.setTone(profile.tone)

  ns.UI.Style.reduceMotion = profile.reduceMotion
  ui = ns.UI.RecommendationFrame.create(profile.advisor)
  updateAdvisorVisibility()
  ui:SetScale(profile.advisor.scale)
  ui:SetLocked(profile.advisor.locked)
  ui:SetTest(char.test)
  if profile.echo.shown then echoes = createEchoes() end

  safely("el panel de opciones", ns.UI.Options.register, optionHandlers, db)

  events:RegisterEvent("PLAYER_REGEN_DISABLED")
  events:RegisterEvent("PLAYER_REGEN_ENABLED")
  events:RegisterEvent("ADDON_ACTION_BLOCKED")
  events:RegisterEvent("ADDON_ACTION_FORBIDDEN")
  events:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
  for _, event in ipairs(REFRESH_EVENTS) do
    -- Algunos eventos pueden no existir en Forever: registrar uno inexistente da error.
    pcall(events.RegisterEvent, events, event)
  end

  enabled = true
  setFrozen(InCombatLockdown() and true or false)

  if not char.welcomed then
    p(L.WELCOME_1)
    p(L.WELCOME_2)
    char.welcomed = true
  end
end

events:SetScript("OnEvent", function(_, event, arg1, arg2, arg3)
  if event == "ADDON_LOADED" then
    if arg1 ~= ADDON_NAME then return end
    events:UnregisterEvent("ADDON_LOADED")
    -- Con otras clases el addon no hace nada (ni crea su base de datos).
    if isPaladin() then safely("el arranque", enable) end
  elseif event == "ADDON_ACTION_BLOCKED" or event == "ADDON_ACTION_FORBIDDEN" then
    -- El juego bloqueó una función protegida: guardar cuál, para el informe.
    if arg1 == ADDON_NAME then reportError("acción bloqueada (" .. event .. ")", tostring(arg2)) end
  elseif event == "PLAYER_REGEN_DISABLED" then
    refresh() -- última lectura antes del pull: aún no estamos en combate
    safely("el inicio de la pelea", ns.Recorder.start, last.situation, char.test)
    setFrozen(true)
  elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
    safely("un lanzamiento", ns.Recorder.cast, arg3) -- arg3 = spellID
  elseif event == "PLAYER_REGEN_ENABLED" then
    safely("el final de la pelea", function()
      local record = ns.Recorder.finish(char)
      if record and profile.review.chatSummary then p(ns.Recorder.describe(record)) end
    end)
    setFrozen(false)
    if optionsPending then openOptions() end
  else
    scheduleRefresh()
  end
end)
events:RegisterEvent("ADDON_LOADED")

---------------------------------------------------------------------------
-- Comandos
---------------------------------------------------------------------------

local SPEC_ALIASES = {
  ret = "retribution", retribution = "retribution",
  prot = "protection", protection = "protection",
  holy = "holy",
}

local function help()
  p(L.HELP_HEADER)
  p(L.HELP_OPTIONS)
  p(L.HELP_STATS)
  p(L.HELP_REPORT)
  if profile.devMode then p(L.HELP_DEV) end
end

-- Comandos de diagnóstico: solo con el modo desarrollador.
local DEV_COMMANDS = {
  debug = debug,
  ui = function()
    for _, line in ipairs(ui:Describe()) do p(line) end
  end,
  echodebug = function()
    if not echoes then p("El indicador no está creado.") return end
    char.echoDebug = ns.UI.EchoTracker.describe()
    for _, line in ipairs(char.echoDebug) do p(line) end
  end,
  last = function()
    local fights = char.fights
    if #fights == 0 then p("Todavía no hay peleas guardadas.") return end
    p(ns.Recorder.describe(fights[#fights]))
  end,
  test = function(arg)
    if arg == "" then
      p(char.test and ("Prueba activa: " .. char.test) or "No hay ninguna prueba activa. Uso: /pfd test A | B | off")
      return
    end
    if arg == "off" then
      char.test = nil
    elseif arg:match("^%w+$") and #arg <= 12 then
      char.test = arg:upper()
    else
      p("Uso: /pfd test A | B | off (letras o números, máximo 12)")
      return
    end
    p(char.test and ("Prueba " .. char.test .. " activada.") or "Prueba desactivada.")
    ui:SetTest(char.test)
  end,
  spec = function(arg)
    if arg == "auto" then
      char.specOverride = nil
    elseif SPEC_ALIASES[arg] then
      char.specOverride = SPEC_ALIASES[arg]
    else
      p("Uso: /pfd spec ret | prot | holy | auto")
      return
    end
    p("Spec: " .. (char.specOverride or "automática"))
    refresh()
  end,
}

SLASH_PALADINFORDUMMIES1 = "/pfd"
SLASH_PALADINFORDUMMIES2 = "/paladinfordummies"
SlashCmdList.PALADINFORDUMMIES = function(msg)
  if not enabled then
    p(L.NOT_A_PALADIN)
    return
  end
  local cmd, arg = (msg or ""):lower():match("^(%S*)%s*(%S*)")
  if cmd == "" or cmd == "options" or cmd == "opciones" or cmd == "config" then
    openOptions()
  elseif cmd == "stats" then
    printStats()
  elseif cmd == "report" or cmd == "informe" then
    showReport()
  elseif DEV_COMMANDS[cmd] then
    if profile.devMode then DEV_COMMANDS[cmd](arg) else p(L.DEV_ONLY) end
  else
    help()
  end
end
