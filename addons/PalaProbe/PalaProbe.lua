-- PalaProbe: sondeo de la API de WoW Forever (Interface 16001).
-- Objetivo: averiguar en el cliente real que es legible, que es "secret" y que esta protegido,
-- y volcar el grimorio del paladin (descripciones reales de sellos y sentencias).
-- Regla de oro: nunca comparar, indexar ni operar con un valor sin comprobar antes si es secret.

local ADDON_NAME = ...
local PREFIX = "PalaProbe"
local MAX_LOG = 600

local db
local fightStart

---------------------------------------------------------------------------
-- Utilidades
---------------------------------------------------------------------------

local function p(...)
  print("|cff66ccffPalaProbe|r:", ...)
end

local hasIsSecret = type(issecretvalue) == "function"

local function isSecret(v)
  if not hasIsSecret then return false end
  local ok, res = pcall(issecretvalue, v)
  if not ok then return false end
  -- res es un booleano normal (no secret) segun la documentacion
  return res == true
end

-- Describe un valor sin tocarlo si es secret. Nunca guardamos secrets en SavedVariables.
local function describe(v)
  local d = { type = type(v), secret = isSecret(v) }
  if not d.secret then
    if d.type == "table" then
      d.value = "<table>"
    elseif d.type ~= "nil" then
      local ok, s = pcall(tostring, v)
      d.value = ok and s or "<tostring error>"
    end
  end
  return d
end

local function inCombat()
  return InCombatLockdown() and true or false
end

local function log(kind, data)
  data = data or {}
  data.kind = kind
  data.t = GetTime()
  data.time = time()
  data.combat = inCombat()
  local inInstance, instanceType = IsInInstance()
  data.instance = inInstance and (instanceType or "?") or "none"
  table.insert(db.log, data)
  while #db.log > MAX_LOG do table.remove(db.log, 1) end
end

local function resolve(path)
  local cur = _G
  for part in string.gmatch(path, "[^%.]+") do
    if type(cur) ~= "table" then return nil end
    cur = cur[part]
  end
  return cur
end

---------------------------------------------------------------------------
-- 1. Capacidades del cliente: que APIs existen
---------------------------------------------------------------------------

local CAPABILITIES = {
  "issecretvalue",
  "C_Secrets",
  "C_CurveUtil",
  "C_CurveUtil.CreateColorCurve",
  "C_CurveUtil.EvaluateColorValueFromBoolean",
  "C_AssistedCombat",
  "C_GameRules",
  "C_Spell.GetSpellInfo",
  "C_Spell.GetSpellDescription",
  "C_Spell.GetSpellPowerCost",
  "C_SpellBook.GetSpellBookItemInfo",
  "C_UnitAuras.GetAuraDataByIndex",
  "C_UnitAuras.GetPlayerAuraBySpellID",
  "C_ChatInfo.SendAddonMessage",
  "C_Map.SetUserWaypoint",
  "C_SuperTrack.SetSuperTrackedUserWaypoint",
  "C_Macro",
  "CreateMacro",
  "EditMacro",
  "GetPlayerFacing",
  "UnitCreatureType",
  "UnitClassification",
  "CombatLogGetCurrentEventInfo",
}

local function checkCapabilities()
  local caps = {}
  for _, path in ipairs(CAPABILITIES) do
    caps[path] = type(resolve(path))
  end
  db.capabilities = caps
  return caps
end

---------------------------------------------------------------------------
-- 2. Instantanea: que valores son secret en este momento
---------------------------------------------------------------------------

