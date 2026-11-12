describe("Report.build", function()
  local Report

  before_each(function()
    Report = Addon.load({ "core/Report.lua" }).Core.Report
  end)

  local function info(overrides)
    local i = {
      addonVersion = "0.9.0", client = { version = "1.60.1", build = "70888", toc = 16001 }, locale = "enUS",
      language = "esES", level = 42, spec = "retribution", specSource = "specialization",
      weaponSpeed = 3.4, spellPower = 70,
      ranks = { command = { 20375, 20918 }, righteousness = { 21084, 20290 } },
      settings = { advisor = true, echo = true, macros = false, chatSummary = false, devMode = false },
      fightCount = 94, commandPerMinute = 3.7,
      lastFight = "Solo Seal of Command | 20 s",
      errors = { { time = 1794416000, context = "la recomendación", message = "boom" } },
      date = function() return "2026-11-12 10:00" end,
    }
    for k, v in pairs(overrides or {}) do i[k] = v end
    return i
  end

  it("summarises the setup, the data and the latest errors in plain text", function()
    local text = Report.build(info())

    assert.truthy(text:find("Paladin for Dummies 0.9.0 | client 1.60.1 (70888, toc 16001) | locale enUS, language esES", 1, true))
    assert.truthy(text:find("Level 42, spec retribution (specialization), weapon 3.4 s, spell power 70", 1, true))
    assert.truthy(text:find("command: 20375, 20918", 1, true))
    assert.truthy(text:find("righteousness: 21084, 20290", 1, true))
    assert.truthy(text:find("advisor=on echo=on macros=off chatSummary=off devMode=off", 1, true))
    assert.truthy(text:find("Fights: 94 | Seal of Command: 3.7 procs/min", 1, true))
    assert.truthy(text:find("Last fight: Solo Seal of Command | 20 s", 1, true))
    assert.truthy(text:find("2026-11-12 10:00 | la recomendación | boom", 1, true))
  end)

  it("says so when there are no errors or fights", function()
    local text = Report.build(info({ errors = {}, fightCount = 0, commandPerMinute = nil, lastFight = nil }))

    assert.truthy(text:find("Errors: none", 1, true))
    assert.truthy(text:find("Fights: 0", 1, true))
  end)

  it("keeps only the last 10 errors", function()
    local errors = {}
    for i = 1, 15 do errors[i] = { time = i, context = "c", message = "error " .. i } end
    local text = Report.build(info({ errors = errors }))

    assert.is_nil(text:find("error 5\n", 1, true))
    assert.truthy(text:find("error 6", 1, true))
    assert.truthy(text:find("error 15", 1, true))
  end)
end)
