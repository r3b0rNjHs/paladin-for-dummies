-- Motor de reglas: Situation -> Recommendation.
-- Decide por separado dos huecos:
--   seal      = el sello que llevar puesto durante la pelea
--   judgement = el sello con el que lanzar la Sentencia antes del pull
-- Para cada hueco gana la regla de mayor prioridad que cumpla sus condiciones
-- y cuyo sello conozca el jugador. Los empates los decide el orden de las reglas.
-- Lua puro: sin dependencias de WoW.
local _, ns = ...
ns.Core = ns.Core or {}

local Conditions = ns.Core.Conditions

local RuleEngine = {}
ns.Core.RuleEngine = RuleEngine

local SLOTS = { "seal", "judgement" }

-- Devuelve el spellID del rango más alto que conoce el jugador, o nil.
-- spellIds va ordenado de menor a mayor rango.
local function highestKnownRank(seal, knownSpells)
  local ids = seal.spellIds
  for i = #ids, 1, -1 do
    if knownSpells[ids[i]] then return ids[i] end
  end
  return nil
end

local function byPriority(rules)
  local ordered = {}
  for index, rule in ipairs(rules) do
    ordered[#ordered + 1] = { rule = rule, index = index }
  end
  table.sort(ordered, function(a, b)
    if a.rule.priority ~= b.rule.priority then return a.rule.priority > b.rule.priority end
    return a.index < b.index
  end)
  return ordered
end

function RuleEngine.recommend(situation, rules, seals)
  local knownSpells = situation.player.knownSpells or {}
  local result = {}

  for _, entry in ipairs(byPriority(rules)) do
    local rule = entry.rule
    local matched = nil
    for _, slot in ipairs(SLOTS) do
      local key = rule.recommend[slot]
      if key and not result[slot] then
        local seal = seals[key]
        if not seal then
          error(("Rule %s references unknown seal: %s"):format(rule.id, key), 0)
        end
        local spellId = highestKnownRank(seal, knownSpells)
        if spellId then
          if matched == nil then matched = Conditions.matches(rule.when, situation) end
          if matched then
            result[slot] = {
              seal = key,
              spellId = spellId,
              ruleId = rule.id,
              why = rule.why,
              confidence = rule.confidence,
            }
          end
        end
      end
    end
  end

  return result
end
