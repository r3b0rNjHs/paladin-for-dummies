-- Prueba de humo: carga el addon entero en el orden del .toc con un WoW simulado,
-- dispara los eventos principales y los comandos. No prueba la interfaz de verdad
-- (eso solo se puede en el juego); detecta errores de carga, nombres mal escritos
-- y archivos en mal orden.
describe("PaladinForDummies.toc", function()
  local ROOT = "addons/PaladinForDummies/"

  local function tocFiles()
    local files = {}
    for line in io.lines(ROOT .. "PaladinForDummies.toc") do
      if line:match("%.lua%s*$") then files[#files + 1] = (line:gsub("%s+$", "")) end
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

  local function wowEnv()
    local frames, printed, createdMacros = {}, {}, {}
    local env = setmetatable({
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
      UnitLevel = function() return 40 end,
      UnitExists = function() return true end,
      UnitCanAttack = function() return true end,
      UnitCreatureType = function() return "Undead", 6 end,
      UnitClassification = function() return "normal" end,
      IsInInstance = function() return false, "none" end,
      IsInGroup = function() return false end,
      C_Spell = {
        GetSpellTexture = function() return 135000 end,
        GetSpellName = function(id)
          return ({ [20918] = "Seal of Command", [20375] = "Seal of Command", [20306] = "Seal of the Crusader",
            [21084] = "Seal of Righteousness", [20271] = "Judgement" })[id]
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
      C_AddOns = { GetAddOnMetadata = function(_, field) return field == "Version" and "0.2.1" or nil end },
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
    return env, frames, printed
  end

  local function fire(frames, event, ...)
    for _, f in ipairs(frames) do
      local handler = f.scripts.OnEvent
      if handler then handler(f, event, ...) end
    end
  end

  it("saves errors in SavedVariables, not only in the chat", function()
    local env, frames = wowEnv()
    env.UnitLevel = function() error("boom") end
    env.C_SpellBook.GetNumSpellBookSkillLines = function() error("boom") end
    local ns = {}
    for _, file in ipairs(tocFiles()) do
      local chunk = assert(loadfile(ROOT .. file))
      setfenv(chunk, env)
      chunk("PaladinForDummies", ns)
    end
    -- Un fallo dentro del motor: una regla que apunta a un sello inexistente.
    table.insert(ns.Data.Rules, { id = "broken", priority = 99, when = {}, recommend = { seal = "nope" },
      why = "x", confidence = "mechanic" })

    fire(frames, "ADDON_LOADED", "PaladinForDummies")
    fire(frames, "PLAYER_ENTERING_WORLD")

    local errors = env.PaladinForDummiesDB.errors
    assert.is_true(#errors >= 1)
    assert.are.equal("la recomendación", errors[1].context)
    assert.truthy(errors[1].message:find("unknown seal: nope", 1, true))
  end)

  it("loads every file, reacts to events and runs /pfd debug without errors", function()
    local env, frames, printed = wowEnv()
    local ns = {}
    for _, file in ipairs(tocFiles()) do
      local chunk = assert(loadfile(ROOT .. file))
      setfenv(chunk, env)
      chunk("PaladinForDummies", ns)
    end

    fire(frames, "ADDON_LOADED", "PaladinForDummies")
    fire(frames, "PLAYER_ENTERING_WORLD")
    env.SlashCmdList.PALADINFORDUMMIES("spec ret")
    env.SlashCmdList.PALADINFORDUMMIES("debug")
    env.SlashCmdList.PALADINFORDUMMIES("ui")
    env.SlashCmdList.PALADINFORDUMMIES("reset")
    -- Pasar el ratón por los iconos: ejecuta los tooltips.
    local hovered = 0
    for _, f in ipairs(frames) do
      if f.scripts.OnEnter then f.scripts.OnEnter(f); hovered = hovered + 1 end
    end
    assert.are.equal(2, hovered)

    -- Widget experimental de Unsealed Wrath: se crea y su inicialización no falla.
    env.SlashCmdList.PALADINFORDUMMIES("echo")
    assert.is_true(env.PaladinForDummiesDB.echo)
    assert.is_true(env.PaladinForDummiesDB.echoStatus.created)
    env.SlashCmdList.PALADINFORDUMMIES("echo move")
    env.SlashCmdList.PALADINFORDUMMIES("echo move")
    env.SlashCmdList.PALADINFORDUMMIES("echo reset")
    env.SlashCmdList.PALADINFORDUMMIES("echo debug")
    assert.is_table(env.PaladinForDummiesDB.echoDebug)
    local slotErrors = {}
    for _, echo in ipairs(ns.UI.EchoTracker.ECHOES) do
      ns.UI.EchoTracker.initializer(echo, function(key, err) slotErrors[#slotErrors + 1] = key .. ": " .. tostring(err) end)(mock())
    end
    assert.are.same({}, slotErrors)
    -- Macros: con Command y Crusader conocidos, se crea la de apertura.
    env.SlashCmdList.PALADINFORDUMMIES("macros")
    assert.are.equal("#showtooltip\n/castsequence reset=target/combat Seal of the Crusader, Judgement, Seal of Command",
      env.createdMacros["PFD Apertura"])
    assert.is_true(env.PaladinForDummiesDB.macros)

    -- Una pelea de 20 s con Command: Sentencia, Holy Strike y dos activaciones.
    env.SlashCmdList.PALADINFORDUMMIES("test a")
    env_now = 1000
    fire(frames, "PLAYER_REGEN_DISABLED")
    fire(frames, "PLAYER_TARGET_CHANGED")
    env_now = 1002; fire(frames, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-1", 20271)
    env_now = 1004; fire(frames, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-2", 2495)
    env_now = 1006; fire(frames, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-3", 20424)
    env_now = 1012; fire(frames, "UNIT_SPELLCAST_SUCCEEDED", "player", "Cast-4", 20424)
    env_now = 1020
    fire(frames, "PLAYER_REGEN_ENABLED")
    env.SlashCmdList.PALADINFORDUMMIES("stats")
    env.SlashCmdList.PALADINFORDUMMIES("last")
    env.SlashCmdList.PALADINFORDUMMIES("test off")
    env.SlashCmdList.PALADINFORDUMMIES("test")

    local output = table.concat(printed, "\n")
    assert.is_nil(output:find("Error"), output)
    assert.truthy(output:find("Sello: command %(spellID 20918"), output)
    assert.truthy(output:find("Sentencia: crusader %(spellID 20306"), output)
    assert.truthy(output:find("mostrada"), output)
    assert.is_table(env.PaladinForDummiesDB)
    assert.are.equal("retribution", env.PaladinForDummiesDB.specOverride)

    -- El repaso tras el combate
    local fights = env.PaladinForDummiesDB.fights
    assert.are.equal(1, #fights)
    local f = fights[1]
    assert.are.equal(20, f.duration)
    assert.are.equal("command", f.openingSeal)
    assert.are.same({ command = 3 }, f.openingEchoes)
    assert.are.same({ judgement = 1, holyStrike = 1, commandProc = 2, sealCast = 0 }, f.counts)
    assert.are.same({ command = 20 }, f.sealSeconds)
    assert.is_true(math.abs(f.context.weaponSpeed - 2.4) < 0.001)
    assert.are.equal(6, f.context.target.creatureType)
    assert.truthy(output:find("[prueba A] Solo Seal of Command | 20 s | Sentencias: 1 | Holy Strike: 1 | activaciones de Command: 2", 1, true), output)
    assert.are.same({
      { t = 2, kind = "judgement" },
      { t = 4, kind = "holyStrike" },
      { t = 6, kind = "commandProc" },
      { t = 12, kind = "commandProc" },
    }, f.timeline)
    assert.truthy(output:find("Solo Seal of Command | peleas: 1 | duración media: 20 s", 1, true), output)
    assert.are.equal("A", f.context.test)
    assert.truthy(output:find("Prueba A | peleas: 1 | duración media: 20 s", 1, true), output)
    assert.truthy(output:find("Command: 2 activaciones en 20 s con el sello puesto = 6 por minuto", 1, true), output)
    assert.truthy(output:find("No hay ninguna prueba activa", 1, true), output)
    assert.is_nil(env.PaladinForDummiesDB.test)
    assert.truthy(output:find("Peleas guardadas: 1.", 1, true), output)
    assert.truthy(output:find("Widget desbloqueado", 1, true), output)
    assert.truthy(output:find("Widget fijado en su sitio", 1, true), output)
    assert.truthy(output:find("Total con Seal of Command: 2 activaciones en 20 s = 6 por minuto", 1, true), output)
    assert.truthy(output:find("Arma: velocidad 2.4, daño 110.35-160", 1, true), output)

    -- Todo lo de /pfd debug queda también en el archivo de SavedVariables
    local snap = env.PaladinForDummiesDB.snapshot
    assert.are.equal("0.2.1", snap.addonVersion)
    assert.are.equal("70888", snap.client.build)
    assert.are.equal("retribution", snap.situation.player.spec)
    assert.are.equal("override", snap.diagnostics.specSource)
    assert.are.equal("command", snap.recommendation.seal.seal)
  end)
end)
