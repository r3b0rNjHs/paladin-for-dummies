-- Repaso tras el combate: graba cada pelea y resume las estadísticas.
-- Graba, no decide: en combate solo se anotan tus lanzamientos (que no son secret)
-- y la recomendación sigue congelada (regla 1). Nada secret llega a SavedVariables
-- (regla 4): el adaptador y Fight.cast descartan lo que no es un número legible.
local _, ns = ...

local Fight, FightStats = ns.Core.Fight, ns.Core.FightStats
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

function Recorder.describe(record)
  local c = record.counts
  local test = record.context and record.context.test
  return ("%sPelea de %s s con %s | Sentencias: %d | Holy Strike: %d | activaciones de Command: %d"):format(
    test and ("[prueba " .. test .. "] ") or "",
    tostring(record.duration), sealName(record.openingSeal), c.judgement, c.holyStrike, c.commandProc)
end

function Recorder.statsLines(db)
  local fights = db.fights or {}
  local s = FightStats.summarize(fights)
  if s.fights == 0 then return { "Todavía no hay peleas guardadas." } end

  local lines = { ("Peleas guardadas: %d"):format(s.fights) }

  local tests = {}
  for key in pairs(s.byTest) do tests[#tests + 1] = key end
  table.sort(tests)
  for _, key in ipairs(tests) do
    local t = s.byTest[key]
    lines[#lines + 1] = ("Prueba %s | peleas: %d | duración media: %s s | por pelea: Sentencias %s, Holy Strike %s, cambios de sello %s"):format(
      key, t.fights, tostring(t.avgDuration), tostring(t.avgJudgements), tostring(t.avgHolyStrikes), tostring(t.avgSealCasts))
    if t.command then
      lines[#lines + 1] = ("   Command: %d activaciones en %s s con el sello puesto = %s por minuto"):format(
        t.command.procs, tostring(t.command.seconds), tostring(t.command.perMinute))
    end
  end
  if #tests > 0 then lines[#lines + 1] = "Todas las peleas:" end
  local keys = {}
  for key in pairs(s.byOpeningSeal) do keys[#keys + 1] = key end
  table.sort(keys)
  for _, key in ipairs(keys) do
    local g = s.byOpeningSeal[key]
    lines[#lines + 1] = ("Empezando con %s | peleas: %d | duración media: %s s | Sentencias por pelea: %s"):format(
      sealName(key), g.fights, tostring(g.avgDuration), tostring(g.avgJudgements))
  end
  if s.command then
    lines[#lines + 1] = ("%s | activaciones: %d en %s s con el sello puesto = %s por minuto (estimación)"):format(
      sealName("command"), s.command.procs, tostring(s.command.seconds), tostring(s.command.perMinute))
  end
  return lines
end
