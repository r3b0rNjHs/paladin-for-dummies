describe("Locales", function()
  local ns

  before_each(function()
    ns = Addon.load({ "Locales/Locales.lua" })
    ns.Locales.register("enUS", { HELLO = "Hello", ONLY_EN = "Only English" })
    ns.Locales.register("esES", { HELLO = "Hola" })
  end)

  it("follows the client language when the setting is automatic", function()
    assert.are.equal("esES", ns.Locales.resolve("auto", "esES"))
    assert.are.equal("enUS", ns.Locales.resolve("auto", "enUS"))
  end)

  it("uses Spanish (Spain) for Mexican Spanish clients", function()
    assert.are.equal("esES", ns.Locales.resolve("auto", "esMX"))
  end)

  it("lets the player force a language whatever the client", function()
    assert.are.equal("esES", ns.Locales.resolve("esES", "enUS"))
    assert.are.equal("enUS", ns.Locales.resolve("enUS", "esES"))
  end)

  it("falls back to English for languages without a translation", function()
    assert.are.equal("enUS", ns.Locales.resolve("auto", "deDE"))
  end)

  it("translates, falling back to English and then to the key itself", function()
    ns.Locales.use("esES")
    assert.are.equal("Hola", ns.L.HELLO)
    assert.are.equal("Only English", ns.L.ONLY_EN)
    assert.are.equal("MISSING_KEY", ns.L.MISSING_KEY)
  end)
end)

describe("Locales tone", function()
  local ns

  before_each(function()
    ns = Addon.load({ "Locales/Locales.lua" })
    ns.Locales.register("enUS", { HELLO = "Hello", HELLO_FUN = "Ahoy, holy one", ONLY_EN = "Plain" })
    ns.Locales.register("esES", { HELLO = "Hola", ONLY_EN = "Solo", ONLY_EN_FUN = "Solo, con gracia" })
  end)

  it("uses the funny variant of a text when the tone is fun", function()
    ns.Locales.use("enUS")
    ns.Locales.setTone("fun")
    assert.are.equal("Ahoy, holy one", ns.L.HELLO)
  end)

  it("never mixes languages for a joke: no Spanish joke means the plain Spanish text", function()
    ns.Locales.use("esES")
    ns.Locales.setTone("fun")
    assert.are.equal("Hola", ns.L.HELLO)
    assert.are.equal("Solo, con gracia", ns.L.ONLY_EN)
  end)

  it("keeps it serious when the player asks", function()
    ns.Locales.use("enUS")
    ns.Locales.setTone("plain")
    assert.are.equal("Hello", ns.L.HELLO)
  end)
end)

describe("Locale files", function()
  it("Spanish translates every English key and nothing else", function()
    local ns = Addon.load({ "Locales/Locales.lua", "Locales/enUS.lua", "Locales/esES.lua" })
    local en, es = ns.Locales.tables.enUS, ns.Locales.tables.esES
    for key in pairs(en) do assert.is_string(es[key], "falta en esES: " .. key) end
    for key in pairs(es) do assert.is_string(en[key], "sobra en esES: " .. key) end
  end)
end)

describe("Rule reasons", function()
  it("every rule explains itself in English and Spanish (WHY_<id>)", function()
    local ns = Addon.load({ "Locales/Locales.lua", "Locales/enUS.lua", "Locales/esES.lua", "data/Rules.lua" })
    for _, rule in ipairs(ns.Data.Rules) do
      local key = ns.Locales.whyKey(rule.id)
      assert.is_string(ns.Locales.tables.enUS[key], "falta en enUS: " .. key)
      assert.is_string(ns.Locales.tables.esES[key], "falta en esES: " .. key)
    end
  end)
end)
