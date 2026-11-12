describe("Food", function()
  local Food

  before_each(function()
    Food = Addon.load({ "core/Food.lua" }).Core.Food
  end)

  local catalog = {
    { name = "Low", minLevel = 1, skill = 100 },
    { name = "Mid A", minLevel = 35, skill = 225 },
    { name = "Mid B", minLevel = 35, skill = 225 },
    { name = "High", minLevel = 45, skill = 275, oven = true },
  }

  local function names(list)
    local out = {}
    for _, item in ipairs(list) do out[#out + 1] = item.name end
    return out
  end

  it("gives the best foods for your level and the ones coming next", function()
    local plan = Food.forPlayer(catalog, 42, nil)
    assert.are.same({ "Mid A", "Mid B" }, names(plan.now))
    assert.are.same({ "High" }, names(plan.next))
    assert.are.equal(45, plan.nextLevel)
  end)

  it("says whether your Cooking is high enough for each recipe", function()
    local plan = Food.forPlayer(catalog, 46, { skill = 260, max = 300 })
    assert.are.same({ "High" }, names(plan.now))
    assert.is_false(plan.now[1].canCook)
    assert.are.equal(15, plan.now[1].skillMissing)
    plan = Food.forPlayer(catalog, 40, { skill = 260, max = 300 })
    assert.is_true(plan.now[1].canCook)
  end)

  it("works at max tier and without Cooking", function()
    local plan = Food.forPlayer(catalog, 60, nil)
    assert.are.same({ "High" }, names(plan.now))
    assert.are.same({}, plan.next)
    assert.is_nil(plan.now[1].canCook)
  end)
end)

describe("Sustain", function()
  local Sustain

  before_each(function()
    Sustain = Addon.load({ "core/Sustain.lua" }).Core.Sustain
  end)

  local function fights(drank, ate, n)
    local out = {}
    for i = 1, n do out[i] = { duration = 20, drankAfter = i <= drank or nil, ateAfter = i <= ate or nil } end
    return out
  end

  it("suggests Wisdom if you drink after most fights, Light if you eat", function()
    assert.are.equal("WISDOM", Sustain.advice(fights(6, 1, 10)).key)
    assert.are.equal("LIGHT", Sustain.advice(fights(1, 6, 10)).key)
    assert.are.equal("BOTH", Sustain.advice(fights(6, 6, 10)).key)
  end)

  it("stays quiet if you rarely rest, or with too few fights", function()
    assert.is_nil(Sustain.advice(fights(2, 2, 10)).key)
    assert.is_nil(Sustain.advice(fights(4, 4, 4)).key)
  end)

  it("only looks at the last 10 fights", function()
    local list = fights(0, 0, 10)
    for i = 1, 10 do table.insert(list, 1, { duration = 20, drankAfter = true }) end -- 10 antiguas bebiendo
    local a = Sustain.advice(list)
    assert.are.equal(0, a.drank)
    assert.are.equal(10, a.fights)
  end)
end)
