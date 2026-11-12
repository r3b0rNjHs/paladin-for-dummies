describe("Style", function()
  local Style

  before_each(function()
    Style = Addon.load({ "ui/Style.lua" }).UI.Style
  end)

  it("turns the palette into chat color codes", function()
    assert.are.equal("|cfff2c14e", Style.hex("gold"))
    assert.are.equal("|cffe5484d", Style.hex("red"))
    assert.are.equal("|cfff2c14eHola|r", Style.color("gold", "Hola"))
  end)

  it("falls back to the text color for unknown names", function()
    assert.are.equal(Style.hex("text"), Style.hex("nope"))
  end)

  it("gives each icon state its meaning: gold to do, red missing, amber expiring", function()
    assert.are.equal("gold", Style.STATES.recommended.ring)
    assert.are.same({ ring = "red", desaturate = true, marker = true }, Style.STATES.missing)
    assert.are.equal("amber", Style.STATES.expiring.ring)
    assert.is_nil(Style.STATES.normal.ring)
  end)
end)
