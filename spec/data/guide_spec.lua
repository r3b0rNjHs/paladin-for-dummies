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
      end
      for _, key in ipairs(keys) do
        assert.is_string(ns.Locales.tables.enUS[key], "falta en enUS: " .. key)
        assert.is_string(ns.Locales.tables.esES[key], "falta en esES: " .. key)
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
