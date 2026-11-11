-- Estadísticas sobre las peleas guardadas (core/Fight.lua).
--   byOpeningSeal: por sello inicial, número de peleas, duración media y Sentencias medias.
--   command: activaciones de Seal of Command por minuto con Command puesto.
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

function FightStats.summarize(fights)
  local groups = {}
  local procs, commandSeconds = 0, 0

  for _, fight in ipairs(fights) do
    local key = fight.openingSeal or "none"
    local g = groups[key] or { fights = 0, duration = 0, judgements = 0 }
    g.fights = g.fights + 1
    g.duration = g.duration + fight.duration
    g.judgements = g.judgements + fight.counts.judgement
    groups[key] = g

    procs = procs + fight.counts.commandProc
    commandSeconds = commandSeconds + (fight.sealSeconds.command or 0)
  end

  local byOpeningSeal = {}
  for key, g in pairs(groups) do
    byOpeningSeal[key] = {
      fights = g.fights,
      avgDuration = round1(g.duration / g.fights),
      avgJudgements = round1(g.judgements / g.fights),
    }
  end

  local command = nil
  if commandSeconds > 0 then
    command = { procs = procs, seconds = round1(commandSeconds), perMinute = round1(procs / (commandSeconds / 60)) }
  end

  return { fights = #fights, byOpeningSeal = byOpeningSeal, command = command }
end
