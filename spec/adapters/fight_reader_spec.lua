describe("FightReader.readOpening", function()
  local FightReader

  before_each(function()
    FightReader = Addon.load({ "adapters/FightReader.lua" }).Adapters.FightReader
  end)

  local catalog = {
    sealBySpellId = { [20918] = "command", [21084] = "righteousness" },
    echoBySpellId = { [1311703] = "command", [1311704] = "righteousness" },
  }

  local SECRET = setmetatable({}, {})

  local function apiWithAuras(auras)
    return {
      issecretvalue = function(v) return v == SECRET end,
      GetTime = function() return 1000 end,
      C_UnitAuras = {
        GetAuraDataByIndex = function(_, i) return auras[i] end,
      },
    }
  end

  it("finds the active seal by spellID and when it expires", function()
    local opening = FightReader.readOpening(apiWithAuras({
      { spellId = 465, expirationTime = 0, applications = 0 },          -- aura cualquiera
      { spellId = 20918, expirationTime = 1021.5, applications = 0 },   -- Seal of Command
    }), catalog)

    assert.are.same({ t = 1000, seal = "command", sealExpires = 1021.5, echoes = {} }, opening)
  end)

  it("reads Unsealed Wrath echoes with their stacks", function()
    local opening = FightReader.readOpening(apiWithAuras({
      { spellId = 20918, expirationTime = 1020, applications = 0 },
      { spellId = 1311703, expirationTime = 1010, applications = 3 },
    }), catalog)

    assert.are.same({ command = 3 }, opening.echoes)
  end)

  it("has no seal when none is active", function()
    local opening = FightReader.readOpening(apiWithAuras({ { spellId = 465 } }), catalog)

    assert.is_nil(opening.seal)
    assert.are.equal(1000, opening.t)
  end)

  it("ignores secret aura fields", function()
    local opening = FightReader.readOpening(apiWithAuras({
      { spellId = SECRET, expirationTime = 1020 },
      { spellId = 20918, expirationTime = SECRET },
    }), catalog)

    assert.are.equal("command", opening.seal)
    assert.is_nil(opening.sealExpires)
  end)

  it("survives the aura API throwing (as it does once in combat)", function()
    local api = apiWithAuras({})
    api.C_UnitAuras.GetAuraDataByIndex = function() error("Auras cannot be accessed when secret") end

    local opening = FightReader.readOpening(api, catalog)

    assert.are.same({ t = 1000, echoes = {} }, opening)
  end)
end)
