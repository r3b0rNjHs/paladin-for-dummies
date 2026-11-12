-- Wisdom y Light según cómo descansas (Lua puro, sin WoW). El juego no deja leer
-- tu maná ni tu vida (sondeo 1), pero sí ver si bebes o comes fuera de combate:
-- si lo haces después de casi todas las peleas, el maná o la vida te frenan.
-- Es una pista, no una medida (así lo dicen los textos).
local _, ns = ...
ns.Core = ns.Core or {}

local Sustain = {}
ns.Core.Sustain = Sustain

local WINDOW = 10   -- últimas peleas que se miran
local MIN_FIGHTS = 6
local OFTEN = 5     -- de cada 10

-- fights: con drankAfter / ateAfter (Main.lua los marca al verte beber o comer).
-- Devuelve { fights, drank, ate, key = WISDOM | LIGHT | BOTH | nil }.
function Sustain.advice(fights)
  local list = fights or {}
  local result = { fights = 0, drank = 0, ate = 0 }
  for i = #list, 1, -1 do
    local fight = list[i]
    if type(fight.duration) == "number" and fight.duration >= 5 then
      result.fights = result.fights + 1
      if fight.drankAfter then result.drank = result.drank + 1 end
      if fight.ateAfter then result.ate = result.ate + 1 end
      if result.fights >= WINDOW then break end
    end
  end
  if result.fights < MIN_FIGHTS then return result end
  local limit = OFTEN * result.fights / WINDOW
  local drinks, eats = result.drank >= limit, result.ate >= limit
  if drinks and eats then result.key = "BOTH"
  elseif drinks then result.key = "WISDOM"
  elseif eats then result.key = "LIGHT" end
  return result
end
