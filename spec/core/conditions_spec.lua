describe("Conditions.matches", function()
  local Conditions

  before_each(function()
    Conditions = Addon.load({ "core/Conditions.lua" }).Core.Conditions
  end)

  local situation = {
    player = { spec = "retribution", role = "dps", level = 40 },
    content = "solo",
    target = { exists = true, creatureType = 7, classification = "normal", level = 38 },
  }

  it("matches when there are no conditions", function()
    assert.is_true(Conditions.matches({}, situation))
  end)

  it("matches an exact value", function()
    assert.is_true(Conditions.matches({ spec = "retribution" }, situation))
    assert.is_false(Conditions.matches({ spec = "protection" }, situation))
  end)

  it("matches any value of a list", function()
    assert.is_true(Conditions.matches({ targetCreatureType = { 6, 7 } }, situation))
    assert.is_false(Conditions.matches({ targetCreatureType = { 1, 6 } }, situation))
  end)

  it("requires every condition to match", function()
    assert.is_true(Conditions.matches({ spec = "retribution", content = "solo" }, situation))
    assert.is_false(Conditions.matches({ spec = "retribution", content = "raid" }, situation))
  end)

  it("does not match target conditions when there is no target", function()
    local noTarget = { player = situation.player, content = "solo", target = { exists = false } }
    assert.is_false(Conditions.matches({ targetCreatureType = 7 }, noTarget))
  end)

  it("rejects unknown condition names instead of ignoring them", function()
    assert.has_error(function()
      Conditions.matches({ targetMana = 50 }, situation)
    end, "Unknown condition: targetMana")
  end)
end)
