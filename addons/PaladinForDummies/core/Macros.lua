-- Texto de las macros que genera el addon. Las decisiones se toman por spellID;
-- los nombres (en el idioma del cliente) solo se usan para escribir la macro,
-- porque /cast necesita el nombre. Sin rango: /cast usa el rango más alto.
--   PFD Apertura  los pasos antes del pull (core/Plan.lua), una pulsación por paso
--   PFD Unsealed  alterna Righteousness y Command (cambio con Unsealed Wrath)
--   PFD Sello     Command; con Shift, Righteousness
--
-- input = {
--   recommendation, seals, knownSpells, judgementSpellId,
--   nameOf = function(spellId) -> nombre o nil,
-- }
-- Devuelve una lista de { name, body }. Se omite una macro si falta algún
-- hechizo o algún nombre. Lua puro: sin dependencias de WoW.
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

-- Nombres de varios spellIDs, o nil si falta alguno.
local function namesOf(nameOf, ...)
  local names = {}
  for i = 1, select("#", ...) do
    local id = select(i, ...)
    local name = id and nameOf(id)
    if type(name) ~= "string" or name == "" then return nil end
    names[#names + 1] = name
  end
  return names
end

local function opener(input)
  local steps = ns.Core.Plan.prepull(input.recommendation)
  if #steps == 0 then return nil end
  local ids = {}
  for _, step in ipairs(steps) do
    ids[#ids + 1] = (step.action == "judge") and input.judgementSpellId or step.spellId
  end
  local names = namesOf(input.nameOf, unpack(ids))
  if not names then return nil end
  if #names == 1 then return HEADER .. "/cast " .. names[1] end
  return HEADER .. "/castsequence reset=target/combat " .. table.concat(names, ", ")
end

function Macros.build(input)
  local macros = {}
  local function add(name, body)
    if body and #body <= MAX_BODY then macros[#macros + 1] = { name = name, body = body } end
  end

  add("PFD Apertura", opener(input))

  local command = highestKnown(input.seals.command, input.knownSpells)
  local righteousness = highestKnown(input.seals.righteousness, input.knownSpells)
  local names = command and righteousness and namesOf(input.nameOf, righteousness, command)
  if names then
    add("PFD Unsealed", HEADER .. "/castsequence reset=combat " .. names[1] .. ", " .. names[2])
    add("PFD Sello", HEADER .. "/cast [mod:shift] " .. names[1] .. "; " .. names[2])
  end

  return macros
end
