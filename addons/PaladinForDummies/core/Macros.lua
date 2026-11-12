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
-- Y las de utilidad (PACK, más abajo): curas, protección, control, escudo,
-- bendiciones, auras, resurrección y Exorcism. Todas lanzan sin cambiar tu
-- objetivo enemigo: al aliado bajo el ratón, si no a tu objetivo, si no a ti.
-- Una macro de utilidad solo se crea si conoces su hechizo principal; las partes
-- opcionales (p. ej. Holy Light con Shift) solo si conoces ese hechizo.
--
-- input = {
--   seals, macroSpells, knownSpells, judgementSpellId, holyStrikeSpellId,
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
  return HEADER .. "/cast " .. names[1] .. "\n/cast " .. names[2] .. "\n/startattack\n/run UIErrorsFrame:Clear()"
end

local HELP = "[@mouseover,help,nodead][help,nodead][@player]"
local HARM = "[@mouseover,harm,nodead][harm,nodead]"

local function helpful(key)
  return function(n) return HEADER .. "/cast " .. HELP .. " " .. n[key] end
end

local function harmful(key, prefix)
  return function(n) return HEADER .. (prefix or "") .. "/cast " .. HARM .. " " .. n[key] end
end

-- main: el hechizo sin el que la macro no tiene sentido. build recibe los
-- nombres de todos los hechizos conocidos (n[clave], nil si no lo conoces).
local PACK = {
  { name = "PFD Cura", main = "flashOfLight", build = function(n)
    local shift = n.holyLight
      and ("[mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] " .. n.holyLight .. "; ") or ""
    return HEADER .. "/cast " .. shift .. HELP .. " " .. n.flashOfLight
  end },
  { name = "PFD Proteccion", main = "blessingOfProtection", build = function(n)
    local alt = n.divineProtection and ("[mod:alt] " .. n.divineProtection .. "; ") or ""
    return HEADER .. "/cast " .. alt .. "[@mouseover,help,nodead][help,nodead][@targettarget,help,nodead] "
      .. n.blessingOfProtection
  end },
  { name = "PFD Libertad", main = "blessingOfFreedom", build = helpful("blessingOfFreedom") },
  { name = "PFD Manos", main = "layOnHands", build = helpful("layOnHands") },
  { name = "PFD Purificar", main = "purify", build = helpful("purify") },
  { name = "PFD Martillo", main = "hammerOfJustice", build = harmful("hammerOfJustice", "/stopcasting\n") },
  { name = "PFD Arrepentir", main = "repentance", build = harmful("repentance") },
  { name = "PFD Escudo", main = "divineShield", build = function(n)
    -- Pulsar otra vez quita el escudo (y las otras inmunidades) para volver a atacar.
    local lines = { "#showtooltip " .. n.divineShield, "/cancelaura " .. n.divineShield }
    if n.divineProtection then lines[#lines + 1] = "/cancelaura " .. n.divineProtection end
    if n.blessingOfProtection then lines[#lines + 1] = "/cancelaura " .. n.blessingOfProtection end
    lines[#lines + 1] = "/cast " .. n.divineShield
    return table.concat(lines, "\n")
  end },
  { name = "PFD Bendicion", main = "blessingOfMight", build = function(n)
    local ctrl = n.blessingOfKings and ("[mod:ctrl,@mouseover,help,nodead][mod:ctrl] " .. n.blessingOfKings .. "; ") or ""
    return HEADER .. "/cast " .. ctrl .. "[@mouseover,help,nodead][] " .. n.blessingOfMight
  end },
  { name = "PFD Auras", main = "devotionAura", build = function(n)
    if not n.retributionAura then return HEADER .. "/cast " .. n.devotionAura end
    local choice = "[mod:ctrl] " .. n.retributionAura .. "; " .. n.devotionAura
    return "#showtooltip " .. choice .. "\n/cast " .. choice
  end },
  { name = "PFD Resucitar", main = "redemption", build = function(n)
    return HEADER .. "/cast [@mouseover,help,dead][help,dead] " .. n.redemption
  end },
  { name = "PFD Exorcismo", main = "exorcism", build = function(n)
    return HEADER .. "/cast [harm,nodead] " .. n.exorcism .. "\n/startattack"
  end },
}

-- Todas las macros que puede crear el addon, en orden (para el panel de opciones).
Macros.ALL_NAMES = { "PFD Golpe", "PFD Unsealed", "PFD Sello" }
for _, def in ipairs(PACK) do Macros.ALL_NAMES[#Macros.ALL_NAMES + 1] = def.name end

-- Nombres de los hechizos de macroSpells que conoces (rango más alto).
local function knownNames(input)
  local n = {}
  for key, spell in pairs(input.macroSpells or {}) do
    local id = highestKnown(spell, input.knownSpells)
    if id then n[key] = input.nameOf(id) end
  end
  return n
end

local function unknownReason(input, key)
  local spell = input.macroSpells and input.macroSpells[key]
  local name = spell and spell.spellIds[1] and input.nameOf(spell.spellIds[1])
  return "no conoces " .. (name or key)
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
  add("PFD Unsealed", names and (HEADER .. "/castsequence reset=combat " .. names[2] .. ", " .. names[1]), reason)
  add("PFD Sello", names and (HEADER .. "/cast [mod:shift] " .. names[1] .. "; " .. names[2]), reason)

  if input.macroSpells then
    local n = knownNames(input)
    for _, def in ipairs(PACK) do
      if n[def.main] then
        add(def.name, def.build(n))
      else
        add(def.name, nil, unknownReason(input, def.main))
      end
    end
  end

  return macros, skipped
end
