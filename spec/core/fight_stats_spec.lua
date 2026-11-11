describe("FightStats.summarize", function()
  local FightStats

  before_each(function()
    FightStats = Addon.load({ "core/FightStats.lua" }).Core.FightStats
  end)

  local function record(opening, duration, sealSeconds, counts)
    return {
      openingSeal = opening,
      duration = duration,
      sealSeconds = sealSeconds or {},
      counts = counts or { judgement = 0, holyStrike = 0, commandProc = 0, sealCast = 0 },
    }
  end

  it("is empty without fights", function()
    local s = FightStats.summarize({})

    assert.are.equal(0, s.fights)
    assert.are.same({}, s.byOpeningSeal)
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
