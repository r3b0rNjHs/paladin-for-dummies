-- Macros de utilidad (curas, protección, control...). Todas lanzan sin cambiar
-- tu objetivo enemigo: al aliado bajo el ratón, si no a tu objetivo, si no a ti.
describe("Macros.build: utilidad", function()
  local Macros, ns

  before_each(function()
    ns = Addon.load({ "data/Seals.lua", "data/MacroSpells.lua", "core/Macros.lua" })
    Macros = ns.Core.Macros
  end)

  -- Nombres por clave: cada hechizo de data/MacroSpells.lua devuelve su nombre en inglés.
  local NAMES = {
    flashOfLight = "Flash of Light", holyLight = "Holy Light",
    blessingOfProtection = "Blessing of Protection", divineProtection = "Divine Protection",
    blessingOfFreedom = "Blessing of Freedom", layOnHands = "Lay on Hands", purify = "Purify",
    hammerOfJustice = "Hammer of Justice", repentance = "Repentance", divineShield = "Divine Shield",
    blessingOfMight = "Blessing of Might", blessingOfKings = "Blessing of Kings",
    devotionAura = "Devotion Aura", retributionAura = "Retribution Aura",
    redemption = "Redemption", exorcism = "Exorcism",
  }

  -- Conoce el primer ID de cada hechizo de la lista (o de todos si no se pasa lista).
  local function input(knownKeys)
    local known, nameById = {}, {}
    for key, spell in pairs(ns.Data.MacroSpells) do
      for _, id in ipairs(spell.spellIds) do nameById[id] = NAMES[key] end
    end
    local keys = knownKeys or {}
    if not knownKeys then for key in pairs(NAMES) do keys[#keys + 1] = key end end
    for _, key in ipairs(keys) do known[ns.Data.MacroSpells[key].spellIds[1]] = true end
    return {
      seals = ns.Data.Seals,
      macroSpells = ns.Data.MacroSpells,
      knownSpells = known,
      judgementSpellId = 20271,
      holyStrikeSpellId = 679,
      nameOf = function(id) return nameById[id] end,
    }
  end

  local function build(knownKeys)
    local out = {}
    for _, m in ipairs(Macros.build(input(knownKeys))) do out[m.name] = m.body end
    return out
  end

  local MOUSE_HELP = "[@mouseover,help,nodead][help,nodead][@player]"

  it("heals without changing target, Holy Light with Shift", function()
    assert.are.equal(
      "#showtooltip\n/cast [mod:shift,@mouseover,help,nodead][mod:shift,help,nodead][mod:shift,@player] Holy Light; "
        .. MOUSE_HELP .. " Flash of Light",
      build()["PFD Cura"])
  end)

  it("heals with Flash of Light only when Holy Light is not known", function()
    assert.are.equal("#showtooltip\n/cast " .. MOUSE_HELP .. " Flash of Light", build({ "flashOfLight" })["PFD Cura"])
  end)

  it("casts Blessing of Protection on an ally, or Divine Protection on yourself with Alt", function()
    assert.are.equal(
      "#showtooltip\n/cast [mod:alt] Divine Protection; [@mouseover,help,nodead][help,nodead][@targettarget,help,nodead] Blessing of Protection",
      build()["PFD Proteccion"])
  end)

  it("builds the simple helpful mouseover macros", function()
    local m = build()
    assert.are.equal("#showtooltip\n/cast " .. MOUSE_HELP .. " Blessing of Freedom", m["PFD Libertad"])
    assert.are.equal("#showtooltip\n/cast " .. MOUSE_HELP .. " Lay on Hands", m["PFD Manos"])
    assert.are.equal("#showtooltip\n/cast " .. MOUSE_HELP .. " Purify", m["PFD Purificar"])
  end)

  it("builds the control macros on the enemy under the mouse, or your target", function()
    local m = build()
    assert.are.equal("#showtooltip\n/stopcasting\n/cast [@mouseover,harm,nodead][harm,nodead] Hammer of Justice", m["PFD Martillo"])
    assert.are.equal("#showtooltip\n/cast [@mouseover,harm,nodead][harm,nodead] Repentance", m["PFD Arrepentir"])
  end)

  it("builds a Divine Shield that cancels itself (and the other immunities) when pressed again", function()
    assert.are.equal(
      "#showtooltip Divine Shield\n/cancelaura Divine Shield\n/cancelaura Divine Protection\n/cancelaura Blessing of Protection\n/cast Divine Shield",
      build()["PFD Escudo"])
  end)

  it("builds blessings, auras, resurrection and Exorcism", function()
    local m = build()
    assert.are.equal(
      "#showtooltip\n/cast [mod:ctrl,@mouseover,help,nodead][mod:ctrl] Blessing of Kings; [@mouseover,help,nodead][] Blessing of Might",
      m["PFD Bendicion"])
    assert.are.equal(
      "#showtooltip [mod:ctrl] Retribution Aura; Devotion Aura\n/cast [mod:ctrl] Retribution Aura; Devotion Aura",
      m["PFD Auras"])
    assert.are.equal("#showtooltip\n/cast [@mouseover,help,dead][help,dead] Redemption", m["PFD Resucitar"])
    assert.are.equal("#showtooltip\n/cast [harm,nodead] Exorcism\n/startattack", m["PFD Exorcismo"])
  end)

  it("skips utility macros whose main spell is not known, and says why", function()
    local macros, skipped = Macros.build(input({ "flashOfLight" }))
    local names = {}
    for _, m in ipairs(macros) do names[m.name] = true end

    assert.is_true(names["PFD Cura"])
    assert.is_nil(names["PFD Martillo"])
    local reasons = {}
    for _, s in ipairs(skipped) do reasons[s.name] = s.reason end
    assert.are.equal("no conoces Hammer of Justice", reasons["PFD Martillo"])
  end)

  it("keeps every macro within 16 characters of name and 255 of text", function()
    for _, m in ipairs(Macros.build(input())) do
      assert.is_true(#m.name <= 16, m.name)
      assert.is_true(#m.body <= 255, m.name)
    end
  end)
end)
