describe("FightStyle.classify", function()
  local FightStyle

  before_each(function()
    FightStyle = Addon.load({ "core/FightStyle.lua" }).Core.FightStyle
  end)

  -- Un registro con el sello inicial y los sellos lanzados en orden.
  local function fight(opening, ...)
    local timeline = {}
    for i, seal in ipairs({ ... }) do
      timeline[#timeline + 1] = { t = i, kind = "seal", seal = seal }
      timeline[#timeline + 1] = { t = i + 0.5, kind = "judgement" } -- ruido: no cuenta
    end
    return { openingSeal = opening, timeline = timeline }
  end

  it("is a single seal when it never changes", function()
    assert.are.equal("solo:command", FightStyle.classify(fight("command")))
    assert.are.equal("solo:righteousness", FightStyle.classify(fight(nil, "righteousness")))
  end)

  it("ignores recasting the same seal", function()
    assert.are.equal("solo:command", FightStyle.classify(fight("command", "command", "command")))
  end)

  it("recognises judging Crusader and then switching to a damage seal", function()
    assert.are.equal("crusader-then:command", FightStyle.classify(fight("crusader", "command")))
    assert.are.equal("crusader-then:command", FightStyle.classify(fight(nil, "crusader", "command", "command")))
  end)

  it("recognises Unsealed Wrath twisting between Command and Righteousness", function()
    assert.are.equal("twist", FightStyle.classify(fight("command", "righteousness", "command")))
    assert.are.equal("twist", FightStyle.classify(fight("crusader", "command", "righteousness", "command", "righteousness")))
  end)

  it("needs at least two switches to call it twisting", function()
    assert.are.equal("mixed", FightStyle.classify(fight("command", "righteousness")))
  end)

  it("calls anything else mixed", function()
    assert.are.equal("mixed", FightStyle.classify(fight("command", "light")))
    assert.are.equal("mixed", FightStyle.classify(fight("light", "crusader", "command")))
  end)

  it("has no style without any seal", function()
    assert.are.equal("none", FightStyle.classify(fight(nil)))
  end)

  it("copes with old records saved without a timeline", function()
    assert.are.equal("solo:command", FightStyle.classify({ openingSeal = "command" }))
  end)
end)
