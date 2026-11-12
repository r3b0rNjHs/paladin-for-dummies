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

  it("starts with the basics and has the player's own numbers", function()
    assert.are.equal("START", ns.Data.Guide[1].id)
    local found = false
    for _, chapter in ipairs(ns.Data.Guide) do
      for _, block in ipairs(chapter.blocks) do if block.numbers then found = true end end
    end
    assert.is_true(found)
  end)
end)
