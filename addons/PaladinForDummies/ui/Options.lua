-- Panel de opciones con AceConfig (Ace3), dentro del panel de Blizzard
-- (Opciones → AddOns → Paladin for Dummies), con pestañas, un tooltip en cada
-- opción y los perfiles de AceDB como subapartado. Los valores se leen y se
-- aplican a través de las funciones que pasa Main.lua (h).
local ADDON_NAME, ns = ...
ns.UI = ns.UI or {}
local L = ns.L

local Options = {}
ns.UI.Options = Options

local APP = "PaladinForDummies"

local function description(order, text)
  return { type = "description", order = order, name = text, fontSize = "medium" }
end

-- Opción de activar/desactivar unida a un get/set de h.
local function toggle(order, name, desc, get, set, width)
  return { type = "toggle", order = order, name = name, desc = desc, width = width,
    get = function() return get() end, set = function(_, value) set(value) end }
end

local function scale(order, get, set)
  return { type = "range", order = order, name = L.OPT_SCALE, min = 0.5, max = 2, step = 0.05, isPercent = true,
    get = function() return get() end, set = function(_, value) set(value) end }
end

local function button(order, name, desc, func, confirmText)
  return { type = "execute", order = order, name = name, desc = desc, func = func,
    confirm = confirmText and true or nil, confirmText = confirmText }
end

function Options.build(h)
  local macroToggles = {
    description = description(0, L.OPT_MACROS_DESC),
    auto = toggle(1, L.OPT_MACROS_AUTO, L.OPT_MACROS_AUTO_DESC, h.getMacrosAuto, h.setMacrosAuto, "full"),
    now = button(2, L.OPT_MACROS_NOW, nil, h.syncMacrosNow),
    list = { type = "header", order = 10, name = L.OPT_MACROS_LIST },
  }
  for i, name in ipairs(h.macroNames) do
    macroToggles["macro" .. i] = toggle(10 + i, name, L.OPT_MACRO_TOGGLE_DESC,
      function() return h.getMacroEnabled(name) end,
      function(value) h.setMacroEnabled(name, value) end)
  end

  return {
    type = "group",
    name = "Paladin for Dummies",
    childGroups = "tab",
    args = {
      intro = description(0, L.OPT_INTRO),
      guideHint = description(0.5, L.OPT_GUIDE_HINT),
      advisor = {
        type = "group", order = 1, name = L.OPT_ADVISOR,
        args = {
          description = description(0, L.OPT_ADVISOR_DESC),
          shown = toggle(1, L.OPT_SHOW, L.OPT_ADVISOR_SHOW_DESC, h.getAdvisorShown, h.setAdvisorShown),
          visibility = {
            type = "select", order = 2, name = L.OPT_VISIBILITY, desc = L.OPT_VISIBILITY_DESC,
            values = { fade = L.OPT_VIS_FADE, hide = L.OPT_VIS_HIDE, always = L.OPT_VIS_ALWAYS },
            sorting = { "fade", "hide", "always" },
            get = function() return h.getAdvisorVisibility() end,
            set = function(_, value) h.setAdvisorVisibility(value) end,
          },
          locked = toggle(3, L.OPT_LOCK, L.OPT_LOCK_DESC, h.getAdvisorLocked, h.setAdvisorLocked),
          scale = scale(4, h.getAdvisorScale, h.setAdvisorScale),
          reset = button(5, L.OPT_RESET_POSITION, nil, h.resetAdvisorPosition),
        },
      },
      echo = {
        type = "group", order = 2, name = L.OPT_ECHO,
        args = {
          description = description(0, L.OPT_ECHO_DESC),
          shown = toggle(1, L.OPT_SHOW, L.OPT_ECHO_SHOW_DESC, h.getEchoShown, h.setEchoShown),
          scale = scale(2, h.getEchoScale, h.setEchoScale),
          move = button(3, L.OPT_ECHO_MOVE, L.OPT_ECHO_MOVE_DESC, h.toggleEchoMove),
          reset = button(4, L.OPT_RESET_POSITION, nil, h.resetEchoPosition),
        },
      },
      macros = { type = "group", order = 3, name = L.OPT_MACROS, args = macroToggles },
      review = {
        type = "group", order = 4, name = L.OPT_REVIEW,
        args = {
          description = description(0, L.OPT_REVIEW_DESC),
          chat = toggle(1, L.OPT_REVIEW_CHAT, nil, h.getChatSummary, h.setChatSummary, "full"),
          stats = button(2, L.OPT_REVIEW_STATS, nil, h.printStats),
          reset = button(3, L.OPT_REVIEW_RESET, nil, h.resetFights, L.OPT_REVIEW_RESET_CONFIRM),
        },
      },
      advanced = {
        type = "group", order = 5, name = L.OPT_ADVANCED,
        args = {
          language = {
            type = "select", order = 1, name = L.OPT_LANGUAGE, desc = L.OPT_LANGUAGE_DESC,
            values = { auto = L.OPT_LANGUAGE_AUTO, enUS = "English", esES = "Español" },
            sorting = { "auto", "enUS", "esES" },
            get = function() return h.getLanguage() end,
            set = function(_, value) h.setLanguage(value) end,
          },
          tone = {
            type = "select", order = 1.5, name = L.OPT_TONE, desc = L.OPT_TONE_DESC,
            values = { fun = L.OPT_TONE_FUN, plain = L.OPT_TONE_PLAIN },
            sorting = { "fun", "plain" },
            get = function() return h.getTone() end,
            set = function(_, value) h.setTone(value) end,
          },
          report = button(2, L.OPT_REPORT, L.OPT_REPORT_DESC, h.showReport),
          motion = toggle(2.5, L.OPT_REDUCE_MOTION, L.OPT_REDUCE_MOTION_DESC, h.getReduceMotion, h.setReduceMotion, "full"),
          dev = toggle(3, L.OPT_DEV, L.OPT_DEV_DESC, h.getDevMode, h.setDevMode, "full"),
          resetAll = button(4, L.OPT_RESET_ALL, nil, h.resetSettings, L.OPT_RESET_ALL_CONFIRM),
        },
      },
    },
  }
