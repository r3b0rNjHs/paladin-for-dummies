-- Estadísticas sobre las peleas guardadas (core/Fight.lua).
--   byOpeningSeal: por sello inicial, número de peleas, duración media y Sentencias medias.
--   byTest: por prueba (/pfd test A, B, C...), lo mismo más Holy Strike, cambios de
--           sello y la tasa de Command de esa prueba. Las peleas sin prueba no entran.
--   byStyle: lo mismo que byTest, agrupando por el estilo que devuelva classify(fight)
--            (en el juego, core/FightStyle.lua). Sin classify, vacío.
--   command: activaciones de Seal of Command por minuto con Command puesto (todas las peleas).
--
-- La tasa de Command es una estimación: el tiempo con Command puesto incluye ratos
-- sin golpear (moverse, objetivo muerto), lo que la rebaja; y con Unsealed Wrath
-- algunas activaciones llegan con otro sello puesto, lo que la sube.
-- Lua puro: sin dependencias de WoW.
local _, ns = ...
ns.Core = ns.Core or {}

local FightStats = {}
ns.Core.FightStats = FightStats

local function round1(x)
  return math.floor(x * 10 + 0.5) / 10
end

local function newGroup()
  return { fights = 0, duration = 0, judgement = 0, holyStrike = 0, sealCast = 0, procs = 0, commandSeconds = 0 }
end

local function add(group, fight)
  local c = fight.counts
  group.fights = group.fights + 1
  group.duration = group.duration + fight.duration
  group.judgement = group.judgement + c.judgement
  group.holyStrike = group.holyStrike + c.holyStrike
  group.sealCast = group.sealCast + c.sealCast
  group.procs = group.procs + c.commandProc
  group.commandSeconds = group.commandSeconds + (fight.sealSeconds.command or 0)
end

local function commandRate(group)
  if group.commandSeconds <= 0 then return nil end
  return {
    procs = group.procs,
    seconds = round1(group.commandSeconds),
    perMinute = round1(group.procs / (group.commandSeconds / 60)),
  }
end

local function average(group, field)
  return round1(group[field] / group.fights)
end

local function detailed(groups)
  local out = {}
  for key, g in pairs(groups) do
    out[key] = {
      fights = g.fights,
      avgDuration = average(g, "duration"),
      avgJudgements = average(g, "judgement"),
      avgHolyStrikes = average(g, "holyStrike"),
      avgSealCasts = average(g, "sealCast"),
      command = commandRate(g),
    }
  end
  return out
end

function FightStats.summarize(fights, classify)
  local seals, tests, styles, all = {}, {}, {}, newGroup()

  for _, fight in ipairs(fights) do
    local sealKey = fight.openingSeal or "none"
    seals[sealKey] = seals[sealKey] or newGroup()
    add(seals[sealKey], fight)

    local test = fight.context and fight.context.test
    if test then
      tests[test] = tests[test] or newGroup()
      add(tests[test], fight)
    end

    if classify then
      local style = classify(fight)
      styles[style] = styles[style] or newGroup()
      add(styles[style], fight)
    end

    add(all, fight)
  end

  local byOpeningSeal = {}
  for key, g in pairs(seals) do
    byOpeningSeal[key] = {
      fights = g.fights,
      avgDuration = average(g, "duration"),
      avgJudgements = average(g, "judgement"),
    }
  end

  return {
    fights = #fights,
    byOpeningSeal = byOpeningSeal,
    byTest = detailed(tests),
    byStyle = detailed(styles),
    command = commandRate(all),
  }
end
