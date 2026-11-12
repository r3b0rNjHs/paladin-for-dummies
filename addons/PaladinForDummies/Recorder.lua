-- Repaso tras el combate: graba cada pelea y resume las estadísticas.
-- Graba, no decide: en combate solo se anotan tus lanzamientos (que no son secret)
-- y la recomendación sigue congelada (regla 1). Nada secret llega a SavedVariables
-- (regla 4): el adaptador y Fight.cast descartan lo que no es un número legible.
local _, ns = ...

local Fight, FightStats, FightStyle = ns.Core.Fight, ns.Core.FightStats, ns.Core.FightStyle
local FightReader = ns.Adapters.FightReader
local Catalog, Seals = ns.Data.Catalog, ns.Data.Seals

local MAX_FIGHTS = 1000

local Recorder = {}
ns.Recorder = Recorder

local current

local function spellName(spellId)
  if C_Spell and C_Spell.GetSpellName then
    local ok, name = pcall(C_Spell.GetSpellName, spellId)
    if ok and type(name) == "string" and not (issecretvalue and issecretvalue(name)) then return name end
  end
  return nil
end

local function sealName(key)
  if key == "none" or not key then return "sin sello" end
  local ids = Seals[key] and Seals[key].spellIds
  return (ids and ids[1] and spellName(ids[1])) or key
end

-- situation: la última calculada antes del pull (ya sin secrets).
-- test: la prueba activa (/pfd test), o nil.
function Recorder.start(situation, test)
  local opening = FightReader.readOpening(_G, Catalog)
  if not opening.t then return end
  local context = {}
  if situation then
    local player, target = situation.player, situation.target
    context = {
      content = situation.content,
      spec = player.spec,
      playerLevel = player.level,
      weaponSpeed = player.weapon and player.weapon.speed,
      spellPower = player.spellPower,
      target = target.exists and {
        creatureType = target.creatureType,
        classification = target.classification,
        level = target.level,
      } or nil,
    }
  end
  context.test = test
  -- UnitAttackSpeed da la velocidad actual: con Crusader puesto, un 40% más
  -- rápida. Se guarda también la base para poder comparar armas.
  if context.weaponSpeed then
    context.weaponSpeedHastedByCrusader = (opening.seal == "crusader") or nil
    context.weaponBaseSpeed = (opening.seal == "crusader") and (context.weaponSpeed * 1.4) or context.weaponSpeed
  end
  current = Fight.start(Catalog, opening, context)
end

function Recorder.cast(spellId)
  if not current then return end
  if issecretvalue and issecretvalue(spellId) then return end
  Fight.cast(current, GetTime(), spellId)
end

-- Devuelve el registro de la pelea, o nil si no había ninguna en curso.
function Recorder.finish(db)
  if not current then return nil end
  local record = Fight.finish(current, { t = GetTime(), time = time() })
  current = nil
  db.fights = db.fights or {}
  table.insert(db.fights, record)
  while #db.fights > MAX_FIGHTS do table.remove(db.fights, 1) end
  return record
end

-- Nombre legible de un estilo de core/FightStyle.lua.
local function styleName(style)
  local kind, seal = style:match("^([^:]+):?(.*)$")
  if kind == "solo" then return "Solo " .. sealName(seal) end
  if kind == "crusader-then" then return sealName("crusader") .. " y luego " .. sealName(seal) end
  if kind == "twist" then return "Cambio de sellos (Unsealed Wrath)" end
  if kind == "none" then return "Sin sello" end
  return "Mezcla de sellos"
end

function Recorder.describe(record)
  local c = record.counts
  local test = record.context and record.context.test
  return ("%s%s | %s s | Sentencias: %d | Holy Strike: %d | activaciones de Command: %d"):format(
    test and ("[prueba " .. test .. "] ") or "",
    styleName(FightStyle.classify(record)), tostring(record.duration),
    c.judgement, c.holyStrike, c.commandProc)
end

-- Una línea por grupo, y otra con la tasa de Command si la hay.
local function groupLines(lines, title, g)
  lines[#lines + 1] = ("%s | peleas: %d | duración media: %s s | por pelea: Sentencias %s, Holy Strike %s, cambios de sello %s"):format(
    title, g.fights, tostring(g.avgDuration), tostring(g.avgJudgements), tostring(g.avgHolyStrikes), tostring(g.avgSealCasts))
  if g.command then
    lines[#lines + 1] = ("   Command: %d activaciones en %s s con el sello puesto = %s por minuto"):format(
      g.command.procs, tostring(g.command.seconds), tostring(g.command.perMinute))
  end
end

local function sortedKeys(t)
  local keys = {}
  for key in pairs(t) do keys[#keys + 1] = key end
  table.sort(keys)
  return keys
end

function Recorder.statsLines(db)
  local fights = db.fights or {}
  local s = FightStats.summarize(fights, FightStyle.classify)
  if s.fights == 0 then return { "Todavía no hay peleas guardadas." } end

  local lines = { ("Peleas guardadas: %d. Por lo que hiciste en cada una:"):format(s.fights) }
  for _, style in ipairs(sortedKeys(s.byStyle)) do
    groupLines(lines, styleName(style), s.byStyle[style])
  end
  for _, test in ipairs(sortedKeys(s.byTest)) do
    groupLines(lines, "Prueba " .. test, s.byTest[test])
  end
  if s.command then
    lines[#lines + 1] = ("Total con %s: %d activaciones en %s s = %s por minuto (estimación)"):format(
      sealName("command"), s.command.procs, tostring(s.command.seconds), tostring(s.command.perMinute))
  end
  return lines
end