end

-- La guía (data/Guide.lua): un capítulo por grupo, en árbol. Los chistes solo
-- se ven con el tono con humor; los números los calcula Main.lua (h.guideNumbers).
local function spellIcon(spellId)
  if not (spellId and C_Spell and C_Spell.GetSpellTexture) then return nil end
  local ok, icon = pcall(C_Spell.GetSpellTexture, spellId)
  return ok and icon or nil
end

function Options.buildGuide(h)
  local chapters = {}
  for i, chapter in ipairs(ns.Data.Guide) do
    local args = {}
    for j, block in ipairs(chapter.blocks) do
      local entry
      if block.header then
        entry = { type = "header", order = j, name = L["GUIDE_" .. block.header] }
      else
        entry = { type = "description", order = j, fontSize = "medium" }
        if block.numbers then
          entry.name = function() return h.guideNumbers() end
        else
          local key = "GUIDE_" .. block.text
          -- Una línea en blanco detrás para que los bloques respiren.
          entry.name = function() return L[key] .. "\n" end
        end
        local icon = block.icon or spellIcon(block.spell)
        if icon then entry.image, entry.imageWidth, entry.imageHeight = icon, 40, 40 end
        if block.fun then
          entry.hidden = function() return ns.Locales.tone ~= "fun" end
          entry.fontSize = "small"
        end
      end
      args["b" .. j] = entry
    end
    chapters[chapter.id:lower()] = {
      type = "group", order = i, name = L["GUIDE_" .. chapter.id .. "_TITLE"], args = args,
    }
  end
  return { type = "group", name = L.OPT_GUIDE, childGroups = "tree", args = chapters }
end

-- Registra el panel y el subapartado de perfiles. Devuelve el ID de categoría.
function Options.register(h, db)
  local registry = LibStub("AceConfigRegistry-3.0")
  local dialog = LibStub("AceConfigDialog-3.0")
  registry:RegisterOptionsTable(APP, Options.build(h))
  local _, id = dialog:AddToBlizOptions(APP, "Paladin for Dummies")
  Options.categoryID = id

  registry:RegisterOptionsTable(APP .. "_Guide", Options.buildGuide(h))
  dialog:AddToBlizOptions(APP .. "_Guide", L.OPT_GUIDE, "Paladin for Dummies")

  local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
  registry:RegisterOptionsTable(APP .. "_Profiles", profiles)
  dialog:AddToBlizOptions(APP .. "_Profiles", L.OPT_PROFILES, "Paladin for Dummies")
  return id
end

function Options.open()
  if not (Options.categoryID and Settings and Settings.OpenToCategory) then return false end
  Settings.OpenToCategory(Options.categoryID)
  return true
end

-- Para que el panel muestre los valores al día si se cambian por comando.
function Options.refresh()
  local registry = LibStub and LibStub("AceConfigRegistry-3.0", true)
  if registry then registry:NotifyChange(APP) end
end
