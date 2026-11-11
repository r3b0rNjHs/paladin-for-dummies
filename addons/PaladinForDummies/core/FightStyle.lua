-- Deduce qué hiciste en una pelea a partir de sus sellos, sin que tengas que
-- etiquetarla (core/Fight.lua guarda el sello inicial y cada sello lanzado).
--   solo:<sello>          un solo sello toda la pelea
--   crusader-then:<sello> Crusader (para juzgarlo) y luego un solo sello de daño
--   twist                 cambios entre Command y Righteousness (Unsealed Wrath),
--                         al menos dos cambios, con o sin Crusader al principio
--   mixed                 cualquier otra combinación
--   none                  ningún sello
-- Lua puro: sin dependencias de WoW.
local _, ns = ...
ns.Core = ns.Core or {}

local FightStyle = {}
ns.Core.FightStyle = FightStyle

-- Secuencia de sellos sin repeticiones seguidas: el inicial y los lanzados.
local function sealSequence(record)
  local seq = {}
  local function push(seal)
    if seal and seq[#seq] ~= seal then seq[#seq + 1] = seal end
  end
  push(record.openingSeal)
  for _, entry in ipairs(record.timeline or {}) do
    if entry.kind == "seal" then push(entry.seal) end
  end
  return seq
end

local function distinct(seq, from)
  local set, n = {}, 0
  for i = from or 1, #seq do
    if not set[seq[i]] then set[seq[i]] = true; n = n + 1 end
  end
  return set, n
end

function FightStyle.classify(record)
  local seq = sealSequence(record)
  if #seq == 0 then return "none" end
  if #seq == 1 then return "solo:" .. seq[1] end

  local from = (seq[1] == "crusader") and 2 or 1
  local rest, n = distinct(seq, from)
  if from == 2 and n == 1 then return "crusader-then:" .. seq[2] end

  local switches = #seq - from -- cambios después del primer sello de daño
  if n == 2 and rest.command and rest.righteousness and switches >= 2 then return "twist" end

  return "mixed"
end
