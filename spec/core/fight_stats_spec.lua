describe("FightStats.summarize", function()
  local FightStats

  before_each(function()
    FightStats = Addon.load({ "core/FightStats.lua" }).Core.FightStats
  end)

  local function record(opening, duration, sealSeconds, counts, test)
    return {
      openingSeal = opening,
      duration = duration,
      sealSeconds = sealSeconds or {},
      counts = counts or { judgement = 0, holyStrike = 0, commandProc = 0, sealCast = 0 },
      context = { test = test },
    }
  end

  local function counts(judgement, holyStrike, commandProc, sealCast)
    return { judgement = judgement, holyStrike = holyStrike, commandProc = commandProc, sealCast = sealCast }
  end

  describe("by style", function()
    it("groups fights by the style the given classifier returns", function()
      local classify = function(fight) return fight.openingSeal == "command" and "solo:command" or "other" end
      local s = FightStats.summarize({
        record("command", 20, { command = 20 }, counts(2, 3, 2, 0)),
        record("command", 40, { command = 40 }, counts(4, 5, 4, 0)),
        record("righteousness", 30, { righteousness = 30 }, counts(3, 3, 0, 0)),
      }, classify)

      assert.are.same({
        fights = 2, avgDuration = 30, avgJudgements = 3, avgHolyStrikes = 4, avgSealCasts = 0,
        command = { procs = 6, seconds = 60, perMinute = 6 },
      }, s.byStyle["solo:command"])
      assert.are.equal(1, s.byStyle.other.fights)
    end)

    it("has no style groups without a classifier", function()
      assert.are.same({}, FightStats.summarize({ record("command", 20) }).byStyle)
    end)
  end)

  describe("by test", function()
    it("groups tagged fights by test, each with its own Command rate", function()
      local s = FightStats.summarize({
        record("command", 20, { command = 20 }, counts(2, 3, 2, 0), "A"),
        record("command", 30, { command = 30 }, counts(3, 4, 3, 0), "A"),
        record("command", 24, { command = 18, righteousness = 6 }, counts(2, 3, 5, 4), "C"),
        record("command", 40, { command = 40 }, counts(4, 5, 4, 0)), -- sin prueba
      })

      assert.are.same({
        fights = 2, avgDuration = 25, avgJudgements = 2.5, avgHolyStrikes = 3.5, avgSealCasts = 0,
        command = { procs = 5, seconds = 50, perMinute = 6 },
      }, s.byTest.A)
      assert.are.same({
        fights = 1, avgDuration = 24, avgJudgements = 2, avgHolyStrikes = 3, avgSealCasts = 4,
        command = { procs = 5, seconds = 18, perMinute = 16.7 },
      }, s.byTest.C)
      assert.is_nil(s.byTest.none)
      assert.are.equal(4, s.fights)
    end)

    it("has no test groups when no fight is tagged", function()
      local s = FightStats.summarize({ record("command", 20, { command = 20 }) })

      assert.are.same({}, s.byTest)
    end)

    it("copes with old records saved without context", function()
      local old = record("command", 20, { command = 20 })
      old.context = nil

      local s = FightStats.summarize({ old })

      assert.are.same({}, s.byTest)
      assert.are.equal(1, s.fights)
    end)
  end)

  it("is empty without fights", function()
    local s = FightStats.summarize({})

    assert.are.equal(0, s.fights)
    assert.are.same({}, s.byOpeningSeal)
    assert.are.same({}, s.byTest)
    assert.is_nil(s.command)
  end)

  it("groups fights by opening seal with average duration and judgements", function()
    local s = FightStats.summarize({
      record("command", 10, {}, { judgement = 1, holyStrike = 0, commandProc = 0, sealCast = 0 }),
      record("command", 20, {}, { judgement = 3, holyStrike = 0, commandProc = 0, sealCast = 0 }),
      record("righteousness", 12),
      record(nil, 6),
    })

    assert.are.equal(4, s.fights)
    assert.are.same({ fights = 2, avgDuration = 15, avgJudgements = 2 }, s.byOpeningSeal.command)
    assert.are.same({ fights = 1, avgDuration = 12, avgJudgements = 0 }, s.byOpeningSeal.righteousness)
    assert.are.same({ fights = 1, avgDuration = 6, avgJudgements = 0 }, s.byOpeningSeal.none)
  end)

  it("estimates Command procs per minute over the time Command was active", function()
    local s = FightStats.summarize({
      record("command", 30, { command = 30 }, { judgement = 0, holyStrike = 0, commandProc = 3, sealCast = 0 }),
      record("crusader", 40, { crusader = 10, command = 30 }, { judgement = 0, holyStrike = 0, commandProc = 4, sealCast = 1 }),
    })

    assert.are.same({ procs = 7, seconds = 60, perMinute = 7 }, s.command)
  end)

  it("gives no Command rate when Command was never active", function()
    local s = FightStats.summarize({ record("righteousness", 30, { righteousness = 30 }) })

    assert.is_nil(s.command)
  end)

  it("rounds averages to one decimal", function()
    local s = FightStats.summarize({
      record("command", 10, { command = 9 }, { judgement = 1, holyStrike = 0, commandProc = 1, sealCast = 0 }),
      record("command", 11, { command = 10 }, { judgement = 2, holyStrike = 0, commandProc = 1, sealCast = 0 }),
      record("command", 11, { command = 10 }, { judgement = 2, holyStrike = 0, commandProc = 1, sealCast = 0 }),
    })

    assert.are.equal(10.7, s.byOpeningSeal.command.avgDuration)
    assert.are.equal(1.7, s.byOpeningSeal.command.avgJudgements)
    assert.are.equal(6.2, s.command.perMinute) -- 3 procs en 29 s
  end)
end)
