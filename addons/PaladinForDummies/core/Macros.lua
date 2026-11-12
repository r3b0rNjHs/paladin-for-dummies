-- Texto de las macros que genera el addon. Las decisiones se toman por spellID;
-- los nombres (en el idioma del cliente) solo se usan para escribir la macro,
-- porque /cast necesita el nombre. Sin rango: /cast usa el rango más alto.
--   PFD Apertura  fuera de combate, el sello de la Sentencia (Crusader); en combate,
--                 el sello de la pelea (Command). Sin secuencia: no guarda en qué paso
--                 va, así que nunca se queda a medias. Uso: Apertura → Golpe → Apertura.
--   PFD Golpe     Judgement y Holy Strike: lanza lo que esté disponible. Judgement no
--                 ocupa el tiempo global, así que no bloquea a Holy Strike.
--   PFD Unsealed  alterna Righteousness y Command (cambio con Unsealed Wrath)
--   PFD Sello     Command; con Shift, Righteousness
--
-- input = {
--   recommendation, seals, knownSpells, judgementSpellId, holyStrikeSpellId,
--   nameOf = function(spellId) -> nombre o nil,
-- }
-- Devuelve la lista de { name, body } y la de las omitidas, { name, reason },
-- para poder explicar por qué falta alguna. Lua puro: sin dependencias de WoW.
local _, ns = ...
ns.Core = ns.Core or {}

local Macros = {}
ns.Core.Macros = Macros

local MAX_BODY = 255
local HEADER = "#showtooltip\n"

local function highestKnown(seal, knownSpells)
  if not seal then return nil end
  for i = #seal.spellIds, 1, -1 do
    if knownSpells[seal.spellIds[i]] then return seal.spellIds[i] end
  end
  return nil
end

-- Nombres de varios spellIDs, o nil y el primer ID sin nombre.
local function namesOf(nameOf, ids)
  local names = {}
  for _, id in ipairs(ids) do
    local name = nameOf(id)
    if type(name) ~= "string" or name == "" then return nil, id end
    names[#names + 1] = name
  end
  return names
end

local function missingName(id)
  return ("falta el nombre de algún hechizo (spellID %s)"):format(tostring(id))
end

-- Devuelve el cuerpo, o nil y el motivo.
local function opener(input)
  local rec = input.recommendation or {}
  local fightId = rec.seal and rec.seal.spellId
  local judgeId = rec.judgement and rec.judgement.spellId
  if not (fightId or judgeId) then return nil, "no hay recomendación todavía" end

  if fightId and judgeId and fightId ~= judgeId then
    local names, missing = namesOf(input.nameOf, { judgeId, fightId })
    if not names then return nil, missingName(missing) end
    return HEADER .. "/cast [nocombat] " .. names[1] .. "; " .. names[2]
  end

  local names, missing = namesOf(input.nameOf, { fightId or judgeId })
  if not names then return nil, missingName(missing) end
  return HEADER .. "/cast " .. names[1]
end

-- Judgement y Holy Strike en un botón. La última línea borra el aviso rojo de
-- "aún no está listo" cuando uno de los dos está en enfriamiento.
local function strike(input)
  local names, missing = namesOf(input.nameOf, { input.judgementSpellId, input.holyStrikeSpellId })
  if not names then return nil, missingName(missing) end
  return HEADER .. "/cast " .. names[1] .. "\n/cast " .. names[2] .. "\n/run UIErrorsFrame:Clear()"
end

function Macros.build(input)
  local macros, skipped = {}, {}
  local function add(name, body, reason)
    if body and #body > MAX_BODY then body, reason = nil, "el texto pasa de 255 caracteres" end
    if body then
      macros[#macros + 1] = { name = name, body = body }
    else
      skipped[#skipped + 1] = { name = name, reason = reason }
    end
  end

  add("PFD Apertura", opener(input))
  add("PFD Golpe", strike(input))

  local command = highestKnown(input.seals.command, input.knownSpells)
  local righteousness = highestKnown(input.seals.righteousness, input.knownSpells)
  local names, reason
  if not righteousness then
    reason = "no conoces Seal of Righteousness"
  elseif not command then
    reason = "no conoces Seal of Command"
  else
    local missing
    names, missing = namesOf(input.nameOf, { righteousness, command })
    if not names then reason = missingName(missing) end
  end
  add("PFD Unsealed", names and (HEADER .. "/castsequence reset=combat " .. names[1] .. ", " .. names[2]), reason)
  add("PFD Sello", names and (HEADER .. "/cast [mod:shift] " .. names[1] .. "; " .. names[2]), reason)

  return macros, skipped
end
