describe("Macros.build", function()
  local Macros

  before_each(function()
    Macros = Addon.load({ "core/Macros.lua" }).Core.Macros
  end)

  local seals = {
    command = { spellIds = { 20375, 20918 } },
    righteousness = { spellIds = { 21084, 20287 } },
    crusader = { spellIds = { 20306 } },
  }

  local NAMES = {
    [20918] = "Seal of Command", [20375] = "Seal of Command",
    [21084] = "Seal of Righteousness", [20287] = "Seal of Righteousness",
    [20306] = "Seal of the Crusader", [20271] = "Judgement", [679] = "Holy Strike",
  }

  local function input(overrides)
    local i = {
      seals = seals,
      knownSpells = { [20375] = true, [20918] = true, [21084] = true, [20306] = true },
      judgementSpellId = 20271,
      holyStrikeSpellId = 679,
      nameOf = function(id) return NAMES[id] end,
      recommendation = {
        seal = { seal = "command", spellId = 20918 },
        judgement = { seal = "crusader", spellId = 20306 },
      },
    }
    for k, v in pairs(overrides or {}) do i[k] = v end
    return i
  end

  local function byName(macros)
    local out = {}
    for _, m in ipairs(macros) do out[m.name] = m.body end
    return out
  end

  it("no longer builds an opener: Crusader is cast from its own button", function()
    local macros = byName(Macros.build(input()))

    assert.is_nil(macros["PFD Apertura"])
  end)

  it("builds PFD Golpe with Judgement and Holy Strike, hiding the 'not ready' error", function()
    local macros = byName(Macros.build(input()))

    assert.are.equal("#showtooltip\n/cast Judgement\n/cast Holy Strike\n/run UIErrorsFrame:Clear()", macros["PFD Golpe"])
  end)

  it("builds the Unsealed Wrath toggle, starting with Command and restarting on a new target, and the shift macro", function()
    local macros = byName(Macros.build(input()))

    assert.are.equal("#showtooltip\n/castsequence reset=target/combat Seal of Command, Seal of Righteousness",
      macros["PFD Unsealed"])
    assert.are.equal("#showtooltip\n/cast [mod:shift] Seal of Righteousness; Seal of Command",
      macros["PFD Sello"])
  end)

  it("skips the twisting macros when Righteousness or Command is not known", function()
    local macros = byName(Macros.build(input({ knownSpells = { [20918] = true, [20306] = true } })))

    assert.is_nil(macros["PFD Unsealed"])
    assert.is_nil(macros["PFD Sello"])
    assert.is_string(macros["PFD Golpe"])
  end)

  it("skips a macro when a spell name cannot be resolved", function()
    local macros = byName(Macros.build(input({ nameOf = function(id) return id ~= 20271 and NAMES[id] or nil end })))

    assert.is_nil(macros["PFD Golpe"])
    assert.is_string(macros["PFD Sello"])
  end)

  it("explains why each skipped macro could not be built", function()
    local _, skipped = Macros.build(input({
      knownSpells = { [20918] = true, [20306] = true },
      nameOf = function(id) return id ~= 20271 and NAMES[id] or nil end,
    }))

    assert.are.same({
      { name = "PFD Golpe", reason = "falta el nombre de algún hechizo (spellID 20271)" },
      { name = "PFD Unsealed", reason = "no conoces Seal of Righteousness" },
      { name = "PFD Sello", reason = "no conoces Seal of Righteousness" },
    }, skipped)
  end)

  it("keeps names within 16 characters and bodies within 255", function()
    for _, m in ipairs(Macros.build(input())) do
      assert.is_true(#m.name <= 16, m.name)
      assert.is_true(#m.body <= 255, m.name)
    end
  end)
end)
