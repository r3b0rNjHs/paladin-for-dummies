describe("MacroWriter.write", function()
  local MacroWriter

  before_each(function()
    MacroWriter = Addon.load({ "adapters/MacroWriter.lua" }).Adapters.MacroWriter
  end)

  -- API de macros falsa: guarda las macros de personaje en una tabla.
  local function fakeApi(existing, inCombat)
    local macros, calls = {}, {}
    for name, body in pairs(existing or {}) do macros[#macros + 1] = { name = name, body = body } end
    local api = {
      MAX_CHARACTER_MACROS = 18,
      InCombatLockdown = function() return inCombat or false end,
      GetNumMacros = function() return 0, #macros end,
      GetMacroIndexByName = function(name)
        for i, m in ipairs(macros) do if m.name == name then return 120 + i end end
        return 0
      end,
      GetMacroBody = function(index) return macros[index - 120].body end,
      CreateMacro = function(name, icon, body, perCharacter)
        calls[#calls + 1] = { "create", name, icon, body, perCharacter }
        macros[#macros + 1] = { name = name, body = body }
        return 120 + #macros
      end,
      EditMacro = function(index, name, icon, body)
        calls[#calls + 1] = { "edit", index, name, icon, body }
        macros[index - 120].body = body
        return index
      end,
    }
    return api, macros, calls
  end

  local wanted = {
    { name = "PFD Apertura", body = "#showtooltip\n/cast A" },
    { name = "PFD Sello", body = "#showtooltip\n/cast B" },
  }

  it("creates missing macros as per-character macros with the question mark icon", function()
    local api, macros, calls = fakeApi()

    local results = MacroWriter.write(api, wanted)

    assert.are.same({ { name = "PFD Apertura", action = "created" }, { name = "PFD Sello", action = "created" } }, results)
    assert.are.same({ "create", "PFD Apertura", 134400, "#showtooltip\n/cast A", true }, calls[1])
    assert.are.equal(2, #macros)
  end)

  it("edits only the body of macros that changed and leaves the rest alone", function()
    local api, _, calls = fakeApi({ ["PFD Apertura"] = "old", ["PFD Sello"] = "#showtooltip\n/cast B" })

    local results = MacroWriter.write(api, wanted)

    assert.are.same({ { name = "PFD Apertura", action = "updated" }, { name = "PFD Sello", action = "unchanged" } }, results)
    assert.are.equal(1, #calls)
    assert.are.equal("edit", calls[1][1])
    assert.is_nil(calls[1][3]) -- el nombre no se toca
    assert.is_nil(calls[1][4]) -- el icono no se toca
  end)

  it("does nothing in combat (macros are protected)", function()
    local api, _, calls = fakeApi(nil, true)

    local results, reason = MacroWriter.write(api, wanted)

    assert.is_nil(results)
    assert.are.equal("combat", reason)
    assert.are.same({}, calls)
  end)

  it("reports when there is no free character macro slot", function()
    local api = fakeApi()
    api.GetNumMacros = function() return 0, 18 end

    local results = MacroWriter.write(api, { wanted[1] })

    assert.are.same({ { name = "PFD Apertura", action = "full" } }, results)
  end)

  it("reports errors from the macro API instead of throwing", function()
    local api = fakeApi()
    api.CreateMacro = function() error("boom") end

    local results = MacroWriter.write(api, { wanted[1] })

    assert.are.equal("error", results[1].action)
    assert.truthy(results[1].error:find("boom", 1, true))
  end)
end)
