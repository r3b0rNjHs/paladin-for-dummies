-- Prueba de humo: carga el addon entero en el orden del .toc con un WoW simulado,
-- dispara los eventos principales y los comandos. No prueba la interfaz de verdad
-- (eso solo se puede en el juego); detecta errores de carga, nombres mal escritos
-- y archivos en mal orden. Usa LibStub, CallbackHandler y AceDB de verdad (son Lua
-- puro); AceConfig, AceDBOptions y AceGUI, que dibujan ventanas, van simulados.
describe("PaladinForDummies.toc", function()
  local ROOT = "addons/PaladinForDummies/"
  local CHAR = "Tester - Realm"

  local function tocFiles()
    local files = {}
    for line in io.lines(ROOT .. "PaladinForDummies.toc") do
      line = line:gsub("%s+$", "")
      if line:match("%.lua$") then files[#files + 1] = (line:gsub("\\", "/")) end
    end
    return files
  end

  -- Objeto que acepta cualquier método (en WoW empiezan por mayúscula) y guarda los
  -- scripts para poder disparar eventos. Los campos en minúscula que no existen son
  -- nil, como en un frame de verdad.
  local function mock()
    local scripts = {}
    local obj = { scripts = scripts }
    return setmetatable(obj, {
      __index = function(_, key)
        if type(key) ~= "string" or not key:match("^%u") then return nil end
        if key == "SetScript" then
          return function(_, name, fn) scripts[name] = fn end
        end
        if key == "GetFrameLevel" then return function() return 1 end end
        return function() return mock() end
      end,
    })
  end

  local env_now = 1000

  local function wowEnv(class)
    local frames, printed, createdMacros, errors, opened = {}, {}, {}, {}, {}
    local env
    env = setmetatable({
      print = function(...)
        local parts = {}
        for i = 1, select("#", ...) do parts[#parts + 1] = tostring((select(i, ...))) end
        printed[#printed + 1] = table.concat(parts, " ")
      end,
      CreateFrame = function() local f = mock(); frames[#frames + 1] = f; return f end,
      UIParent = mock(),
      GameTooltip = mock(),
      SlashCmdList = {},
      InCombatLockdown = function() return false end,
      issecretvalue = function() return false end,
      securecallfunction = function(fn, ...) return fn(...) end,
      wipe = function(t) for k in pairs(t) do t[k] = nil end return t end,
      date = os.date,
      geterrorhandler = function() return function(message) errors[#errors + 1] = message end end,
      -- Lo que AceDB lee al cargarse para saber de quién son los datos
      UnitClass = function() return "Paladin", class or "PALADIN" end,
      UnitRace = function() return "Human", "Human" end,
      UnitFactionGroup = function() return "Alliance" end,
      UnitNameUnmodified = function() return "Tester" end,
      GetRealmName = function() return "Realm" end,
      GetCurrentRegion = function() return 3 end,
      GetCurrentRegionName = function() return "EU" end,
      GetLocale = function() return "enUS" end,
      -- Juego
      UnitLevel = function() return 40 end,
      UnitExists = function() return true end,
      UnitCanAttack = function() return true end,
      UnitCreatureType = function() return "Undead", 6 end,
      UnitClassification = function() return "normal" end,
      IsInInstance = function() return false, "none" end,
      IsInGroup = function() return false end,
      Settings = { OpenToCategory = function(id) opened[#opened + 1] = id end },
      C_Spell = {
        GetSpellTexture = function() return 135000 end,
        GetSpellName = function(id)
          return ({ [20918] = "Seal of Command", [20375] = "Seal of Command", [20306] = "Seal of the Crusader",
            [21084] = "Seal of Righteousness", [20271] = "Judgement", [679] = "Holy Strike", [19705] = "Well Fed", [430] = "Drink", [433] = "Food" })[id]
        end,
      },
      MAX_CHARACTER_MACROS = 18,
      GetNumMacros = function() return 0, 0 end,
      GetMacroIndexByName = function() return 0 end,
      CreateMacro = function(name, _, body)
        createdMacros[name] = body
        return 121
      end,
      createdMacros = createdMacros,
      GetTime = function() return env_now end,
      time = function() return 1794416000 end,
      GetBuildInfo = function() return "1.60.1", "70888", "Nov  9 2026", 16001 end,
      C_AddOns = { GetAddOnMetadata = function(_, field) return field == "Version" and "0.9.0" or nil end },
      UnitAttackSpeed = function() return 2.4000000953674 end,
      UnitDamage = function() return 110.35113525391, 160 end,
      GetSpellBonusDamage = function() return 35 end,
      C_UnitAuras = {
        GetAuraDataByIndex = function(_, i)
          return ({
            { spellId = 20918, expirationTime = 1025, applications = 0 },  -- Seal of Command
            { spellId = 1311703, expirationTime = 1010, applications = 3 }, -- Echo of Command
          })[i]
        end,
      },
      C_SpellBook = {
        GetNumSpellBookSkillLines = function() return 1 end,
        GetSpellBookSkillLineInfo = function() return { itemIndexOffset = 0, numSpellBookItems = 2 } end,
        GetSpellBookItemInfo = function(i) return { spellID = ({ 20918, 20306 })[i] } end,
      },
    }, { __index = _G })
    env._G = env
    return env, { frames = frames, printed = printed, errors = errors, opened = opened }
  end

  local function run(env, path)
    local chunk = assert(loadfile(path))
    setfenv(chunk, env)
    return chunk("PaladinForDummies", env.__ns)
  end

  -- Ace3 simulado: guarda la tabla de opciones y el texto de las ventanas.
  local function fakeAce(env, seen)
    local LibStub = env.LibStub
    local registry = LibStub:NewLibrary("AceConfigRegistry-3.0", 1)
    function registry:RegisterOptionsTable(app, options) seen.options[app] = options end
    function registry:NotifyChange() end
    local dialog = LibStub:NewLibrary("AceConfigDialog-3.0", 1)
    function dialog:AddToBlizOptions(app) return mock(), app == "PaladinForDummies" and 42 or 43 end
    local dbOptions = LibStub:NewLibrary("AceDBOptions-3.0", 1)
    function dbOptions:GetOptionsTable() return { type = "group", args = {} } end
    local gui = LibStub:NewLibrary("AceGUI-3.0", 1)
    function gui:Create()
      local widget = mock()
      rawset(widget, "SetText", function(_, text) seen.windowText = text end)
      return widget
    end
  end

  local function loadAddon(env)
    env.__ns = {}
    local seen = { options = {} }
    for _, lib in ipairs({ "LibStub/LibStub.lua", "CallbackHandler-1.0/CallbackHandler-1.0.lua", "AceDB-3.0/AceDB-3.0.lua" }) do
      run(env, ROOT .. "Libs/" .. lib)
    end
    fakeAce(env, seen)
    for _, file in ipairs(tocFiles()) do run(env, ROOT .. file) end
    return env.__ns, seen
  end

  local function output(w) return table.concat(w.printed, "\n") end

  it("stays inactive on other classes", function()
    local env, w = wowEnv("WARRIOR")
    local _, seen = loadAddon(env)
    local before = #w.frames
    for _, f in ipairs(w.frames) do if f.scripts.OnEvent then f.scripts.OnEvent(f, "ADDON_LOADED", "PaladinForDummies") end end

    assert.are.equal(before, #w.frames) -- no crea ventanas
    assert.is_nil(env.PaladinForDummiesDB)
    assert.is_nil(seen.options.PaladinForDummies)
    env.SlashCmdList.PALADINFORDUMMIES("")
    assert.truthy(output(w):find("for paladins only", 1, true)) -- con humor por defecto
  end)

  local function fire(w, event, ...)
    for _, f in ipairs(w.frames) do
      local handler = f.scripts.OnEvent
      if handler then handler(f, event, ...) end
    end
  end

  local function start(env, w)
    local ns, seen = loadAddon(env)
    fire(w, "ADDON_LOADED", "PaladinForDummies")
    fire(w, "PLAYER_ENTERING_WORLD")
    local db = env.PaladinForDummiesDB
    return ns, seen, db.profiles.Default, db.char[CHAR]
  end

  it("greets new players once, quietly, with sensible defaults", function()
    local env, w = wowEnv()
    local _, _, profile, char = start(env, w)

    assert.truthy(output(w):find("Welcome, paladin!", 1, true))
    assert.are.equal("fun", profile.tone)       -- con humor por defecto
    assert.is_true(char.welcomed)
    assert.is_false(profile.review.chatSummary) -- sin mensajes en el chat por defecto
    assert.is_false(profile.macros.auto)        -- no toca tus macros si no se lo pides
    assert.is_true(profile.echo.shown)          -- solo se ve si tienes copias de Unsealed Wrath
    assert.are.same({}, w.errors)

    -- Segunda sesión con los mismos datos: sin bienvenida
    local saved = env.PaladinForDummiesDB
    local env2, w2 = wowEnv()
    env2.PaladinForDummiesDB = saved
    start(env2, w2)
    assert.is_nil(output(w2):find("Welcome!", 1, true))
  end)

  it("migrates the old flat saved variables without losing fights or settings", function()
    local env, w = wowEnv()
    local oldFight = { duration = 30, counts = { judgement = 1, holyStrike = 0, commandProc = 1, sealCast = 0 }, sealSeconds = { command = 30 } }
    env.PaladinForDummiesDB = {
      hidden = true, quiet = true, echo = true, macros = true,
      echoPosition = { point = "CENTER", relativePoint = "CENTER", x = 1, y = 150 },
      fights = { oldFight }, snapshot = {}, errors = { { message = "viejo" } },
    }
    local _, _, profile, char = start(env, w)

    assert.is_false(profile.advisor.shown)
    assert.is_true(profile.macros.auto)
    assert.are.equal(150, profile.echo.position.y)
    assert.are.equal(1, #char.fights)
    assert.are.equal(30, char.fights[1].duration)
    assert.is_nil(output(w):find("Welcome!", 1, true))
    assert.is_nil(env.PaladinForDummiesDB.hidden) -- el formato viejo desaparece
  end)

  it("builds the options panel and applies changes right away", function()
    local env, w = wowEnv()
    local ns, seen, profile, char = start(env, w)
    local o = seen.options.PaladinForDummies.args

    o.advisor.args.shown.set(nil, false)
    assert.is_false(profile.advisor.shown)
    o.advisor.args.scale.set(nil, 1.5)
    assert.are.equal(1.5, profile.advisor.scale)
    o.advisor.args.move.func()
    assert.truthy(output(w):find("Alert unlocked", 1, true))
    o.advisor.args.move.func()

    o.echo.args.scale.set(nil, 0.8)
    assert.are.equal(0.8, profile.echo.scale)
    o.echo.args.move.func()
    assert.truthy(output(w):find("Display unlocked", 1, true))

    -- Macros: una casilla por macro; desmarcada no se crea
    assert.truthy(o.macros.args.about1.name():find("PFD Golpe", 1, true))
    assert.truthy(o.macros.args.about1.name():find("|cfff2c14eJudgement|r", 1, true)) -- qué hace, con el nombre del cliente
    assert.are.equal(135000, (o.macros.args.about1.image()))
    assert.are.equal("header", o.macros.args.groupCOMBAT.type)
    assert.are.equal("Create", o.macros.args.macro1.name)
    o.macros.args.macro1.set(nil, false)
    o.macros.args.now.func()
    assert.is_nil(env.createdMacros["PFD Golpe"])
    assert.is_true(profile.macros.auto)

    o.review.args.chat.set(nil, true)
    assert.is_true(profile.review.chatSummary)
    char.fights[1] = { duration = 1 }
    assert.is_true(o.review.args.reset.confirm)
    o.review.args.reset.func()
    assert.are.equal(0, #char.fights)

    o.advanced.args.language.set(nil, "esES")
    assert.are.equal("esES", profile.language)
    o.advanced.args.report.func()
    assert.truthy(seen.windowText:find("Paladin for Dummies 0.9.0", 1, true))

    assert.is_table(seen.options.PaladinForDummies_Profiles)

    -- La guía: capítulos en árbol, Tu plan según lo que sabes, nombres del
    -- cliente, chistes solo con humor y tus peleas.
    local guide = seen.options.PaladinForDummies_Guide
    assert.are.equal("tree", guide.childGroups)
    local plan = guide.args.plan.args
    assert.truthy(plan.planIntro.name():find("level", 1, true))
    assert.truthy(plan.plan1.name():find("Before the fight", 1, true))
    assert.are.equal("large", plan.plan1.fontSize())
    assert.is_false(plan.plan2.hidden())
    assert.is_true(plan.plan16.hidden())
    local help = guide.args.help.args
    assert.truthy(guide.args.basics.args.b4.name():find("|cfff2c14eJudgement|r", 1, true)) -- nombre del cliente
    assert.are.equal(135000, (help.b1.image()))                         -- icono del hechizo
    local joke = help.b7
    assert.is_false(joke.hidden()) -- chiste con el tono por defecto
    ns.Locales.setTone("plain")
    assert.is_true(joke.hidden())
    ns.Locales.setTone("fun")
    local fights = guide.args.fights.args.b1
    assert.truthy(fights.name():find("No fights saved", 1, true))
    char.fights[1] = { duration = 60, openingSeal = "command", sealSeconds = { command = 60 },
      counts = { judgement = 7, holyStrike = 5, commandProc = 4, sealCast = 1 }, context = {} }
    assert.truthy(fights.name():find("Fights saved: |cfff2c14e1|r", 1, true))
    assert.truthy(fights.name():find("|cfff2c14e9|r out of every 10", 1, true)) -- 7 de 8 posibles

    -- /pfd options abre el panel; /pfd a secas y el minimapa, la ventana principal.
    env.SlashCmdList.PALADINFORDUMMIES("options")
    assert.are.same({ 42 }, w.opened)
    env.SlashCmdList.PALADINFORDUMMIES("")
    env.PaladinForDummies_OnAddonCompartmentClick()
    assert.are.same({ 42 }, w.opened)
  end)

  it("shows the before-pull alert only when something is missing", function()
    local env, w = wowEnv()
    local auras = {}
    env.InCombatLockdown = function() return false end
    env.C_UnitAuras = { GetAuraDataByIndex = function(_, i) return auras[i] end }
    local _, _, _, char = start(env, w)
    char.specOverride = "retribution"
    local alert
    for _, f in ipairs(w.frames) do if rawget(f, "ShowAlerts") then alert = f end end

    -- Enemigo seleccionado y sin sello: aparece el aviso del sello.
    fire(w, "PLAYER_TARGET_CHANGED")
    assert.are.equal("seal:missing", alert.alerts[1].kind .. ":" .. alert.alerts[1].state)
    assert.is_true(alert:HasAlerts())
    alert.slots[1].scripts.OnEnter(alert.slots[1]) -- el tooltip no falla

    -- Con Seal of Command puesto y bien alimentado, no hay nada que decir.
    auras[1] = { spellId = 20918 }
    auras[2] = { spellId = 123456, name = "Well Fed" }
    fire(w, "PLAYER_TARGET_CHANGED")
    assert.are.same({}, alert.alerts)
    assert.is_false(alert:HasAlerts())
  end)

  it("trainer mode: a tip after a fight with something to improve, and a session summary", function()
    local env, w = wowEnv()
    local _, _, _, char = start(env, w)
    local toast
    for _, f in ipairs(w.frames) do if rawget(f, "Present") then toast = f end end
    local presented = {}
    local present = toast.Present
    toast.Present = function(self, title, body, hint) presented[#presented + 1] = body; present(self, title, body, hint) end

    env.SlashCmdList.PALADINFORDUMMIES("trainer")
    assert.is_true(char.trainer.active)
    assert.truthy(output(w):find("Trainer mode on", 1, true))

    -- 40 s de pelea con Command y una sola Sentencia (podías 6).
    env_now = 2000
    fire(w, "PLAYER_REGEN_DISABLED")
    env_now = 2001; fire(w, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-1", 20918)
    env_now = 2002; fire(w, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-2", 20271)
    env_now = 2025; fire(w, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-3", 20918) -- el sello dura 30 s
    env_now = 2041
    fire(w, "PLAYER_REGEN_ENABLED")
    assert.are.equal(1, #presented)
    assert.truthy(presented[1]:find("Judgement", 1, true))

    env.SlashCmdList.PALADINFORDUMMIES("trainer")
    assert.is_false(char.trainer.active)
    assert.truthy(output(w):find("Session summary: 1 fights.", 1, true))
    assert.is_number(char.trainer.previous.judgement)
  end)

  it("notes when you drink after a fight, and fills the Food chapter", function()
    local env, w = wowEnv()
    local auras = {}
    env.C_UnitAuras = { GetAuraDataByIndex = function(_, i) return auras[i] end }
    local _, seen, _, char = start(env, w)
    env_now = 3000; fire(w, "PLAYER_REGEN_DISABLED")
    env_now = 3020; fire(w, "PLAYER_REGEN_ENABLED")
    auras[1] = { spellId = 777, name = "Drink" }
    fire(w, "UNIT_AURA", "player")
    assert.is_true(char.fights[#char.fights].drankAfter)

    local food = seen.options.PaladinForDummies_Guide.args.food.args
    assert.truthy(food.b2.name():find("Best for you now", 1, true))
  end)

  it("opens the main window with all its tabs", function()
    local env, w = wowEnv()
    local _, _, _, char = start(env, w)
    local window
    for _, f in ipairs(w.frames) do if rawget(f, "Open") then window = f end end
    assert.is_table(window)

    char.fights[1] = { duration = 40, time = 1, openingSeal = "command", sealSeconds = { command = 40 },
      counts = { judgement = 4, holyStrike = 3, commandProc = 2, sealCast = 0 }, context = {},
      damage = { total = 8000, spells = { [6603] = 5000, [20424] = 3000 } } }
    for _, tab in ipairs({ "today", "fights", "macros" }) do window:Open(tab) end -- no falla ninguna

    assert.is_nil(char.onboarded) -- la bienvenida sigue pendiente hasta pulsar "Entendido"
  end)

  it("waits until the end of combat to open the options (the game blocks it in combat)", function()
    local env, w = wowEnv()
    start(env, w)
    env.InCombatLockdown = function() return true end

    env.SlashCmdList.PALADINFORDUMMIES("options")
    env.SlashCmdList.PALADINFORDUMMIES("config")
    assert.are.same({}, w.opened)
    assert.truthy(output(w):find("stops hitting you", 1, true))

    env.InCombatLockdown = function() return false end
    fire(w, "PLAYER_REGEN_ENABLED")
    assert.are.same({ 42 }, w.opened) -- una sola vez aunque se pidiera dos
  end)

  it("records a fight, keeps diagnostic commands behind developer mode", function()
    local env, w = wowEnv()
    local ns, _, profile, char = start(env, w)

    env.SlashCmdList.PALADINFORDUMMIES("debug")
    assert.truthy(output(w):find("developer mode", 1, true))
    env.SlashCmdList.PALADINFORDUMMIES("help")
    assert.truthy(output(w):find("/pfd report", 1, true))

    profile.devMode = true
    profile.review.chatSummary = true
    env.SlashCmdList.PALADINFORDUMMIES("spec ret")
    env.SlashCmdList.PALADINFORDUMMIES("debug")
    env.SlashCmdList.PALADINFORDUMMIES("ui")
    env.SlashCmdList.PALADINFORDUMMIES("test a")

    -- Pasar el ratón por los iconos: ejecuta los tooltips.
    local hovered = 0
    for _, f in ipairs(w.frames) do
      if f.scripts.OnEnter then f.scripts.OnEnter(f); hovered = hovered + 1 end
    end
    assert.is_true(hovered >= 5) -- los huecos del aviso, las macros de la ventana...
    assert.is_table(char.snapshot.alerts)

    -- Indicador de Unsealed Wrath: se crea por defecto y su inicialización no falla
    assert.is_true(char.echoStatus.created)
    env.SlashCmdList.PALADINFORDUMMIES("echodebug")
    assert.is_table(char.echoDebug)
    local slotErrors = {}
    for _, echo in ipairs(ns.UI.EchoTracker.ECHOES) do
      ns.UI.EchoTracker.initializer(echo, function(key, err) slotErrors[#slotErrors + 1] = key .. ": " .. tostring(err) end)(mock())
    end
    assert.are.same({}, slotErrors)

    -- Una pelea de 20 s con Command: Sentencia, Holy Strike y dos activaciones.
    env_now = 1000
    fire(w, "PLAYER_REGEN_DISABLED")
    fire(w, "PLAYER_TARGET_CHANGED")
    env_now = 1002; fire(w, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-1", 20271)
    env_now = 1004; fire(w, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-2", 2495)
    env_now = 1006; fire(w, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-3", 20424)
    env_now = 1012; fire(w, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-4", 20424)
    env_now = 1020
    env.UnitGUID = function() return "Player-1" end
    env.C_DamageMeter = { GetCombatSessionSourceFromType = function()
      return { totalAmount = 900, combatSpells = { { spellID = 20424, totalAmount = 400 } } }
    end }
    fire(w, "PLAYER_REGEN_ENABLED")
    env.SlashCmdList.PALADINFORDUMMIES("stats")
    env.SlashCmdList.PALADINFORDUMMIES("test off")

    local out = output(w)
    assert.truthy(out:find("Sello: command %(spellID 20918"), out)
    assert.truthy(out:find("Sentencia: crusader %(spellID 20306"), out)
    assert.truthy(out:find("Arma: velocidad 2.4, daño 110.35-160", 1, true), out)
    assert.are.equal("retribution", char.specOverride)
    assert.is_nil(char.test)

    local f = char.fights[1]
    assert.are.equal(1, #char.fights)
    assert.are.equal(20, f.duration)
    assert.are.equal("command", f.openingSeal)
    assert.are.same({ command = 3 }, f.openingEchoes)
    assert.are.same({ total = 900, spells = { [20424] = 400 } }, f.damage) -- medidor de Blizzard
    assert.are.same({ judgement = 1, holyStrike = 1, commandProc = 2, sealCast = 0 }, f.counts)
    assert.are.same({ command = 20 }, f.sealSeconds)
    assert.is_true(math.abs(f.context.weaponBaseSpeed - 2.4) < 0.001)
    assert.are.equal("A", f.context.test)
    assert.are.same({
      { t = 2, kind = "judgement" },
      { t = 4, kind = "holyStrike" },
      { t = 6, kind = "commandProc" },
      { t = 12, kind = "commandProc" },
    }, f.timeline)
    assert.truthy(out:find("[prueba A] Solo Seal of Command | 20 s | Sentencias: 1 | Holy Strike: 1 | activaciones de Command: 2", 1, true), out)
    assert.truthy(out:find("Total con Seal of Command: 2 activaciones en 20 s = 6 por minuto", 1, true), out)

    -- El estado queda guardado en el personaje para el informe
    assert.are.equal("0.9.0", char.snapshot.addonVersion)
    assert.are.equal("override", char.snapshot.diagnostics.specSource)
    assert.are.same({}, w.errors)
  end)

  it("sends errors to the error handler and the report, not to the chat", function()
    local env, w = wowEnv()
    local ns = loadAddon(env)
    -- Un fallo dentro del motor: una regla que apunta a un sello inexistente.
    table.insert(ns.Data.Rules, { id = "broken", priority = 99, when = {}, recommend = { seal = "nope" },
      why = "x", confidence = "mechanic" })
    fire(w, "ADDON_LOADED", "PaladinForDummies")
    fire(w, "PLAYER_ENTERING_WORLD")
    fire(w, "PLAYER_TARGET_CHANGED")

    local char = env.PaladinForDummiesDB.char[CHAR]
    assert.is_true(#char.errors >= 1)
    assert.are.equal("la recomendación", char.errors[1].context)
    assert.truthy(char.errors[1].message:find("unknown seal: nope", 1, true))
    assert.are.equal(1, #w.errors) -- una sola vez por sesión, aunque se repita
    assert.is_nil(output(w):find("unknown seal", 1, true))
  end)
end)
