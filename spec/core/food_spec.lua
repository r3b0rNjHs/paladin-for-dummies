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
