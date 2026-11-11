-- Registro de una pelea, a partir de lo que sí se puede leer en combate.
-- En combate las auras son ilegibles, pero tus lanzamientos no: con el sello que
-- llevabas al empezar y los sellos que lanzas después, se reconstruye cuánto
-- tiempo llevaste cada uno. Cada sello dura 30 s.
--
--   local f = Fight.start(catalog, opening, context)
--   Fight.cast(f, t, spellId)         -- por cada UNIT_SPELLCAST_SUCCEEDED propio
--   local record = Fight.finish(f, { t = ..., time = ... })
--
-- catalog: qué es cada spellID (ver data/Seals.lua: ns.Data.Catalog).
-- opening: { t, seal, sealExpires, echoes } leído justo al empezar.
-- Lua puro: sin dependencias de WoW. Los tiempos son los de GetTime().
local _, ns = ...
ns.Core = ns.Core or {}

local Fight = {}
ns.Core.Fight = Fight

local SEAL_DURATION = 30
local COUNTERS = { "judgement", "holyStrike", "commandProc" }

local function round1(x)
  return math.floor(x * 10 + 0.5) / 10
end

local function closeSegment(f, t)
  local seg = f.segment
  if not seg then return end
  local finish = math.min(t, seg.expires)
  if finish > seg.from then
    f.sealSeconds[seg.seal] = (f.sealSeconds[seg.seal] or 0) + (finish - seg.from)
  end
  f.segment = nil
end

function Fight.start(catalog, opening, context)
  local f = {
    catalog = catalog,
    startedAt = opening.t,
    openingSeal = opening.seal,
    openingEchoes = opening.echoes,
    context = context or {},
    sealSeconds = {},
    counts = { judgement = 0, holyStrike = 0, commandProc = 0, sealCast = 0 },
  }
  if opening.seal then
    f.segment = {
      seal = opening.seal,
      from = opening.t,
      expires = opening.sealExpires or (opening.t + SEAL_DURATION),
    }
  end
  return f
end

function Fight.cast(f, t, spellId)
  if type(spellId) ~= "number" or type(t) ~= "number" then return end
  local catalog = f.catalog

  local seal = catalog.sealBySpellId[spellId]
  if seal then
    closeSegment(f, t)
    f.segment = { seal = seal, from = t, expires = t + SEAL_DURATION }
    f.counts.sealCast = f.counts.sealCast + 1
    return
  end

  for _, counter in ipairs(COUNTERS) do
    if catalog[counter][spellId] then
      f.counts[counter] = f.counts[counter] + 1
      return
    end
  end
end

function Fight.finish(f, ending)
  closeSegment(f, ending.t)
  local sealSeconds = {}
  for seal, seconds in pairs(f.sealSeconds) do sealSeconds[seal] = round1(seconds) end
  return {
    time = ending.time,
    duration = round1(ending.t - f.startedAt),
    openingSeal = f.openingSeal,
    openingEchoes = f.openingEchoes,
    context = f.context,
    sealSeconds = sealSeconds,
    counts = f.counts,
  }
end
