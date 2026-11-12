-- Poca vida o poco maná: cambia a Light o a Wisdom (Lua puro, sin WoW).
-- El juego no deja leer la vida ni el maná (sondeo 1), pero sí mostrarlos: se le
-- da una curva y él la evalúa con el porcentaje (UnitHealthPercent,
-- UnitPowerPercent) y el resultado va a la transparencia del icono (SetAlpha
-- admite valores secret). Este módulo construye los puntos de esa curva.
local _, ns = ...
ns.Core = ns.Core or {}

local Sustain = {}
ns.Core.Sustain = Sustain

local MIN, MAX, STEP = 0.05, 0.9, 0.01

-- Puntos { x = porcentaje (0 a 1), y = transparencia }: visible hasta el umbral.
function Sustain.points(threshold)
  local t = math.max(MIN, math.min(MAX, threshold or 0.3))
  return { { 0, 1 }, { t, 1 }, { t + STEP, 0 }, { 1, 0 } }
end

-- Qué huecos mostrar: Light (vida) y Wisdom (maná), solo los sellos que conoces.
function Sustain.slots(known)
  local slots = {}
  if known.light then slots[#slots + 1] = "light" end
  if known.wisdom then slots[#slots + 1] = "wisdom" end
  return slots
end
