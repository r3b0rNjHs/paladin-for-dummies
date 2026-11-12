describe("Sustain", function()
  local Sustain

  before_each(function()
    Sustain = Addon.load({ "core/Sustain.lua" }).Core.Sustain
  end)

  it("builds a curve that is 1 (shown) up to the threshold and 0 (hidden) above it", function()
    assert.are.same({ { 0, 1 }, { 0.3, 1 }, { 0.31, 0 }, { 1, 0 } }, Sustain.points(0.3))
  end)

  it("keeps the threshold between 5 % and 90 %", function()
    assert.are.equal(0.05, Sustain.points(0)[2][1])
    assert.are.equal(0.9, Sustain.points(2)[2][1])
  end)

  it("shows Light for health and Wisdom for mana, only for the seals you know", function()
    assert.are.same({ "light", "wisdom" }, Sustain.slots({ light = true, wisdom = true }))
    assert.are.same({ "light" }, Sustain.slots({ light = true }))
    assert.are.same({}, Sustain.slots({}))
  end)
end)