local function snapshot(reason)
  local s = { reason = reason, values = {} }

  local function probe(label, fn, ...)
    if type(fn) ~= "function" then
      s.values[label] = { missing = true }
      return
    end
    local ok, a, b = pcall(fn, ...)
    if not ok then
      s.values[label] = { error = tostring(a) }
      return
    end
    s.values[label] = describe(a)
    if b ~= nil then s.values[label .. "#2"] = describe(b) end
  end

  -- Objetivo
  probe("UnitExists(target)", UnitExists, "target")
  probe("UnitName(target)", UnitName, "target")
  probe("UnitCreatureType(target)", UnitCreatureType, "target")
  probe("UnitClassification(target)", UnitClassification, "target")
  probe("UnitLevel(target)", UnitLevel, "target")
  probe("UnitHealth(target)", UnitHealth, "target")
  probe("UnitHealthMax(target)", UnitHealthMax, "target")
  probe("UnitCanAttack(player,target)", UnitCanAttack, "player", "target")
  probe("UnitIsPlayer(target)", UnitIsPlayer, "target")

  -- Jugador
  local manaType = (Enum and Enum.PowerType and Enum.PowerType.Mana) or 0
  probe("UnitPower(player,mana)", UnitPower, "player", manaType)
  probe("UnitPowerMax(player,mana)", UnitPowerMax, "player", manaType)
  probe("UnitHealth(player)", UnitHealth, "player")
  probe("GetPlayerFacing()", GetPlayerFacing)
  probe("C_Map.GetBestMapForUnit(player)", C_Map and C_Map.GetBestMapForUnit, "player")

  -- Posicion (devuelve un objeto; probamos GetXY aparte)
  pcall(function()
    local mapID = C_Map.GetBestMapForUnit("player")
    if isSecret(mapID) or not mapID then return end
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos or isSecret(pos) then
      s.values["PlayerMapPosition"] = describe(pos)
      return
    end
    local x, y = pos:GetXY()
    s.values["PlayerMapPosition.x"] = describe(x)
    s.values["PlayerMapPosition.y"] = describe(y)
  end)

  -- Grupo e instancia
  probe("IsInGroup()", IsInGroup)
  probe("GetNumGroupMembers()", GetNumGroupMembers)
  probe("GetInstanceInfo()", GetInstanceInfo)

  -- Auras del jugador (los sellos son auras). Cada campo por separado.
  if C_UnitAuras and C_UnitAuras.GetAuraDataByIndex then
    for i = 1, 12 do
      local ok, aura = pcall(C_UnitAuras.GetAuraDataByIndex, "player", i, "HELPFUL")
      if not ok then
        s.values["aura" .. i] = { error = tostring(aura) }
        break
      end
      if type(aura) ~= "table" then break end
      for _, field in ipairs({ "name", "spellId", "duration", "expirationTime", "applications" }) do
        local okField, v = pcall(function() return aura[field] end)
        s.values["aura" .. i .. "." .. field] = okField and describe(v) or { error = "index error" }
      end
    end
  end

  log("snapshot", s)
  return s
end

---------------------------------------------------------------------------
-- 3. Volcado del grimorio
---------------------------------------------------------------------------

