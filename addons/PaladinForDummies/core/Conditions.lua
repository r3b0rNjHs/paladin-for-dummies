-- Condiciones declarativas de las reglas.
-- Una condición es { nombre = valor } o { nombre = { valor1, valor2 } } (vale cualquiera).
-- Son datos y no funciones para poder exportar e importar paquetes de reglas (fase 2).
-- Lua puro: sin dependencias de WoW.
local _, ns = ...
ns.Core = ns.Core or {}

local Conditions = {}
ns.Core.Conditions = Conditions

local function targetField(field)
  return function(situation)
    local target = situation.target
    if not (target and target.exists) then return nil end
    return target[field]
  end
end

-- Cada condición sabe leer su valor de la Situation.
local READERS = {
  spec = function(situation) return situation.player.spec end,
  role = function(situation) return situation.player.role end,
  content = function(situation) return situation.content end,
  targetCreatureType = targetField("creatureType"),
  targetClassification = targetField("classification"),
}

local function accepts(expected, actual)
  if actual == nil then return false end
  if type(expected) ~= "table" then return expected == actual end
  for _, candidate in ipairs(expected) do
    if candidate == actual then return true end
  end
  return false
end

function Conditions.matches(when, situation)
  for name, expected in pairs(when) do
    local read = READERS[name]
    if not read then error("Unknown condition: " .. tostring(name), 0) end
    if not accepts(expected, read(situation)) then return false end
  end
  return true
end
