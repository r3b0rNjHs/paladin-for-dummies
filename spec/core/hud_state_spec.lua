describe("HudState.advisorAlpha", function()
  local HudState

  before_each(function()
    HudState = Addon.load({ "core/HudState.lua" }).Core.HudState
  end)

  local function alpha(mode, inCombat, hasTarget)
    return HudState.advisorAlpha({ mode = mode, inCombat = inCombat, hasTarget = hasTarget })
  end

  it("is fully visible with an attackable target before the pull", function()
    assert.are.equal(1, alpha("fade", false, true))
    assert.are.equal(1, alpha("hide", false, true))
  end)

  it("fades or hides without a target, as the player chose", function()
    assert.are.equal(HudState.FADED, alpha("fade", false, false))
    assert.are.equal(0, alpha("hide", false, false))
    assert.are.equal(1, alpha("always", false, false))
  end)

  it("gets out of the way in combat (the advice is for before the pull)", function()
    assert.are.equal(0, alpha("fade", true, true))
    assert.are.equal(0, alpha("hide", true, false))
    assert.are.equal(1, alpha("always", true, true))
  end)

  it("falls back to fading for unknown modes", function()
    assert.are.equal(HudState.FADED, alpha(nil, false, false))
  end)
end)
