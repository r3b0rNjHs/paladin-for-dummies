describe("Plan.prepull", function()
  local Plan

  before_each(function()
    Plan = Addon.load({ "core/Plan.lua" }).Core.Plan
  end)

  local command = { seal = "command", spellId = 20918 }
  local crusader = { seal = "crusader", spellId = 20306 }

  it("puts on the judgement seal, judges, then switches to the fight seal", function()
    local steps = Plan.prepull({ seal = command, judgement = crusader })

    assert.are.same({
      { action = "apply", spellId = 20306 },
      { action = "judge" },
      { action = "switch", spellId = 20918 },
    }, steps)
  end)

  it("does not switch when the judgement seal is also the fight seal", function()
    local steps = Plan.prepull({ seal = command, judgement = command })

    assert.are.same({
      { action = "apply", spellId = 20918 },
      { action = "judge" },
    }, steps)
  end)

  it("only applies the fight seal when there is no judgement to make", function()
    assert.are.same({ { action = "apply", spellId = 20918 } }, Plan.prepull({ seal = command }))
  end)

  it("judges without switching when there is no fight seal", function()
    assert.are.same({
      { action = "apply", spellId = 20306 },
      { action = "judge" },
    }, Plan.prepull({ judgement = crusader }))
  end)

  it("is empty when there is nothing to recommend", function()
    assert.are.same({}, Plan.prepull({}))
  end)
end)
