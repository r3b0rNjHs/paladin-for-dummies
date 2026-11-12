describe("Migrations.fromLegacy", function()
  local Migrations

  before_each(function()
    Migrations = Addon.load({ "core/Migrations.lua" }).Core.Migrations
  end)

  it("recognises the old flat format and ignores the AceDB one", function()
    assert.is_true(Migrations.isLegacy({ fights = {}, hidden = true }))
    assert.is_false(Migrations.isLegacy({ profileKeys = {}, profiles = {} }))
    assert.is_false(Migrations.isLegacy(nil))
    assert.is_false(Migrations.isLegacy({}))
  end)

  it("moves settings to the profile and fights to the character", function()
    local fights = { { duration = 20 } }
    local m = Migrations.fromLegacy({
      hidden = true, position = { point = "LEFT", x = 1, y = 2 }, advisorScale = 1.2, advisorLocked = true,
      echo = true, echoPosition = { point = "CENTER", x = 0, y = 150 }, echoScale = 0.9,
      macros = true, macroDisabled = { ["PFD Golpe"] = true },
      quiet = true, fights = fights, test = "A", specOverride = "retribution",
      snapshot = {}, errors = {}, macroStatus = {}, echoStatus = {}, echoDebug = {},
    })

    assert.are.same({
      advisor = { shown = false, position = { point = "LEFT", x = 1, y = 2 }, scale = 1.2, locked = true },
      echo = { shown = true, position = { point = "CENTER", x = 0, y = 150 }, scale = 0.9 },
      macros = { auto = true, disabled = { ["PFD Golpe"] = true } },
    }, m.profile)
    assert.are.same({ fights = fights, test = "A", specOverride = "retribution", welcomed = true }, m.char)
  end)

  it("leaves out what was never set, so the new defaults apply", function()
    local m = Migrations.fromLegacy({ fights = {} })

    assert.are.same({ advisor = {}, echo = {}, macros = {} }, m.profile)
    assert.are.same({ fights = {}, welcomed = true }, m.char)
  end)

  it("copies values into AceDB tables without replacing them", function()
    local target = { advisor = { shown = true, scale = 1 }, keep = "me" }
    Migrations.apply(target, { advisor = { shown = false } })

    assert.are.same({ advisor = { shown = false, scale = 1 }, keep = "me" }, target)
  end)
end)
