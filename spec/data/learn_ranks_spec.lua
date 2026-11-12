describe("Data.LearnRanks", function()
  local ns

  before_each(function()
    ns = Addon.load({ "data/Seals.lua", "data/MacroSpells.lua" })
  end)

  it("adds discovered ranks after the known ones, so the highest rank is last", function()
    ns.Data.LearnRanks({ righteousness = { 21084, 20290 } })

    assert.are.same({ 21084, 20290 }, ns.Data.Seals.righteousness.spellIds)
  end)

  it("keeps listed ranks that were not found, in front (they are not known anyway)", function()
    ns.Data.LearnRanks({ ["macro:layOnHands"] = { 2800 } })

    assert.are.same({ 633, 2800 }, ns.Data.MacroSpells.layOnHands.spellIds)
  end)

  it("rebuilds the fight catalog so casts of the new ranks are recognised", function()
    local catalog = ns.Data.Catalog
    ns.Data.LearnRanks({ righteousness = { 21084, 20290 }, ["spell:holyStrike"] = { 2495, 10333 } })

    assert.are.equal(catalog, ns.Data.Catalog) -- misma tabla: quien la guardó ve los cambios
    assert.are.equal("righteousness", catalog.sealBySpellId[20290])
    assert.is_true(catalog.holyStrike[10333])
  end)

  it("ignores groups it does not track", function()
    ns.Data.LearnRanks({ nonsense = { 1 } })

    assert.is_nil(ns.Data.TrackedSpells.nonsense)
  end)
end)
