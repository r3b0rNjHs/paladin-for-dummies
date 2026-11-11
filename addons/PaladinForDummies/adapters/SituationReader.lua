-- Adaptador: la única capa que toca la API de WoW.
-- Lee el estado del juego y lo convierte en una Situation plana para el core:
--   player  = { level, spec, knownSpells = { [spellID] = true } }
--   content = "solo" | "group" | "dungeon" | "raid" | "pvp"
--   target  = { exists = false } o { exists = true, creatureType, classification, level }
--             (solo objetivos atacables: las reglas de enemigo nunca se aplican a aliados)
--
-- Recibe la API como parámetro (en el juego, _G) para poder probarlo fuera de WoW.
-- Reglas: todo pasa por pcall y ningún valor secret llega a la Situation.
local _, ns = ...
ns.Adapters = ns.Adapters or {}

local SituationReader = {}
ns.Adapters.SituationReader = SituationReader

-- IDs de especialización del paladín en Mainline. Sin confirmar en Forever:
-- si sale otro, diagnostics.unknownSpecId lo dice.
local SPEC_BY_ID = { [65] = "holy", [66] = "protection", [70] = "retribution" }
-- Orden de los árboles de talentos clásicos del paladín.
local SPEC_BY_TAB = { "holy", "protection", "retribution" }

local function reader(api)
  local isSecret = function(v)
    if type(api.issecretvalue) ~= "function" then return false end
    local ok, res = pcall(api.issecretvalue, v)
    return ok and res == true
  end

  local function clean(v)
    if isSecret(v) then return nil end
    return v
  end

  -- Llama a fn con pcall y devuelve hasta 5 valores, sustituyendo los secret por nil.
  return function(fn, ...)
    if type(fn) ~= "function" then return nil end
    local ok, a, b, c, d, e = pcall(fn, ...)
    if not ok then return nil end
    return clean(a), clean(b), clean(c), clean(d), clean(e)
  end
end

local function field(tbl, key)
  if type(tbl) ~= "table" then return nil end
  return tbl[key]
end

local function readKnownSeals(api, call, seals)
  local wanted = {}
  for _, seal in pairs(seals) do
    for _, id in ipairs(seal.spellIds) do wanted[id] = true end
  end

  local known = {}
  local book = api.C_SpellBook
  local bank = field(field(api.Enum, "SpellBookSpellBank"), "Player") or 0
  local lines = call(field(book, "GetNumSpellBookSkillLines")) or 0
  for line = 1, lines do
    local info = call(field(book, "GetSpellBookSkillLineInfo"), line)
    local offset, count = field(info, "itemIndexOffset"), field(info, "numSpellBookItems")
    if type(offset) == "number" and type(count) == "number" then
      for i = offset + 1, offset + count do
        local item = call(field(book, "GetSpellBookItemInfo"), i, bank)
        local id = field(item, "spellID")
        if type(id) == "number" and wanted[id] then known[id] = true end
      end
    end
  end
  return known
end

local function readSpecFromSpecialization(api, call, diagnostics)
  local lib = api.C_SpecializationInfo
  local getIndex = field(lib, "GetSpecialization") or api.GetSpecialization
  local getInfo = field(lib, "GetSpecializationInfo") or api.GetSpecializationInfo
  local index = call(getIndex)
  if type(index) ~= "number" then return nil end
  local id = call(getInfo, index)
  if type(id) ~= "number" then return nil end
  if not SPEC_BY_ID[id] then diagnostics.unknownSpecId = id end
  return SPEC_BY_ID[id]
end

local function readSpecFromTalents(api, call)
  local tabs = call(api.GetNumTalentTabs)
  if type(tabs) ~= "number" then return nil end
  local best, bestPoints = nil, 0
  for i = 1, math.min(tabs, #SPEC_BY_TAB) do
    local a, _, c, _, e = call(api.GetTalentTabInfo, i)
    -- Firma clásica: name, icon, pointsSpent. Firma moderna: id, name, desc, icon, pointsSpent.
    local points = (type(a) == "string") and c or e
    if type(points) == "number" and points > bestPoints then
      best, bestPoints = SPEC_BY_TAB[i], points
    end
  end
  return best
end

local function readSpec(api, call, options, diagnostics)
  if options.specOverride then
    diagnostics.specSource = "override"
    return options.specOverride
  end
  local spec = readSpecFromSpecialization(api, call, diagnostics)
  if spec then
    diagnostics.specSource = "specialization"
    return spec
  end
  spec = readSpecFromTalents(api, call)
  if spec then
    diagnostics.specSource = "talents"
    return spec
  end
  diagnostics.specSource = "none"
  return nil
end

local function readContent(call, api)
  local inInstance, instanceType = call(api.IsInInstance)
  if inInstance then
    if instanceType == "party" then return "dungeon" end
    if instanceType == "raid" then return "raid" end
    if instanceType == "pvp" or instanceType == "arena" then return "pvp" end
  end
  if call(api.IsInGroup) then return "group" end
  return "solo"
end

local function readTarget(call, api)
  if not (call(api.UnitExists, "target") and call(api.UnitCanAttack, "player", "target")) then
    return { exists = false }
  end
  local _, creatureType = call(api.UnitCreatureType, "target")
  return {
    exists = true,
    creatureType = creatureType,
    classification = call(api.UnitClassification, "target"),
    level = call(api.UnitLevel, "target"),
  }
end

-- Devuelve la Situation y unos diagnósticos (de dónde salió la spec, IDs desconocidos).
function SituationReader.read(api, seals, options)
  options = options or {}
  local call = reader(api)
  local diagnostics = {}

  local situation = {
    player = {
      level = call(api.UnitLevel, "player"),
      spec = readSpec(api, call, options, diagnostics),
      knownSpells = readKnownSeals(api, call, seals),
    },
    content = readContent(call, api),
    target = readTarget(call, api),
  }
  return situation, diagnostics
end
