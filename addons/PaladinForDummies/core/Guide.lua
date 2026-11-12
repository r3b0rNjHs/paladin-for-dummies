-- La lógica de la guía (Lua puro, sin WoW):
--   fill:  pone los nombres de hechizo del cliente (en el idioma del jugador) en
--          lugar de las marcas {COMMAND}, {JUDGEMENT}...
--   plan:  "Tu plan": qué hacer con los hechizos que conoces ahora.
--   usage: cuántas de las Sentencias y Holy Strike posibles usaste.
local _, ns = ...
ns.Core = ns.Core or {}

local Guide = {}
ns.Core.Guide = Guide

local GOLD = "|cfff2c14e"

-- nameOf(token) devuelve el nombre del hechizo o nil.
function Guide.fill(text, nameOf)
  return (text:gsub("{(%u[%u_]*)}", function(token)
    local name = nameOf(token)
    if name then return GOLD .. name .. "|r" end
    return token
  end))
end

local function step(key, icon) return { key = key, icon = icon } end

-- info = { level, known = { righteousness, crusader, command, holyStrike } }.
-- Devuelve { damageSeal = "COMMAND"|"RIGHTEOUSNESS", steps = { { key, icon } } }.
-- Las claves H_* son encabezados.
function Guide.plan(info)
  local known = info.known or {}
  local damageSeal = known.command and "COMMAND" or "RIGHTEOUSNESS"
  local steps = { step("H_BEFORE") }

  if known.crusader then
    steps[#steps + 1] = step("PREPULL_1", "CRUSADER")
    steps[#steps + 1] = step("PREPULL_2", "JUDGEMENT")
    steps[#steps + 1] = step("PREPULL_3", damageSeal)
  else
    steps[#steps + 1] = step("SEAL_ONLY", damageSeal)
  end

  steps[#steps + 1] = step("H_DURING")
  steps[#steps + 1] = step("JUDGE", "JUDGEMENT")
  if known.holyStrike then steps[#steps + 1] = step("STRIKE", "HOLY_STRIKE") end
  if known.command then steps[#steps + 1] = step("UNSEALED", "ECHO") end
  steps[#steps + 1] = step("REFRESH", damageSeal)

  local next = {}
  if not known.crusader then next[#next + 1] = step("NEXT_CRUSADER", "CRUSADER") end
  if not known.holyStrike then next[#next + 1] = step("NEXT_STRIKE", "HOLY_STRIKE") end
  if known.crusader and not known.command then next[#next + 1] = step("NEXT_COMMAND", "COMMAND") end
  if #next > 0 then
    steps[#steps + 1] = step("H_NEXT")
    for _, s in ipairs(next) do steps[#steps + 1] = s end
  end

  return { damageSeal = damageSeal, steps = steps }
end

-- Enfriamientos medidos en Forever (docs/probe-results/2026-11-12-peleas-1.md).
local COOLDOWN = { judgement = 8, holyStrike = 10 }
local MIN_DURATION = 5 -- peleas más cortas no dicen nada

-- Sentencias y Holy Strike que usaste frente a las que podías usar: una al
-- empezar y otra cada enfriamiento.
function Guide.usage(fights)
  local result = { fights = 0, judgement = { used = 0, possible = 0 }, holyStrike = { used = 0, possible = 0 } }
  for _, fight in ipairs(fights or {}) do
    local duration = type(fight.duration) == "number" and fight.duration or 0
    if duration >= MIN_DURATION then
      result.fights = result.fights + 1
      for spell, cooldown in pairs(COOLDOWN) do
        local possible = math.floor(duration / cooldown) + 1
        local used = (fight.counts and fight.counts[spell]) or 0
        result[spell].possible = result[spell].possible + possible
        result[spell].used = result[spell].used + math.min(used, possible)
      end
    end
  end
  return result
end
