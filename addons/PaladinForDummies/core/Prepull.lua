-- El aviso antes del pull (Lua puro, sin WoW): qué te falta antes de pelear.
-- Sustituye al asesor fijo (decisión de Jorge, 12 nov): solo hay algo que
-- mostrar cuando tienes que actuar. Con un enemigo seleccionado y fuera de
-- combate (en combate las auras son secret y buffs llega vacío):
--   seal      no llevas sello (missing) o llevas otro que no toca (recommended)
--   aura      no llevas ninguna aura
--   blessing  no llevas ninguna bendición (vale la de otro paladín)
--   fury      eres tanque y no llevas Righteous Fury
--   tip       no-muerto o demonio en mundo abierto: Exorcism
--   food      no estás bien alimentado (si el jugador lo pidió; desde nivel 10)
local _, ns = ...
ns.Core = ns.Core or {}

local Prepull = {}
ns.Core.Prepull = Prepull

local CREATURE_DEMON, CREATURE_UNDEAD = 3, 6 -- 2.º retorno de UnitCreatureType

local function hasAny(set, groups)
  for _, ids in pairs(groups) do
    for _, id in ipairs(ids) do if set[id] then return true end end
  end
  return false
end

-- El rango más alto que conoces de una lista ordenada de menor a mayor.
local function highestKnown(ids, known)
  for i = #(ids or {}), 1, -1 do
    if known[ids[i]] then return ids[i] end
  end
  return nil
end

local function currentSeal(buffs, sealBySpellId)
  for spellId in pairs(buffs) do
    if sealBySpellId[spellId] then return sealBySpellId[spellId] end
  end
  return nil
end

-- spells = { sealBySpellId, auras = { devotion, retribution, ... }, blessings =
-- { might, kings, ... }, righteousFury, exorcism } (listas de spellIDs).
-- options = { food = true } para el aviso de comida.
local FOOD_LEVEL = 10

function Prepull.alerts(situation, recommendation, spells, options)
  local alerts = {}
  local player, target = situation.player or {}, situation.target or {}
  local buffs, known = player.buffs, player.knownSpells or {}
  if not (target.exists and buffs) then return alerts end

  local wanted = recommendation and recommendation.seal
  if wanted then
    local current = currentSeal(buffs, spells.sealBySpellId)
    if current ~= wanted.seal then
      alerts[#alerts + 1] = { kind = "seal", spellId = wanted.spellId, entry = wanted,
        state = current and "recommended" or "missing", current = current }
    end
  end

  if not hasAny(buffs, spells.auras) then
    local aura = (player.spec == "retribution" and highestKnown(spells.auras.retribution, known))
      or highestKnown(spells.auras.devotion, known) or highestKnown(spells.auras.retribution, known)
    if aura then alerts[#alerts + 1] = { kind = "aura", spellId = aura, state = "missing" } end
  end

  if not hasAny(buffs, spells.blessings) then
    local blessing = highestKnown(spells.blessings.might, known) or highestKnown(spells.blessings.kings, known)
    if blessing then alerts[#alerts + 1] = { kind = "blessing", spellId = blessing, state = "missing" } end
  end

  if player.role == "TANK" and not hasAny(buffs, { spells.righteousFury }) then
    local fury = highestKnown(spells.righteousFury, known)
    if fury then alerts[#alerts + 1] = { kind = "fury", spellId = fury, state = "missing" } end
  end

  local openWorld = situation.content ~= "dungeon" and situation.content ~= "raid"
  if openWorld and (target.creatureType == CREATURE_UNDEAD or target.creatureType == CREATURE_DEMON) then
    local exorcism = highestKnown(spells.exorcism, known)
    if exorcism then alerts[#alerts + 1] = { kind = "tip", spellId = exorcism, state = "recommended" } end
  end

  if options and options.food and player.wellFed == false and (player.level or 0) >= FOOD_LEVEL then
    alerts[#alerts + 1] = { kind = "food", spellId = spells.foodBuff, state = "expiring" }
  end

  return alerts
end
