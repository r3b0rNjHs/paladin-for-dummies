-- Arranque: eventos, SavedVariables y comandos.
-- Regla 1 de CLAUDE.md: en combate no se calcula nada. Al entrar en combate la
-- recomendación se congela y solo se vuelve a calcular al salir. Durante la pelea
-- solo se anotan tus lanzamientos para el repaso (Recorder.lua).
local ADDON_NAME, ns = ...

local SituationReader = ns.Adapters.SituationReader
local RuleEngine = ns.Core.RuleEngine
local Seals, Rules = ns.Data.Seals, ns.Data.Rules

local db
local ui
local echoes -- widget experimental de Unsealed Wrath (ui/EchoTracker.lua)
local frozen = false
local last = {} -- última situación calculada, para /pfd debug

local function p(...)
  print("|cfff5b041Paladin for Dummies|r:", ...)
end

local MAX_ERRORS = 50

-- Los errores se muestran en el chat y se guardan en SavedVariables (db.errors),
-- para que lleguen en el archivo aunque se pierdan del chat.
local function reportError(context, err)
  p("Error en " .. context .. ":", err)
  if not db then return end
  db.errors = db.errors or {}
  table.insert(db.errors, { time = time(), context = context, message = tostring(err) })
  while #db.errors > MAX_ERRORS do table.remove(db.errors, 1) end
end

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

-- Lo mismo que muestra /pfd debug, guardado en SavedVariables (db.snapshot).
-- La Situation ya viene sin valores secret (regla 4).
local function saveSnapshot()
  db.snapshot = {
    savedAt = time(),
    addonVersion = addonVersion(),
    client = clientInfo(),
    situation = last.situation,
    diagnostics = last.diagnostics,
    recommendation = last.recommendation,
  }
end

local MACRO_ACTION_TEXT = {
  created = "creada",
  updated = "actualizada",
  unchanged = "sin cambios",
  full = "no hay hueco libre en tus macros de personaje",
}

local function spellNameOf(spellId)
  if not (C_Spell and C_Spell.GetSpellName) then return nil end
  local ok, name = pcall(C_Spell.GetSpellName, spellId)
  if not ok or type(name) ~= "string" or (issecretvalue and issecretvalue(name)) then return nil end
  return name
end

-- Crea o actualiza las macros del addon (core/Macros.lua) a partir de la última
-- recomendación. Solo fuera de combate; verbose = contarlo en el chat.
local macrosPending = false
local function syncMacros(verbose)
  if not (db and db.macros and last.situation) then return end
  local macros, skipped = ns.Core.Macros.build({
    recommendation = last.recommendation,
    seals = Seals,
    macroSpells = ns.Data.MacroSpells,
    knownSpells = last.situation.player.knownSpells,
    judgementSpellId = ns.Data.Spells.judgement,
    holyStrikeSpellId = ns.Data.Spells.holyStrike,
    nameOf = spellNameOf,
  })
  local results, reason = ns.Adapters.MacroWriter.write(_G, macros)
  -- Queda en el archivo de SavedVariables para poder revisarlo.
  db.macroStatus = { time = time(), results = results, skipped = skipped, reason = reason }
  if verbose then
    for _, s in ipairs(skipped) do p(("Macro %s: no creada, %s."):format(s.name, s.reason)) end
  end
  if not results then
    macrosPending = (reason == "combat")
    if verbose then p("Estás en combate: las macros se crearán al salir.") end
    return
  end
  macrosPending = false
  for _, r in ipairs(results) do
    if r.action == "error" then
      reportError("la macro " .. r.name, r.error)
    elseif verbose or r.action == "created" or r.action == "full" then
      p(("Macro %s: %s."):format(r.name, MACRO_ACTION_TEXT[r.action] or r.action))
    end
  end
end

