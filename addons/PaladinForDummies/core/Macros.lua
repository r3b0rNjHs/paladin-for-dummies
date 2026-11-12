-- Texto de las macros que genera el addon. Las decisiones se toman por spellID;
-- los nombres (en el idioma del cliente) solo se usan para escribir la macro,
-- porque /cast necesita el nombre. Sin rango: /cast usa el rango más alto.
--   PFD Golpe     Judgement y Holy Strike: lanza lo que esté disponible. Judgement no
--                 ocupa el tiempo global, así que no bloquea a Holy Strike.
--   PFD Unsealed  Command y Righteousness alternados (cambio con Unsealed Wrath).
--                 Empieza por Command y vuelve a empezar al cambiar de objetivo o
--                 salir de combate: tras juzgar Crusader en un enemigo nuevo, la
--                 primera pulsación pone Command. (Ya no hay macro de apertura:
--                 Crusader se lanza desde su propio botón.)
--   PFD Sello     Command; con Shift, Righteousness
--
-- input = {
--   seals, knownSpells, judgementSpellId, holyStrikeSpellId,
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
  add("PFD Unsealed", names and (HEADER .. "/castsequence reset=target/combat " .. names[2] .. ", " .. names[1]), reason)
  add("PFD Sello", names and (HEADER .. "/cast [mod:shift] " .. names[1] .. "; " .. names[2]), reason)

  return macros, skipped
end