local function dumpSpellbook()
  if not (C_SpellBook and C_SpellBook.GetNumSpellBookSkillLines and C_Spell) then
    p("C_SpellBook o C_Spell no disponibles en este cliente.")
    return
  end
  local bank = (Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player) or 0
  local spells, empty = {}, 0

  for line = 1, C_SpellBook.GetNumSpellBookSkillLines() do
    local info = C_SpellBook.GetSpellBookSkillLineInfo(line)
    if info and info.numSpellBookItems then
      for i = info.itemIndexOffset + 1, info.itemIndexOffset + info.numSpellBookItems do
        local ok, err = pcall(function()
          local item = C_SpellBook.GetSpellBookItemInfo(i, bank)
          if not item or not item.spellID then return end
          local id = item.spellID
          local spell = C_Spell.GetSpellInfo(id)
          local desc = C_Spell.GetSpellDescription(id)
          if isSecret(desc) then desc = "<secret>" end
          if desc == nil or desc == "" then
            empty = empty + 1
            if C_Spell.RequestLoadSpellData then C_Spell.RequestLoadSpellData(id) end
          end
          local costs = C_Spell.GetSpellPowerCost and C_Spell.GetSpellPowerCost(id)
          local cost = type(costs) == "table" and costs[1] or nil
          spells[#spells + 1] = {
            spellID = id,
            name = item.name or (spell and spell.name),
            subtext = C_Spell.GetSpellSubtext and C_Spell.GetSpellSubtext(id) or nil,
            skillLine = info.name,
            isPassive = item.isPassive,
            description = desc,
            cost = cost and cost.cost or nil,
            costPercent = cost and cost.costPercent or nil,
            costType = cost and cost.name or nil,
            castTime = spell and spell.castTime or nil,
            maxRange = spell and spell.maxRange or nil,
          }
        end)
        if not ok then p("Error en el hechizo", i, err) end
      end
    end
  end

  local _, classFile = UnitClass("player")
  db.spellbook = {
    time = time(),
    level = UnitLevel("player"),
    class = classFile,
    locale = GetLocale(),
    spells = spells,
  }
  p(("Grimorio volcado: %d hechizos, %d sin descripcion."):format(#spells, empty))
  if empty > 0 then
    p("Espera unos segundos y repite /pp dump para completar las descripciones.")
  end
  p("Se guarda en disco al hacer /reload o al salir.")
end

---------------------------------------------------------------------------
-- 4. Pruebas manuales: mensajes de addon, waypoint, curvas
---------------------------------------------------------------------------

local function testComm()
  local channel, target
  if IsInRaid() then
    channel = "RAID"
  elseif IsInGroup() then
    channel = "PARTY"
  else
    channel, target = "WHISPER", UnitName("player")
  end
  local ok, result = pcall(C_ChatInfo.SendAddonMessage, PREFIX, "ping " .. time(), channel, target)
  log("comm_send", { channel = channel, ok = ok, result = describe(result) })
  p("Mensaje de addon por", channel, "->", ok and tostring(result) or ("error: " .. tostring(result)))
end

local function testWaypoint()
  local ok, err = pcall(function()
    local mapID = C_Map.GetBestMapForUnit("player")
    local pos = mapID and C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then error("sin posicion en este mapa") end
    local x, y = pos:GetXY()
    local point = UiMapPoint.CreateFromCoordinates(mapID, math.min(x + 0.02, 1), y)
    C_Map.SetUserWaypoint(point)
    if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
      C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    end
  end)
  log("waypoint_test", { ok = ok, err = err and tostring(err) or nil })
  p("Waypoint:", ok and "llamadas hechas (mira si aparece el marcador en el mundo)" or ("error: " .. tostring(err)))
end

local function testCurve()
  local fn = C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean
  if type(fn) ~= "function" then
    log("curve_test", { missing = true })
    p("C_CurveUtil.EvaluateColorValueFromBoolean no existe en este cliente.")
    return
  end
  local okT, vT = pcall(fn, true, 1, 0.2)
  local okF, vF = pcall(fn, false, 1, 0.2)
  log("curve_test", { okTrue = okT, valueTrue = describe(vT), okFalse = okF, valueFalse = describe(vF) })
  p("Curva con true:", okT and tostring(vT) or "error", "| con false:", okF and tostring(vF) or "error")
end

---------------------------------------------------------------------------
-- 5. Informe resumido
---------------------------------------------------------------------------

local function report()
  local secretIn, secretOut, seenIn, seenOut = {}, {}, 0, 0
  for _, e in ipairs(db.log) do
    if e.kind == "snapshot" and e.values then
      if e.combat then seenIn = seenIn + 1 else seenOut = seenOut + 1 end
      for label, d in pairs(e.values) do
        if d.secret then
          if e.combat then secretIn[label] = true else secretOut[label] = true end
        end
      end
    end
  end
  local function keys(t)
    local out = {}
    for k in pairs(t) do out[#out + 1] = k end
    table.sort(out)
    return #out > 0 and table.concat(out, ", ") or "(ninguno)"
  end
  p(("Instantaneas: %d fuera de combate, %d en combate."):format(seenOut, seenIn))
  p("Secret FUERA de combate:", keys(secretOut))
  p("Secret EN combate:", keys(secretIn))
  local casts, secretCasts = 0, 0
  for _, e in ipairs(db.log) do
    if e.kind == "cast" and e.combat then
      casts = casts + 1
      if e.spellID and e.spellID.secret then secretCasts = secretCasts + 1 end
    end
  end
  p(("Lanzamientos propios en combate: %d, con spellID secret: %d."):format(casts, secretCasts))
end

---------------------------------------------------------------------------
-- Eventos
---------------------------------------------------------------------------

local frame = CreateFrame("Frame")
local lastTargetSnap = 0

local handlers = {}

function handlers.ADDON_LOADED(name)
  if name ~= ADDON_NAME then return end
  PalaProbeDB = PalaProbeDB or {}
  db = PalaProbeDB
  db.log = db.log or {}
  local version, build, date, toc = GetBuildInfo()
  db.client = {
    version = version, build = build, date = date, toc = toc,
    projectID = WOW_PROJECT_ID, locale = GetLocale(),
  }
  if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
    C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
  end
end

function handlers.PLAYER_LOGIN()
  local caps = checkCapabilities()
  local missing = {}
  for path, t in pairs(caps) do
    if t == "nil" then missing[#missing + 1] = path end
  end
  table.sort(missing)
  p(("Cliente %s (toc %s, projectID %s). Escribe /pp para ver comandos."):format(
    tostring(db.client.version), tostring(db.client.toc), tostring(db.client.projectID)))
  if #missing > 0 then p("APIs que no existen:", table.concat(missing, ", ")) end
end

function handlers.PLAYER_REGEN_DISABLED()
  fightStart = GetTime()
  snapshot("combat_start")
  C_Timer.After(1.5, function()
    if inCombat() then snapshot("in_combat_1.5s") end
  end)
end

function handlers.PLAYER_REGEN_ENABLED()
  local duration = fightStart and (GetTime() - fightStart) or nil
  fightStart = nil
  log("fight_end", { duration = duration })
  snapshot("combat_end")
end

function handlers.PLAYER_TARGET_CHANGED()
  local now = GetTime()
  if now - lastTargetSnap < 2 then return end
  lastTargetSnap = now
  snapshot(inCombat() and "target_in_combat" or "target_out_of_combat")
end

function handlers.UNIT_SPELLCAST_SUCCEEDED(unit, castGUID, spellID)
  local entry = { spellID = describe(spellID), castGUID = describe(castGUID) }
  if not isSecret(spellID) and C_Spell and C_Spell.GetSpellName then
    local ok, name = pcall(C_Spell.GetSpellName, spellID)
    if ok and not isSecret(name) then entry.name = name end
  end
  log("cast", entry)
end

function handlers.ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
  log("encounter_start", {
    encounterID = describe(encounterID), encounterName = describe(encounterName),
    difficultyID = describe(difficultyID), groupSize = describe(groupSize),
  })
  p("ENCOUNTER_START recibido (revisa el informe).")
end

function handlers.ENCOUNTER_END(encounterID, encounterName, difficultyID, groupSize, success)
  log("encounter_end", { encounterID = describe(encounterID), success = describe(success) })
end

function handlers.CHAT_MSG_ADDON(prefix, text, channel, sender)
  if prefix ~= PREFIX then return end
  log("comm_receive", { text = describe(text), channel = channel, sender = describe(sender) })
  p("Mensaje de addon recibido por", channel)
end

function handlers.ADDON_ACTION_BLOCKED(addon, func)
  log("action_blocked", { addon = addon, func = func })
  if addon == ADDON_NAME then p("Accion BLOQUEADA:", tostring(func)) end
end

function handlers.ADDON_ACTION_FORBIDDEN(addon, func)
  log("action_forbidden", { addon = addon, func = func })
  if addon == ADDON_NAME then p("Accion PROHIBIDA:", tostring(func)) end
end

frame:SetScript("OnEvent", function(_, event, ...)
  local h = handlers[event]
  if h and (db or event == "ADDON_LOADED") then
    local ok, err = pcall(h, ...)
    if not ok then p("Error en", event, err) end
  end
end)

for event in pairs(handlers) do
  local ok, err
  if event == "UNIT_SPELLCAST_SUCCEEDED" then
    ok, err = pcall(frame.RegisterUnitEvent, frame, event, "player")
  else
    ok, err = pcall(frame.RegisterEvent, frame, event)
  end
  if not ok then print("PalaProbe: no se pudo registrar", event, err) end
end

---------------------------------------------------------------------------
-- Comandos
---------------------------------------------------------------------------

SLASH_PALAPROBE1 = "/pp"
SlashCmdList.PALAPROBE = function(msg)
  local cmd = (msg or ""):match("^(%S*)"):lower()
  if cmd == "snap" then
    snapshot("manual")
    p("Instantanea guardada.")
  elseif cmd == "dump" then
    dumpSpellbook()
  elseif cmd == "comm" then
    testComm()
  elseif cmd == "waypoint" then
    testWaypoint()
  elseif cmd == "curve" then
    testCurve()
  elseif cmd == "report" then
    report()
  elseif cmd == "caps" then
    checkCapabilities()
    for path, t in pairs(db.capabilities) do p(path, "=", t) end
  elseif cmd == "clear" then
    wipe(db.log)
    p("Registro borrado.")
  else
    p("Comandos: /pp dump | snap | report | comm | waypoint | curve | caps | clear")
  end
end