local function refresh()
  if frozen or not ui then return end
  local ok, err = pcall(function()
    -- TrackedSpells viene de data/MacroSpells.lua; si falta (archivo nuevo sin
    -- reiniciar el juego), al menos se leen los sellos.
    local situation, diagnostics = SituationReader.read(_G, ns.Data.TrackedSpells or Seals, { specOverride = db.specOverride })
    local recommendation = RuleEngine.recommend(situation, Rules, Seals)
    last = { situation = situation, diagnostics = diagnostics, recommendation = recommendation }
    ui:ShowRecommendation(recommendation)
    saveSnapshot()
    syncMacros(false)
  end)
  if not ok then reportError("la recomendación", err) end
end

-- Crea el widget de copias de Unsealed Wrath y guarda en db.echoStatus si
-- funcionó, para verlo en el archivo de SavedVariables.
local function createEchoes()
  local container, err = ns.UI.EchoTracker.create(db, function(key, slotErr)
    reportError("el widget de Echo (" .. key .. ")", slotErr)
  end)
  db.echoStatus = { time = time(), created = container ~= nil, error = err and tostring(err) or nil }
  if not container then
    reportError("el widget de Echo", err)
    return nil
  end
  return container
end

local function setFrozen(value)
  frozen = value
  if ui then ui:SetFrozen(value) end
  if not value then
    refresh()
    if macrosPending then syncMacros(true) end
  end
end

---------------------------------------------------------------------------
-- /pfd debug: lo que ve el addon, para comprobarlo en el juego
---------------------------------------------------------------------------

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
-- Eventos
---------------------------------------------------------------------------

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

local function safely(label, fn, ...)
  local ok, err = pcall(fn, ...)
  if not ok then reportError(label, err) end
end

events:SetScript("OnEvent", function(_, event, arg1, _, arg3)
  if event == "ADDON_LOADED" then
    if arg1 ~= ADDON_NAME then return end
    PaladinForDummiesDB = PaladinForDummiesDB or {}
    db = PaladinForDummiesDB
    ui = ns.UI.RecommendationFrame.create(db)
    if db.hidden then ui:Hide() end
    ui:SetTest(db.test)
    if db.echo then echoes = createEchoes() end
    setFrozen(InCombatLockdown() and true or false)
  elseif event == "PLAYER_REGEN_DISABLED" then
    if not db then return end
    refresh() -- última lectura antes del pull: aún no estamos en combate
    safely("el inicio de la pelea", ns.Recorder.start, last.situation, db.test)
    setFrozen(true)
  elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
    safely("un lanzamiento", ns.Recorder.cast, arg3) -- arg3 = spellID
  elseif event == "PLAYER_REGEN_ENABLED" then
    if not db then return end
    safely("el final de la pelea", function()
      local record = ns.Recorder.finish(db)
      if record and not db.quiet then p(ns.Recorder.describe(record)) end
    end)
    setFrozen(false)
  else
    refresh()
  end
end)

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
for _, event in ipairs(REFRESH_EVENTS) do
  -- Algunos eventos pueden no existir en Forever: registrar uno inexistente da error.
  local ok = pcall(events.RegisterEvent, events, event)
  if not ok then last.missingEvents = (last.missingEvents or "") .. event .. " " end
end

---------------------------------------------------------------------------
-- Comandos
---------------------------------------------------------------------------

local SPEC_ALIASES = {
  ret = "retribution", retribution = "retribution",
  prot = "protection", protection = "protection",
  holy = "holy",
}

