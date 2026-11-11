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
        return function() return mock() end
      end,
    })
  end

  local function wowEnv()
    local frames, printed = {}, {}
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
      C_Spell = { GetSpellTexture = function() return 135000 end },
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
    fire(frames, "PLAYER_REGEN_DISABLED")
    fire(frames, "PLAYER_TARGET_CHANGED")
    fire(frames, "PLAYER_REGEN_ENABLED")

    local output = table.concat(printed, "\n")
    assert.is_nil(output:find("Error"), output)
    assert.truthy(output:find("Sello: command %(spellID 20918"), output)
    assert.truthy(output:find("Sentencia: crusader %(spellID 20306"), output)
    assert.truthy(output:find("mostrada"), output)
    assert.is_table(env.PaladinForDummiesDB)
    assert.are.equal("retribution", env.PaladinForDummiesDB.specOverride)
  end)
end)
