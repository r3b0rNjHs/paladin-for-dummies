describe("Sustain", function()
  local Sustain

  before_each(function()
    Sustain = Addon.load({ "core/Sustain.lua" }).Core.Sustain
  end)

  describe("spellReady (Hammer of Wrath cooldown)", function()
    it("is ready when the cooldown is not active", function()
      assert.is_true(Sustain.spellReady({ isActive = false }))
    end)

    it("is not ready while the cooldown runs", function()
      assert.is_false(Sustain.spellReady({ isActive = true, isOnGCD = false }))
      assert.is_false(Sustain.spellReady({ isActive = true }))
    end)

    it("ignores the global cooldown: the spell is ready right after it", function()
      assert.is_true(Sustain.spellReady({ isActive = true, isOnGCD = true }))
    end)

    it("does not hide the alert when the game gives no usable data", function()
      assert.is_true(Sustain.spellReady(nil))
      assert.is_true(Sustain.spellReady({}))
    end)

    it("never compares a secret value", function()
      local secret = {}
      _G.issecretvalue = function(v) return v == secret end
      assert.is_true(Sustain.spellReady({ isActive = secret }))
      _G.issecretvalue = nil
    end)
  end)

  it("builds a curve that is 1 (shown) up to the threshold and 0 (hidden) above it", function()
    assert.are.same({ { 0, 1 }, { 0.3, 1 }, { 0.31, 0 }, { 1, 0 } }, Sustain.points(0.3))
  end)

  it("keeps the threshold between 5 % and 90 %", function()
    assert.are.equal(0.05, Sustain.points(0)[2][1])
    assert.are.equal(0.9, Sustain.points(2)[2][1])
  end)

  it("shows Light for health and Wisdom for mana, only the seals you know", function()
    assert.are.same({ "light", "wisdom" }, Sustain.slots({ light = true, wisdom = true, hammer = true }))
    assert.are.same({ "light" }, Sustain.slots({ light = true }))
    assert.are.same({}, Sustain.slots({}))
  end)
end)