SLASH_PALADINFORDUMMIES1 = "/pfd"
SlashCmdList.PALADINFORDUMMIES = function(msg)
  local cmd, arg = (msg or ""):lower():match("^(%S*)%s*(%S*)")
  if cmd == "debug" then
    debug()
  elseif cmd == "spec" then
    if arg == "auto" then
      db.specOverride = nil
      p("Spec automática.")
    elseif SPEC_ALIASES[arg] then
      db.specOverride = SPEC_ALIASES[arg]
      p("Spec fijada a mano:", db.specOverride)
    else
      p("Uso: /pfd spec ret | prot | holy | auto")
      return
    end
    refresh()
  elseif cmd == "show" then
    db.hidden = nil
    ui:Show()
  elseif cmd == "hide" then
    db.hidden = true
    ui:Hide()
  elseif cmd == "ui" then
    if not ui then p("La ventana no se ha creado.") return end
    for _, line in ipairs(ui:Describe()) do p(line) end
  elseif cmd == "test" then
    if arg == "" then
      p(db.test and ("Prueba activa: " .. db.test) or "No hay ninguna prueba activa. Uso: /pfd test A | B | C | off")
      return
    end
    if arg == "off" then
      db.test = nil
      p("Prueba desactivada: las peleas siguientes no se etiquetan.")
    elseif arg:match("^%w+$") and #arg <= 12 then
      db.test = arg:upper()
      p(("Prueba %s activada: las peleas siguientes se etiquetan como %s. /pfd test off para quitarla."):format(db.test, db.test))
    else
      p("Uso: /pfd test A | B | C | off (letras o números, máximo 12)")
      return
    end
    ui:SetTest(db.test)
  elseif cmd == "echo" and arg == "move" then
    if not echoes then p("Activa primero el widget con /pfd echo.") return end
    echoes:Show()
    echoes:SetUnlocked(not echoes.unlocked)
    p(echoes.unlocked and "Widget desbloqueado: arrástralo y escribe /pfd echo move para fijarlo."
      or "Widget fijado en su sitio.")
  elseif cmd == "echo" and arg == "debug" then
    if not echoes then p("Activa primero el widget con /pfd echo.") return end
    for _, line in ipairs(ns.UI.EchoTracker.describe()) do p(line) end
    db.echoDebug = ns.UI.EchoTracker.describe()
  elseif cmd == "echo" and arg == "reset" then
    db.echoPosition = nil
    if echoes then echoes:ApplyPosition() end
    p("Widget de vuelta a su sitio inicial.")
  elseif cmd == "echo" then
    if not echoes then
      echoes = createEchoes()
      if echoes then
        db.echo = true
        p("Widget de Unsealed Wrath activado (experimental). Aparece cuando tienes Echo of Command o Echo of Righteousness. /pfd echo move para moverlo, /pfd echo para ocultarlo.")
      end
    elseif echoes:IsShown() then
      echoes:Hide()
      db.echo = nil
      p("Widget de Unsealed Wrath oculto.")
    else
      echoes:Show()
      db.echo = true
      p("Widget de Unsealed Wrath visible.")
    end
  elseif cmd == "macros" then
    if arg == "off" then
      db.macros = nil
      p("Las macros ya no se actualizan solas. Siguen en tu lista de macros; puedes borrarlas desde /macro.")
      return
    end
    db.macros = true
    refresh()
    syncMacros(true)
    p("Ábrelas con /macro, pestaña de tu personaje, y arrástralas a tu barra. Se actualizan solas si aprendes rangos nuevos. /pfd macros off para dejar de actualizarlas.")
  elseif cmd == "stats" then
    for _, line in ipairs(ns.Recorder.statsLines(db)) do p(line) end
  elseif cmd == "last" then
    local fights = db.fights or {}
    if #fights == 0 then p("Todavía no hay peleas guardadas.") return end
    p(ns.Recorder.describe(fights[#fights]))
  elseif cmd == "quiet" then
    db.quiet = not db.quiet or nil
    p(db.quiet and "Resumen tras cada pelea: desactivado." or "Resumen tras cada pelea: activado.")
  elseif cmd == "resetstats" then
    db.fights = {}
    p("Peleas guardadas borradas.")
  elseif cmd == "reset" then
    ui:ResetPosition()
    p("Posición restablecida.")
  else
    p("Comandos: /pfd debug | ui | echo [move|reset|debug] | macros [off] | test A|B|C|off | stats | last | quiet | resetstats | spec ret|prot|holy|auto | show | hide | reset")
  end
end
