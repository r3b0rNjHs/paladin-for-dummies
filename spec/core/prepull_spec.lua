describe("Prepull.alerts", function()
  local Prepull

  before_each(function()
    Prepull = Addon.load({ "core/Prepull.lua" }).Core.Prepull
  end)

  local spells = {
    sealBySpellId = { [20918] = "command", [21082] = "crusader", [21084] = "righteousness" },
    auras = { devotion = { 465, 643 }, retribution = { 7294 }, other = { 19746 } },
    blessings = { might = { 19740, 19834 }, kings = { 20217 }, other = { 19742 } },
    righteousFury = { 25780 },
    exorcism = { 879, 5614 },
  }

  local function situation(over)
    local s = {
      content = "solo",
      target = { exists = true, creatureType = 7 },
      player = {
        spec = "retribution", role = "DAMAGER",
        knownSpells = { [20918] = true, [21082] = true, [465] = true, [7294] = true, [19740] = true, [879] = true, [25780] = true },
        buffs = { [20918] = true, [7294] = true, [19740] = true },
      },
    }
    for k, v in pairs(over or {}) do s[k] = v end
    return s
  end
  local recommendation = { seal = { seal = "command", spellId = 20918 }, judgement = { seal = "crusader", spellId = 21082 } }

  local function kinds(alerts)
    local out = {}
    for _, a in ipairs(alerts) do out[#out + 1] = a.kind .. ":" .. a.state end
    return out
  end

  it("says nothing when everything is in order", function()
    assert.are.same({}, Prepull.alerts(situation(), recommendation, spells))
  end)

  it("says nothing without an enemy targeted, or in combat (no buffs read)", function()
    assert.are.same({}, Prepull.alerts(situation({ target = { exists = false } }), recommendation, spells))
    local s = situation(); s.player.buffs = nil
    assert.are.same({}, Prepull.alerts(s, recommendation, spells))
  end)

  it("asks for the seal when you have none, and for the right one when you wear another", function()
    local s = situation(); s.player.buffs = { [7294] = true, [19740] = true }
    local alerts = Prepull.alerts(s, recommendation, spells)
    assert.are.same({ "seal:missing" }, kinds(alerts))
    assert.are.equal(20918, alerts[1].spellId)

    s.player.buffs = { [21084] = true, [7294] = true, [19740] = true }
    alerts = Prepull.alerts(s, recommendation, spells)
    assert.are.same({ "seal:recommended" }, kinds(alerts))
    assert.are.equal("righteousness", alerts[1].current)
  end)

  it("asks for an aura (Retribution for Retribution) and a blessing when you have none", function()
    local s = situation(); s.player.buffs = { [20918] = true }
    local alerts = Prepull.alerts(s, recommendation, spells)
    assert.are.same({ "aura:missing", "blessing:missing" }, kinds(alerts))
    assert.are.equal(7294, alerts[1].spellId)
    assert.are.equal(19740, alerts[2].spellId)
  end)

  it("accepts any aura or blessing, also from another paladin", function()
    local s = situation(); s.player.buffs = { [20918] = true, [19746] = true, [19742] = true }
    assert.are.same({}, Prepull.alerts(s, recommendation, spells))
  end)

  it("does not ask for what you do not know", function()
    local s = situation(); s.player.knownSpells = { [20918] = true }; s.player.buffs = { [20918] = true }
    assert.are.same({}, Prepull.alerts(s, recommendation, spells))
  end)

  it("reminds tanks of Righteous Fury", function()
    local s = situation(); s.player.role = "TANK"
    assert.are.same({ "fury:missing" }, kinds(Prepull.alerts(s, recommendation, spells)))
  end)

  it("suggests Exorcism against undead and demons in the open world", function()
    local s = situation({ target = { exists = true, creatureType = 6 } })
    local alerts = Prepull.alerts(s, recommendation, spells)
    assert.are.same({ "tip:recommended" }, kinds(alerts))
    assert.are.equal(879, alerts[1].spellId)
    s.content = "dungeon"
    assert.are.same({}, Prepull.alerts(s, recommendation, spells))
  end)
end)
