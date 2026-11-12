describe("Guide", function()
  local ns

  before_each(function()
    ns = Addon.load({ "Locales/Locales.lua", "Locales/enUS.lua", "Locales/esES.lua", "data/Seals.lua", "data/Guide.lua" })
  end)

  it("has every title and text in English and Spanish", function()
    for _, chapter in ipairs(ns.Data.Guide) do
      local keys = { "GUIDE_" .. chapter.id .. "_TITLE" }
      for _, block in ipairs(chapter.blocks) do
        if block.text then keys[#keys + 1] = "GUIDE_" .. block.text end
        if block.header then keys[#keys + 1] = "GUIDE_" .. block.header end
      end
      for _, key in ipairs(keys) do
        assert.is_string(ns.Locales.tables.enUS[key], "falta en enUS: " .. key)
        assert.is_string(ns.Locales.tables.esES[key], "falta en esES: " .. key)
      end
    end
  end)

  it("has text for every step Tu plan can show, at any level", function()
    local Guide = Addon.load({ "core/Guide.lua" }).Core.Guide
    local cases = {
      { righteousness = true },
      { righteousness = true, crusader = true },
      { righteousness = true, crusader = true, holyStrike = true },
      { righteousness = true, crusader = true, holyStrike = true, command = true },
    }
    for _, known in ipairs(cases) do
      for _, step in ipairs(Guide.plan({ level = 10, known = known }).steps) do
        for _, lang in ipairs({ "enUS", "esES" }) do
          assert.is_string(ns.Locales.tables[lang]["GUIDE_PLAN_" .. step.key], step.key .. " " .. lang)
        end
      end
    end
  end)

  it("keeps blocks short enough to read comfortably", function()
    for _, chapter in ipairs(ns.Data.Guide) do
      for _, block in ipairs(chapter.blocks) do
        if block.text and block.text ~= "GLOSSARY_TEXT" then
          for _, lang in ipairs({ "enUS", "esES" }) do
            local text = ns.Locales.tables[lang]["GUIDE_" .. block.text]:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", "")
            assert.is_true(#text <= 420, ("%s (%s) es muy largo: %d"):format(block.text, lang, #text))
          end
        end
      end
    end
  end)

  it("starts with what to do (Tu plan) and has the player's own fights", function()
    assert.are.equal("PLAN", ns.Data.Guide[1].id)
    assert.is_true(ns.Data.Guide[1].blocks[1].plan)
    local found = false
    for _, chapter in ipairs(ns.Data.Guide) do
      for _, block in ipairs(chapter.blocks) do if block.fights then found = true end end
    end
    assert.is_true(found)
  end)

  it("uses spell tokens that exist, with a fallback name for spells without a spellID", function()
    local Guide = Addon.load({ "core/Guide.lua" }).Core.Guide
    for _, chapter in ipairs(ns.Data.Guide) do
      for _, block in ipairs(chapter.blocks) do
        if type(block.icon) == "string" and not block.icon:find("\\") then
          assert.is_not_nil(ns.Data.GuideSpells[block.icon] ~= nil or ns.Locales.tables.enUS["SPELL_" .. block.icon], block.icon)
        end
        if block.text then
          for _, lang in ipairs({ "enUS", "esES" }) do
            Guide.fill(ns.Locales.tables[lang]["GUIDE_" .. block.text], function(token)
              local known = ns.Data.GuideSpells[token] or ns.Locales.tables[lang]["SPELL_" .. token]
              assert.is_truthy(known, ("marca {%s} sin hechizo ni nombre (%s, %s)"):format(token, block.text, lang))
              return "x"
            end)
          end
        end
      end
    end
  end)
end)

describe("Macro catalog", function()
  it("describes every macro the addon can create, in both languages", function()
    local ns = Addon.load({ "Locales/Locales.lua", "Locales/enUS.lua", "Locales/esES.lua", "data/Seals.lua",
      "data/Guide.lua", "data/MacroSpells.lua", "core/Macros.lua" })
    local described = {}
    for _, info in ipairs(ns.Data.MacroInfo) do
      described[info.name] = true
      assert.is_not_nil(ns.Data.GuideSpells[info.icon], info.icon)
      for _, lang in ipairs({ "enUS", "esES" }) do
        assert.is_string(ns.Locales.tables[lang]["MACRO_DESC_" .. info.key], info.key .. " " .. lang)
        assert.is_string(ns.Locales.tables[lang]["MACRO_GROUP_" .. info.group], info.group .. " " .. lang)
      end
    end
    for _, name in ipairs(ns.Core.Macros.ALL_NAMES) do assert.is_true(described[name], name) end
  end)
end)
