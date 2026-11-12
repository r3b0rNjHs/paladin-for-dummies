describe("EchoTracker.toCenter", function()
  local EchoTracker

  before_each(function()
    EchoTracker = Addon.load({ "ui/EchoTracker.lua" }).UI.EchoTracker
  end)

  it("keeps a position that is already the center", function()
    local pos = EchoTracker.toCenter({ point = "CENTER", relativePoint = "CENTER", x = 10, y = -80 }, 100, 100)
    assert.are.same({ point = "CENTER", relativePoint = "CENTER", x = 10, y = -80 }, pos)
  end)

  it("turns a corner into the center of a box of that size", function()
    -- La esquina inferior izquierda en (200, 300) de un recuadro de 144x88:
    -- su centro está 72 a la derecha y 44 más arriba.
    local pos = EchoTracker.toCenter({ point = "BOTTOMLEFT", relativePoint = "BOTTOMLEFT", x = 200, y = 300 }, 144, 88)
    assert.are.same({ point = "CENTER", relativePoint = "BOTTOMLEFT", x = 272, y = 344 }, pos)
  end)

  it("handles the top and right sides", function()
    local pos = EchoTracker.toCenter({ point = "TOPRIGHT", relativePoint = "TOPRIGHT", x = -20, y = -30 }, 100, 60)
    assert.are.same({ point = "CENTER", relativePoint = "TOPRIGHT", x = -70, y = -60 }, pos)
  end)

  it("handles the middle of a side", function()
    local pos = EchoTracker.toCenter({ point = "LEFT", relativePoint = "CENTER", x = 0, y = 5 }, 100, 60)
    assert.are.same({ point = "CENTER", relativePoint = "CENTER", x = 50, y = 5 }, pos)
  end)

  it("ignores missing or broken positions", function()
    assert.is_nil(EchoTracker.toCenter(nil, 100, 100))
    assert.is_nil(EchoTracker.toCenter({ point = "CENTER" }, 100, 100))
  end)
end)

describe("EchoTracker.destinationIcon", function()
  local EchoTracker

  before_each(function()
    EchoTracker = Addon.load({ "ui/EchoTracker.lua" }).UI.EchoTracker
  end)

  local function echo(key)
    for _, e in ipairs(EchoTracker.ECHOES) do if e.key == key then return e end end
  end

  it("shows the seal you have to switch to, not the one you have", function()
    local asked = {}
    local getTexture = function(id) asked[#asked + 1] = id; return id * 10 end

    assert.are.equal(210840, EchoTracker.destinationIcon(echo("echoCommand"), getTexture))       -- Righteousness
    assert.are.equal(203750, EchoTracker.destinationIcon(echo("echoRighteousness"), getTexture)) -- Command
    assert.are.same({ 21084, 20375 }, asked)
  end)

  it("returns nil when the icon cannot be read, so the aura icon is used", function()
    assert.is_nil(EchoTracker.destinationIcon(echo("echoCommand"), function() error("boom") end))
    assert.is_nil(EchoTracker.destinationIcon(echo("echoCommand"), nil))
    assert.is_nil(EchoTracker.destinationIcon(echo("echoCommand"), function() return nil end))
  end)
end)
