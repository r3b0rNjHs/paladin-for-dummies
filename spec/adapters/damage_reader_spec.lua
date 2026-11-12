describe("FightReader.readDamage", function()
  local FightReader

  before_each(function()
    FightReader = Addon.load({ "adapters/FightReader.lua" }).Adapters.FightReader
  end)

  local SECRET = setmetatable({}, {})

  local function api(source, opts)
    opts = opts or {}
    local calls = {}
    local a = {
      issecretvalue = function(v) return v == SECRET end,
      UnitGUID = function(unit) return unit == "player" and "Player-1" or nil end,
      C_DamageMeter = {
        GetCombatSessionSourceFromType = function(sessionType, meterType, guid)
          calls[#calls + 1] = { sessionType, meterType, guid }
          if opts.fail then error("boom") end
          return source
        end,
      },
    }
    return a, calls
  end

  it("reads your damage by spell from the current session of Blizzard's damage meter", function()
    local a, calls = api({ totalAmount = 5000, combatSpells = {
      { spellID = 20424, totalAmount = 1200 },
      { spellID = 6603, totalAmount = 3000 },
      { spellID = 20290, totalAmount = 800 },
    } })

    local damage = FightReader.readDamage(a)

    assert.are.same({ total = 5000, spells = { [20424] = 1200, [6603] = 3000, [20290] = 800 } }, damage)
    assert.are.same({ { 1, 0, "Player-1" } }, calls) -- Current, DamageDone, tú
  end)

  it("skips secret values instead of storing them", function()
    local damage, reason = FightReader.readDamage(api({ totalAmount = SECRET, combatSpells = SECRET }))
    assert.is_nil(damage)
    assert.are.equal("secret", reason)

    damage = FightReader.readDamage(api({ totalAmount = 10, combatSpells = {
      { spellID = 1, totalAmount = SECRET }, { spellID = SECRET, totalAmount = 5 }, { spellID = 2, totalAmount = 10 },
    } }))
    assert.are.same({ total = 10, spells = { [2] = 10 } }, damage)
  end)

  it("says why when the damage meter is not there or fails", function()
    local a = api(nil)
    a.C_DamageMeter = nil
    assert.are.equal("missing", select(2, FightReader.readDamage(a)))
    assert.are.equal("error", select(2, FightReader.readDamage(api(nil, { fail = true }))))
    assert.are.equal("empty", select(2, FightReader.readDamage(api(nil))))
  end)
end)
