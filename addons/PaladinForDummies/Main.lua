-- Arranque: eventos, SavedVariables y comandos.
-- Regla 1 de CLAUDE.md: en combate no se calcula nada. Al entrar en combate la
-- recomendación se congela y solo se vuelve a calcular al salir.
local ADDON_NAME, ns = ...

local SituationReader = ns.Adapters.SituationReader
local RuleEngine = ns.Core.RuleEngine
local Seals, Rules = ns.Data.Seals, ns.Data.Rules

local db
local ui
local frozen = false
local last = {} -- última situación calculada, para /pfd debug

local function p(...)
  print("|cfff5b041Paladin for Dummies|r:", ...)
end

local function refresh()
  if frozen or not ui then return end
  local ok, err = pcall(function()
    local situation, diagnostics = SituationReader.read(_G, Seals, { specOverride = db.specOverride })
    local recommendation = RuleEngine.recommend(situation, Rules, Seals)
    last = { situation = situation, diagnostics = diagnostics, recommendation = recommendation }
    ui:ShowRecommendation(recommendation)
  end)
  if not ok then p("Error al calcular la recomendación:", err) end
end

local function setFrozen(value)
  frozen = value
  if ui then ui:SetFrozen(value) end
  if not value then refresh() end
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
  p("Sellos conocidos (spellIDs):", sortedKeys(s.player.knownSpells))
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

events:SetScript("OnEvent", function(_, event, arg1)
  if event == "ADDON_LOADED" then
    if arg1 ~= ADDON_NAME then return end
    PaladinForDummiesDB = PaladinForDummiesDB or {}
    db = PaladinForDummiesDB
    ui = ns.UI.RecommendationFrame.create(db)
    if db.hidden then ui:Hide() end
    setFrozen(InCombatLockdown() and true or false)
  elseif event == "PLAYER_REGEN_DISABLED" then
    setFrozen(true)
  elseif event == "PLAYER_REGEN_ENABLED" then
    setFrozen(false)
  else
    refresh()
  end
end)

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_REGEN_DISABLED")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
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
  elseif cmd == "reset" then
    ui:ResetPosition()
    p("Posición restablecida.")
  else
    p("Comandos: /pfd debug | ui | spec ret|prot|holy|auto | show | hide | reset")
  end
end
