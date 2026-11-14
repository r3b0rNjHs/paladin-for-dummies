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

-- Qué huecos mostrar: Light (tu vida), Wisdom (tu maná) y Hammer of Wrath (la
-- vida del enemigo, al 20 % o menos), solo lo que conoces.
function Sustain.slots(known)
  local slots = {}
  if known.light then slots[#slots + 1] = "light" end
  if known.wisdom then slots[#slots + 1] = "wisdom" end
  if known.hammer then slots[#slots + 1] = "hammer" end
  return slots
end

-- Hammer of Wrath solo se puede lanzar contra enemigos al 20 % o menos.
Sustain.HAMMER_THRESHOLD = 0.2
