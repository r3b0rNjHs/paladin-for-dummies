describe("RuleEngine.recommend", function()
  local RuleEngine

  before_each(function()
    local ns = Addon.load({ "core/Conditions.lua", "core/RuleEngine.lua" })
    RuleEngine = ns.Core.RuleEngine
  end)

  -- Datos de prueba propios: los tests no dependen de los IDs reales del juego.
  local seals = {
    alpha = { spellIds = { 101, 102, 103 } },
    beta = { spellIds = { 201 } },
    gamma = { spellIds = {} },
  }

  local function situationKnowing(...)
    local known = {}
    for _, id in ipairs({ ... }) do known[id] = true end
    return {
      player = { spec = "retribution", level = 40, knownSpells = known },
      content = "solo",
      target = { exists = false },
    }
  end

  local function rule(overrides)
    local r = { id = "r", priority = 10, when = {}, why = "porque sí", confidence = "mechanic" }
    for k, v in pairs(overrides) do r[k] = v end
    return r
  end

  it("recommends the seal of the matching rule, with its highest known rank", function()
    local rules = { rule({ id = "use-alpha", recommend = { seal = "alpha" } }) }

    local result = RuleEngine.recommend(situationKnowing(101, 102), rules, seals)

    assert.are.same({
      seal = "alpha",
      spellId = 102,
      ruleId = "use-alpha",
      why = "porque sí",
      confidence = "mechanic",
    }, result.seal)
  end)

  it("picks the rule with the highest priority", function()
    local rules = {
      rule({ id = "low", priority = 1, recommend = { seal = "alpha" } }),
      rule({ id = "high", priority = 50, recommend = { seal = "beta" } }),
    }

    local result = RuleEngine.recommend(situationKnowing(101, 201), rules, seals)

    assert.are.equal("high", result.seal.ruleId)
  end)

  it("skips rules whose conditions do not match", function()
    local rules = {
      rule({ id = "prot-only", priority = 50, when = { spec = "protection" }, recommend = { seal = "beta" } }),
      rule({ id = "fallback", priority = 1, recommend = { seal = "alpha" } }),
    }

    local result = RuleEngine.recommend(situationKnowing(101, 201), rules, seals)

    assert.are.equal("fallback", result.seal.ruleId)
  end)

  it("skips rules that recommend a seal the player has not learned", function()
    local rules = {
      rule({ id = "unknown-seal", priority = 50, recommend = { seal = "beta" } }),
      rule({ id = "no-ids-yet", priority = 40, recommend = { seal = "gamma" } }),
      rule({ id = "fallback", priority = 1, recommend = { seal = "alpha" } }),
    }

    local result = RuleEngine.recommend(situationKnowing(101), rules, seals)

    assert.are.equal("fallback", result.seal.ruleId)
  end)

  it("decides the seal and the judgement independently", function()
    local rules = {
      rule({ id = "seal-rule", priority = 10, recommend = { seal = "alpha" } }),
      rule({ id = "judgement-rule", priority = 10, recommend = { judgement = "beta" } }),
    }

    local result = RuleEngine.recommend(situationKnowing(101, 201), rules, seals)

    assert.are.equal("alpha", result.seal.seal)
    assert.are.equal("beta", result.judgement.seal)
    assert.are.equal(201, result.judgement.spellId)
    assert.are.equal("judgement-rule", result.judgement.ruleId)
  end)

  it("returns nothing for a slot when no rule applies", function()
    local result = RuleEngine.recommend(situationKnowing(), {}, seals)

    assert.is_nil(result.seal)
    assert.is_nil(result.judgement)
  end)

  it("breaks priority ties by rule order, so the result is deterministic", function()
    local rules = {
      rule({ id = "first", priority = 10, recommend = { seal = "alpha" } }),
      rule({ id = "second", priority = 10, recommend = { seal = "beta" } }),
    }

    local result = RuleEngine.recommend(situationKnowing(101, 201), rules, seals)

    assert.are.equal("first", result.seal.ruleId)
  end)

  it("fails loudly when a rule references a seal that does not exist", function()
    local rules = { rule({ id = "typo", recommend = { seal = "alfa" } }) }

    assert.has_error(function()
      RuleEngine.recommend(situationKnowing(101), rules, seals)
    end, "Rule typo references unknown seal: alfa")
  end)
end)
