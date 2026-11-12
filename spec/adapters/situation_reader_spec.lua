describe("SituationReader.read", function()
  local SituationReader

  before_each(function()
    SituationReader = Addon.load({ "adapters/SituationReader.lua" }).Adapters.SituationReader
  end)

  local seals = {
    command = { spellIds = { 20375, 20918 } },
    crusader = { spellIds = { 21082 } },
  }

  -- Valor "secret" simulado: el adaptador nunca debe dejarlo pasar a la Situation.
  local SECRET = setmetatable({}, { __tostring = function() return "<secret>" end })

  -- API de WoW falsa con valores por defecto razonables; cada test cambia lo que necesita.
  local function fakeApi(overrides)
    local spellbook = { 20375, 20918, 21082, 635 }
    local api = {
      issecretvalue = function(v) return v == SECRET end,
      UnitLevel = function() return 40 end,
      UnitExists = function() return true end,
      UnitCanAttack = function() return true end,
      UnitCreatureType = function() return "Undead", 6 end,
      UnitClassification = function() return "normal" end,
      IsInInstance = function() return false, "none" end,
      IsInGroup = function() return false end,
      IsInRaid = function() return false end,
      Enum = { SpellBookSpellBank = { Player = 0 } },
      C_SpellBook = {
        GetNumSpellBookSkillLines = function() return 1 end,
        GetSpellBookSkillLineInfo = function() return { itemIndexOffset = 0, numSpellBookItems = #spellbook } end,
        GetSpellBookItemInfo = function(i) return { spellID = spellbook[i] } end,
      },
    }
    for k, v in pairs(overrides or {}) do api[k] = v end
    return api
  end

  it("reads the player level and the seal ranks they know", function()
    local situation = SituationReader.read(fakeApi(), seals)

    assert.are.equal(40, situation.player.level)
    assert.are.same({ [20375] = true, [20918] = true, [21082] = true }, situation.player.knownSpells)
  end)

  it("discovers other ranks of a spell from the spellbook by the name of the known rank", function()
    local book = {
      { spellID = 21084, name = "Seal of Righteousness" }, -- rango 1, el que conocemos
      { spellID = 20290, name = "Seal of Righteousness" }, -- rango 5, ID nuevo
      { spellID = 20918, name = "Seal of Command" },
      { spellID = 999, name = "Something Else" },
    }
    local situation, diagnostics = SituationReader.read(fakeApi({
      C_SpellBook = {
        GetNumSpellBookSkillLines = function() return 1 end,
        GetSpellBookSkillLineInfo = function() return { itemIndexOffset = 0, numSpellBookItems = #book } end,
        GetSpellBookItemInfo = function(i) return book[i] end,
      },
      C_Spell = {
        GetSpellName = function(id)
          return ({ [21084] = "Seal of Righteousness", [20375] = "Seal of Command" })[id]
        end,
      },
    }), { righteousness = { spellIds = { 21084 } }, command = { spellIds = { 20375, 20918 } } })

    assert.is_true(situation.player.knownSpells[20290])
    assert.are.same({ 21084, 20290 }, diagnostics.discoveredRanks.righteousness)
    assert.are.same({ 20918 }, diagnostics.discoveredRanks.command)
  end)

  it("reads the weapon and the Holy spell power", function()
    local situation = SituationReader.read(fakeApi({
      UnitAttackSpeed = function() return 2.4, nil end,
      UnitDamage = function() return 110.5, 160.2 end,
      GetSpellBonusDamage = function(school) return school == 2 and 35 or 0 end,
    }), seals)

    assert.are.same({ speed = 2.4, minDamage = 110.5, maxDamage = 160.2 }, situation.player.weapon)
    assert.are.equal(35, situation.player.spellPower)
  end)

  it("reports secret weapon stats instead of passing them on", function()
    local situation, diagnostics = SituationReader.read(fakeApi({
      UnitAttackSpeed = function() return SECRET end,
      UnitDamage = function() return SECRET, SECRET end,
      GetSpellBonusDamage = function() return SECRET end,
    }), seals)

    assert.are.same({}, situation.player.weapon)
    assert.is_nil(situation.player.spellPower)
    assert.is_true(diagnostics.secret.weaponSpeed)
    assert.is_true(diagnostics.secret.weaponDamage)
    assert.is_true(diagnostics.secret.spellPower)
  end)

  it("reads an attackable target by creature type id, not by its localized name", function()
    local situation = SituationReader.read(fakeApi({ UnitLevel = function(unit) return unit == "target" and 38 or 40 end }), seals)

    assert.are.same({ exists = true, creatureType = 6, classification = "normal", level = 38 }, situation.target)
  end)

  it("treats a friendly target as no target, so enemy rules never fire on allies", function()
    local situation = SituationReader.read(fakeApi({ UnitCanAttack = function() return false end }), seals)

    assert.are.same({ exists = false }, situation.target)
  end)

  it("drops secret values instead of passing them to the core", function()
    local situation = SituationReader.read(fakeApi({
      UnitCreatureType = function() return SECRET, SECRET end,
      UnitClassification = function() return SECRET end,
    }), seals)

    assert.is_nil(situation.target.creatureType)
    assert.is_nil(situation.target.classification)
  end)

  it("reports which target values came back secret, to tell them apart from missing ones", function()
    local _, diagnostics = SituationReader.read(fakeApi({
      UnitCreatureType = function() return SECRET, SECRET end,
      UnitLevel = function(unit) return unit == "target" and SECRET or 40 end,
    }), seals)

    assert.are.same({ creatureType = true, level = true }, diagnostics.secret)
  end)

  it("reports no secrets when everything is readable", function()
    local _, diagnostics = SituationReader.read(fakeApi(), seals)

    assert.are.same({}, diagnostics.secret)
  end)

  it("survives API functions that throw", function()
    local situation = SituationReader.read(fakeApi({
      UnitCreatureType = function() error("boom") end,
    }), seals)

    assert.is_true(situation.target.exists)
    assert.is_nil(situation.target.creatureType)
  end)

  describe("content", function()
    local cases = {
      { "solo", false, "none", false, false },
      { "group", false, "none", true, false },
      { "group", false, "none", true, true },
      { "dungeon", true, "party", true, false },
      { "raid", true, "raid", true, true },
      { "pvp", true, "pvp", true, false },
      { "pvp", true, "arena", true, false },
    }
    for _, c in ipairs(cases) do
      local expected, inInstance, instanceType, inGroup, inRaid = c[1], c[2], c[3], c[4], c[5]
      it(("is %s for instance %s, group %s"):format(expected, instanceType, tostring(inGroup)), function()
        local situation = SituationReader.read(fakeApi({
          IsInInstance = function() return inInstance, instanceType end,
          IsInGroup = function() return inGroup end,
          IsInRaid = function() return inRaid end,
        }), seals)
        assert.are.equal(expected, situation.content)
      end)
    end
  end)

  describe("spec", function()
    it("uses the manual override above anything else", function()
      local situation, diagnostics = SituationReader.read(fakeApi(), seals, { specOverride = "protection" })

      assert.are.equal("protection", situation.player.spec)
      assert.are.equal("override", diagnostics.specSource)
    end)

    it("reads a modern specialization id (Retribution = 70)", function()
      local situation, diagnostics = SituationReader.read(fakeApi({
        C_SpecializationInfo = {
          GetSpecialization = function() return 3 end,
          GetSpecializationInfo = function() return 70, "Retribution" end,
        },
      }), seals)

      assert.are.equal("retribution", situation.player.spec)
      assert.are.equal("specialization", diagnostics.specSource)
    end)

    it("falls back to the classic talent tree with the most points", function()
      local points = { 5, 0, 31 } -- Holy, Protection, Retribution
      local situation, diagnostics = SituationReader.read(fakeApi({
        GetNumTalentTabs = function() return 3 end,
        GetTalentTabInfo = function(i) return 800 + i, "Tab", "desc", 1234, points[i] end,
      }), seals)

      assert.are.equal("retribution", situation.player.spec)
      assert.are.equal("talents", diagnostics.specSource)
    end)

    it("understands the old classic signature of GetTalentTabInfo (name first)", function()
      local points = { 0, 21, 0 }
      local situation = SituationReader.read(fakeApi({
        GetNumTalentTabs = function() return 3 end,
        GetTalentTabInfo = function(i) return "Tab", 1234, points[i] end,
      }), seals)

      assert.are.equal("protection", situation.player.spec)
    end)

    it("leaves the spec empty when no talent points are spent", function()
      local situation, diagnostics = SituationReader.read(fakeApi({
        GetNumTalentTabs = function() return 3 end,
        GetTalentTabInfo = function() return 800, "Tab", "desc", 1234, 0 end,
      }), seals)

      assert.is_nil(situation.player.spec)
      assert.are.equal("none", diagnostics.specSource)
    end)

    it("maps Forever's own Retribution spec id (1486, seen in game)", function()
      local situation, diagnostics = SituationReader.read(fakeApi({
        C_SpecializationInfo = {
          GetSpecialization = function() return 3 end,
          GetSpecializationInfo = function() return 1486, "Retribution", "desc", 135873, "DAMAGER" end,
        },
      }), seals)

      assert.are.equal("retribution", situation.player.spec)
      assert.are.equal("specialization", diagnostics.specSource)
      assert.is_nil(diagnostics.unknownSpecId)
    end)

    it("falls back to the role token when the spec id is unknown", function()
      local roles = { HEALER = "holy", TANK = "protection", DAMAGER = "retribution" }
      for role, expected in pairs(roles) do
        local situation, diagnostics = SituationReader.read(fakeApi({
          C_SpecializationInfo = {
            GetSpecialization = function() return 1 end,
            GetSpecializationInfo = function() return 9999, "Localized name", "desc", 1, role end,
          },
        }), seals)

        assert.are.equal(expected, situation.player.spec)
        assert.are.equal("role", diagnostics.specSource)
        assert.are.equal(9999, diagnostics.unknownSpecId)
      end
    end)

    it("reports an unknown specialization id so we can map it", function()
      local situation, diagnostics = SituationReader.read(fakeApi({
        C_SpecializationInfo = {
          GetSpecialization = function() return 1 end,
          GetSpecializationInfo = function() return 1501, "Something" end,
        },
      }), seals)

      assert.is_nil(situation.player.spec)
      assert.are.equal(1501, diagnostics.unknownSpecId)
    end)
  end)
end)
