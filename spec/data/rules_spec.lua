-- Tests sobre los datos reales (data/Seals.lua y data/Rules.lua).
describe("Reglas reales", function()
  local ns

  before_each(function()
    ns = Addon.load({
      "core/Conditions.lua",
      "core/RuleEngine.lua",
      "data/Seals.lua",
      "data/Rules.lua",
    })
  end)

  local function known(ids)
    local set = {}
    for _, id in ipairs(ids) do set[id] = true end
    return set
  end

  local function recommend(situation)
    return ns.Core.RuleEngine.recommend(situation, ns.Data.Rules, ns.Data.Seals)
  end

  describe("integridad", function()
    local CONFIDENCES = { mechanic = true, consensus = true, measured = true }

    it("every rule has a unique id, a reason and a valid confidence", function()
      local seen = {}
      for _, r in ipairs(ns.Data.Rules) do
        assert.is_string(r.id)
        assert.is_nil(seen[r.id], "duplicated rule id: " .. r.id)
        seen[r.id] = true
        assert.is_string(r.why, r.id .. " has no reason")
        assert.is_true(CONFIDENCES[r.confidence] == true, r.id .. " has an invalid confidence")
        assert.is_number(r.priority, r.id .. " has no priority")
      end
    end)

    it("every rule references existing seals", function()
      for _, r in ipairs(ns.Data.Rules) do
        for _, key in pairs(r.recommend) do
          assert.is_table(ns.Data.Seals[key], r.id .. " references unknown seal " .. key)
        end
      end
    end)
  end)

  describe("escenarios", function()
    -- Volcado del grimorio del sondeo 1: paladín Ret nivel 40.
    local probe1Spells = known({
      20375, 20915, 20918,        -- Seal of Command, rangos 1-3
      21082, 20162, 20305, 20306, -- Seal of the Crusader, rangos 1-4
      20165,                      -- Seal of Light, rango 1
      21084,                      -- Seal of Righteousness, rango 1
    })

    it("Ret de nivel 40 del sondeo 1: Command con su mejor rango y Sentencia de Crusader", function()
      local result = recommend({
        player = { spec = "retribution", level = 40, knownSpells = probe1Spells },
        content = "solo",
        target = { exists = true, creatureType = 6, classification = "normal", level = 38 },
      })

      assert.are.equal("command", result.seal.seal)
      assert.are.equal(20918, result.seal.spellId)
      assert.are.equal("crusader", result.judgement.seal)
      assert.are.equal(20306, result.judgement.spellId)
    end)

    it("paladín de nivel 1: Righteousness, el único sello que tiene", function()
      local result = recommend({
        player = { spec = "retribution", level = 1, knownSpells = known({ 21084 }) },
        content = "solo",
        target = { exists = false },
      })

      assert.are.equal("righteousness", result.seal.seal)
      assert.are.equal("righteousness", result.judgement.seal)
    end)

    it("no recomienda Justice contra humanoides mientras no conozcamos sus spellIDs", function()
      local result = recommend({
        player = { spec = "retribution", level = 40, knownSpells = probe1Spells },
        content = "solo",
        target = { exists = true, creatureType = 7, classification = "normal", level = 40 },
      })

      assert.are_not.equal("justice", result.seal.seal)
    end)
  end)
end)
