describe("Fight", function()
  local Fight

  before_each(function()
    Fight = Addon.load({ "core/Fight.lua" }).Core.Fight
  end)

  -- Catálogo de prueba: qué spellID es qué. Los tests no dependen de los IDs reales.
  local catalog = {
    sealBySpellId = { [10] = "command", [20] = "righteousness", [30] = "crusader" },
    judgement = { [100] = true },
    holyStrike = { [200] = true, [201] = true },
    commandProc = { [300] = true },
  }

  local function fight(opening)
    return Fight.start(catalog, opening or {}, { content = "solo" })
  end

  describe("seal time", function()
    it("counts the opening seal until the fight ends", function()
      local f = fight({ t = 100, seal = "command", sealExpires = 125 })
      local record = Fight.finish(f, { t = 112, time = 5000 })

      assert.are.same({ command = 12 }, record.sealSeconds)
      assert.are.equal(12, record.duration)
    end)

    it("stops counting the opening seal when it expires", function()
      local f = fight({ t = 100, seal = "command", sealExpires = 105 })
      local record = Fight.finish(f, { t = 120, time = 5000 })

      assert.are.same({ command = 5 }, record.sealSeconds)
    end)

    it("switches seals on seal casts, each lasting 30 s", function()
      local f = fight({ t = 0, seal = "crusader", sealExpires = 30 })
      Fight.cast(f, 2, 10)   -- Command
      Fight.cast(f, 8, 20)   -- Righteousness
      Fight.cast(f, 9, 10)   -- Command otra vez
      local record = Fight.finish(f, { t = 50, time = 5000 })

      assert.are.same({ crusader = 2, command = 6 + 30, righteousness = 1 }, record.sealSeconds)
    end)

    it("works without an opening seal", function()
      local f = fight({ t = 0 })
      Fight.cast(f, 4, 20)
      local record = Fight.finish(f, { t = 10, time = 5000 })

      assert.are.same({ righteousness = 6 }, record.sealSeconds)
    end)

    it("rounds seconds to one decimal", function()
      local f = fight({ t = 0.04, seal = "command", sealExpires = 30 })
      local record = Fight.finish(f, { t = 10.0, time = 5000 })

      assert.are.equal(10, record.sealSeconds.command)
      assert.are.equal(10, record.duration)
    end)
  end)

  describe("counts", function()
    it("counts judgements, holy strikes of any rank, Command procs and seal casts", function()
      local f = fight({ t = 0, seal = "command", sealExpires = 30 })
      Fight.cast(f, 1, 100)
      Fight.cast(f, 2, 200)
      Fight.cast(f, 3, 201)
      Fight.cast(f, 4, 300)
      Fight.cast(f, 5, 300)
      Fight.cast(f, 6, 20)
      Fight.cast(f, 7, 999) -- otro hechizo: no cuenta
      local record = Fight.finish(f, { t = 10, time = 5000 })

      assert.are.same({ judgement = 1, holyStrike = 2, commandProc = 2, sealCast = 1 }, record.counts)
    end)

    it("ignores casts that are not numbers (a secret spellID never reaches here as a number)", function()
      local f = fight({ t = 0 })
      Fight.cast(f, 1, nil)
      Fight.cast(f, 2, "20424")
      local record = Fight.finish(f, { t = 5, time = 5000 })

      assert.are.same({ judgement = 0, holyStrike = 0, commandProc = 0, sealCast = 0 }, record.counts)
    end)
  end)

  describe("timeline", function()
    it("keeps every tracked cast with its second from the start of the fight", function()
      local f = fight({ t = 100, seal = "command", sealExpires = 130 })
      Fight.cast(f, 101.04, 100)  -- Judgement
      Fight.cast(f, 102.5, 200)   -- Holy Strike
      Fight.cast(f, 103, 300)     -- activación de Command
      Fight.cast(f, 104, 20)      -- Righteousness
      Fight.cast(f, 105, 999)     -- otro hechizo: no se guarda
      local record = Fight.finish(f, { t = 110, time = 5000 })

      assert.are.same({
        { t = 1, kind = "judgement" },
        { t = 2.5, kind = "holyStrike" },
        { t = 3, kind = "commandProc" },
        { t = 4, kind = "seal", seal = "righteousness" },
      }, record.timeline)
    end)

    it("stops growing after 300 entries", function()
      local f = fight({ t = 0 })
      for i = 1, 400 do Fight.cast(f, i * 0.1, 100) end
      local record = Fight.finish(f, { t = 60, time = 5000 })

      assert.are.equal(300, #record.timeline)
      assert.are.equal(400, record.counts.judgement)
    end)
  end)

  it("keeps the opening seal and the context in the record", function()
    local f = Fight.start(catalog, { t = 0, seal = "command", sealExpires = 30, echoes = { command = 3 } },
      { content = "dungeon", playerLevel = 41, weaponSpeed = 2.4,
        target = { creatureType = 6, classification = "elite", level = 39 } })
    local record = Fight.finish(f, { t = 20, time = 5000 })

    assert.are.equal("command", record.openingSeal)
    assert.are.same({ command = 3 }, record.openingEchoes)
    assert.are.equal(5000, record.time)
    assert.are.equal("dungeon", record.context.content)
    assert.are.equal(2.4, record.context.weaponSpeed)
    assert.are.equal("elite", record.context.target.classification)
  end)
end)
