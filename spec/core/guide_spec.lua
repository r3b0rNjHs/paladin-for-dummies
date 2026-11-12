describe("Guide", function()
  local Guide

  before_each(function()
    Guide = Addon.load({ "core/Guide.lua" }).Core.Guide
  end)

  describe("fill", function()
    it("puts the client's spell names in place of the tokens", function()
      local names = { COMMAND = "Sello de orden", JUDGEMENT = "Sentencia" }
      local text = Guide.fill("Ponte {COMMAND} y lanza {JUDGEMENT}.", function(token) return names[token] end)
      assert.are.equal("Ponte |cfff2c14eSello de orden|r y lanza |cfff2c14eSentencia|r.", text)
    end)

    it("leaves unknown tokens readable instead of breaking", function()
      assert.are.equal("Ponte NOPE.", Guide.fill("Ponte {NOPE}.", function() return nil end))
    end)
  end)

  describe("plan", function()
    local function keys(plan)
      local out = {}
      for _, step in ipairs(plan.steps) do out[#out + 1] = step.key end
      return out
    end

    it("a brand-new paladin: one seal, Judgement, keep the seal up", function()
      local plan = Guide.plan({ level = 3, known = { righteousness = true } })
      assert.are.same({ "H_BEFORE", "SEAL_ONLY", "H_DURING", "JUDGE", "REFRESH", "H_NEXT", "NEXT_CRUSADER", "NEXT_STRIKE" }, keys(plan))
      assert.are.equal("RIGHTEOUSNESS", plan.damageSeal)
    end)

    it("with Crusader: judge it before the pull and switch to the damage seal", function()
      local plan = Guide.plan({ level = 12, known = { righteousness = true, crusader = true, holyStrike = true } })
      assert.are.same({ "H_BEFORE", "PREPULL_1", "PREPULL_2", "PREPULL_3", "H_DURING", "JUDGE", "STRIKE", "REFRESH", "H_NEXT", "NEXT_COMMAND" }, keys(plan))
      assert.are.equal("RIGHTEOUSNESS", plan.damageSeal)
    end)

    it("with Command: it becomes the damage seal and Unsealed Wrath appears", function()
      local plan = Guide.plan({ level = 41, known = { righteousness = true, crusader = true, holyStrike = true, command = true } })
      assert.are.same({ "H_BEFORE", "PREPULL_1", "PREPULL_2", "PREPULL_3", "H_DURING", "JUDGE", "STRIKE", "UNSEALED", "REFRESH" }, keys(plan))
      assert.are.equal("COMMAND", plan.damageSeal)
    end)

    it("each step carries the icon of the spell it talks about", function()
      local plan = Guide.plan({ level = 41, known = { righteousness = true, crusader = true, holyStrike = true, command = true } })
      local icons = {}
      for _, step in ipairs(plan.steps) do icons[step.key] = step.icon end
      assert.are.equal("CRUSADER", icons.PREPULL_1)
      assert.are.equal("JUDGEMENT", icons.PREPULL_2)
      assert.are.equal("COMMAND", icons.PREPULL_3)
      assert.are.equal("HOLY_STRIKE", icons.STRIKE)
    end)
  end)

  describe("usage", function()
    it("tells how many of the possible Judgements you used (8 s cooldown, 1 at the start)", function()
      local fights = {
        { duration = 40, counts = { judgement = 3, holyStrike = 2 } }, -- podías 6 y 5
        { duration = 16, counts = { judgement = 3, holyStrike = 1 } }, -- podías 3 y 2
      }
      local u = Guide.usage(fights)
      assert.are.equal(9, u.judgement.possible)
      assert.are.equal(6, u.judgement.used)
      assert.are.equal(7, u.holyStrike.possible)
      assert.are.equal(3, u.holyStrike.used)
    end)

    it("ignores fights too short to matter", function()
      local u = Guide.usage({ { duration = 2, counts = { judgement = 0, holyStrike = 0 } } })
      assert.are.equal(0, u.judgement.possible)
      assert.are.equal(0, u.fights)
    end)
  end)
end)
