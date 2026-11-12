describe("Coach", function()
  local Coach

  before_each(function()
    Coach = Addon.load({ "core/Guide.lua", "core/Coach.lua" }).Core.Coach
  end)

  local function fight(duration, judgement, holyStrike, sealSeconds)
    return { duration = duration, counts = { judgement = judgement, holyStrike = holyStrike },
      sealSeconds = { command = sealSeconds or duration } }
  end

  describe("fightTip", function()
    it("stays quiet after a good fight or a very short one", function()
      assert.is_nil(Coach.fightTip(fight(40, 6, 5), { holyStrike = true }))
      assert.is_nil(Coach.fightTip(fight(8, 0, 0), { holyStrike = true }))
    end)

    it("points out the biggest miss first: fighting without a seal", function()
      local tip = Coach.fightTip(fight(40, 2, 1, 10), { holyStrike = true })
      assert.are.equal("NO_SEAL", tip.key)
      assert.are.equal(30, tip.value) -- segundos sin sello
    end)

    it("then Judgements left unused (8 s cooldown)", function()
      local tip = Coach.fightTip(fight(40, 3, 5), { holyStrike = true })
      assert.are.equal("JUDGE", tip.key)
      assert.are.equal(3, tip.value) -- podías 6
    end)

    it("then Holy Strike, only if you know it", function()
      local tip = Coach.fightTip(fight(40, 6, 2), { holyStrike = true })
      assert.are.equal("STRIKE", tip.key)
      assert.are.equal(3, tip.value) -- podías 5
      assert.is_nil(Coach.fightTip(fight(40, 6, 0), { holyStrike = false }))
    end)
  end)

  describe("session", function()
    it("sums up the session out of 10, and compares with the previous one", function()
      local fights = { fight(40, 6, 5), fight(40, 3, 2) } -- 9 de 12 y 7 de 10
      local s = Coach.session(fights, { judgement = 5, holyStrike = 8 })
      assert.are.equal(2, s.fights)
      assert.are.equal(8, s.judgement)  -- 9/12 = 7,5 → 8
      assert.are.equal(7, s.holyStrike) -- 7/10
      assert.are.equal(3, s.judgementChange)
      assert.are.equal(-1, s.holyStrikeChange)
    end)

    it("says nothing for an empty session", function()
      assert.is_nil(Coach.session({}, nil))
    end)
  end)
end)
