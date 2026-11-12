-- Panel de opciones en Opciones → AddOns → Paladin for Dummies (Settings API de
-- Blizzard, 10.0+ con los cambios de 11.0.2). Todas las opciones son "proxy":
-- leen y escriben a través de las funciones que pasa Main.lua, que además
-- aplican el cambio al momento (mostrar, escala, etc.).
local _, ns = ...
ns.UI = ns.UI or {}

local Options = {}
ns.UI.Options = Options

local PREFIX = "PaladinForDummies_"

local function percent(value)
  return ("%d%%"):format(math.floor(value * 100 + 0.5))
end

local function header(layout, text)
  if layout and CreateSettingsListSectionHeaderInitializer then
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(text))
  end
end

local function button(layout, name, text, onClick, tooltip)
  if layout and CreateSettingsButtonInitializer then
    layout:AddInitializer(CreateSettingsButtonInitializer(name, text, onClick, tooltip, true))
  end
end

local function checkbox(category, key, name, default, get, set, tooltip)
  local setting = Settings.RegisterProxySetting(category, PREFIX .. key, "boolean", name, default, get, set)
  Settings.CreateCheckbox(category, setting, tooltip)
  return setting
end

local function slider(category, key, name, default, min, max, step, get, set, tooltip)
  local setting = Settings.RegisterProxySetting(category, PREFIX .. key, "number", name, default, get, set)
  local options = Settings.CreateSliderOptions(min, max, step)
  if MinimalSliderWithSteppersMixin then
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, percent)
  end
  Settings.CreateSlider(category, setting, options, tooltip)
  return setting
end

-- h: funciones de Main.lua. Devuelve la categoría, o nil y el motivo.
function Options.register(h)
  if not (Settings and Settings.RegisterVerticalLayoutCategory) then
    return nil, "este cliente no tiene la Settings API"
  end
  local category, layout = Settings.RegisterVerticalLayoutCategory("Paladin for Dummies")
  if not layout and SettingsPanel and SettingsPanel.GetLayout then layout = SettingsPanel:GetLayout(category) end

  header(layout, "Asesor antes del pull")
  checkbox(category, "advisorShown", "Mostrar el asesor", true, h.getAdvisorShown, h.setAdvisorShown,
    "La ventana con el sello y la Sentencia recomendados.")
  checkbox(category, "advisorLocked", "Bloquear su posición", false, h.getAdvisorLocked, h.setAdvisorLocked,
    "Impide arrastrarla sin querer. Los tooltips siguen funcionando.")
  slider(category, "advisorScale", "Tamaño del asesor", 1, 0.5, 2, 0.05, h.getAdvisorScale, h.setAdvisorScale)
  button(layout, "Posición del asesor", "Restablecer", h.resetAdvisorPosition,
    "Devuelve la ventana a su sitio inicial.")

  header(layout, "Widget de Unsealed Wrath")
  checkbox(category, "echoShown", "Mostrar el widget", false, h.getEchoShown, h.setEchoShown,
    "Copias de Echo of Command y Echo of Righteousness, con aviso para cambiar de sello.")
  slider(category, "echoScale", "Tamaño del widget", 1, 0.5, 2, 0.05, h.getEchoScale, h.setEchoScale)
  button(layout, "Mover el widget", "Desbloquear / fijar", h.toggleEchoMove,
    "Muestra un recuadro para arrastrarlo. Pulsa otra vez para fijarlo.")
  button(layout, "Posición del widget", "Restablecer", h.resetEchoPosition,
    "Devuelve el widget a su sitio inicial.")

  header(layout, "Macros")
  checkbox(category, "macrosAuto", "Crear y actualizar las macros", false, h.getMacrosAuto, h.setMacrosAuto,
    "Macros de personaje con los nombres de tu cliente. Se actualizan solas fuera de combate.")
  for _, name in ipairs(h.macroNames) do
    checkbox(category, "macro_" .. name:gsub("%s", "_"), name, true,
      function() return h.getMacroEnabled(name) end,
      function(value) h.setMacroEnabled(name, value) end,
      "Desmarcada, el addon no la crea ni la actualiza (si ya existe, no la borra: bórrala desde /macro).")
  end
  button(layout, "Macros", "Crear o actualizar ahora", h.syncMacrosNow,
    "Hay un máximo de 18 macros por personaje.")

  header(layout, "Repaso tras el combate")
  checkbox(category, "fightSummary", "Resumen en el chat tras cada pelea", true, h.getFightSummary, h.setFightSummary)
  button(layout, "Estadísticas", "Mostrar en el chat", h.printStats,
    "Lo mismo que /pfd stats.")
  button(layout, "Peleas guardadas", "Borrar", h.resetStats,
    "Borra todas las peleas guardadas. Pide confirmación.")

  Settings.RegisterAddOnCategory(category)
  Options.category = category
  return category
end

function Options.open()
  if not (Options.category and Settings and Settings.OpenToCategory) then return false end
  Settings.OpenToCategory(Options.category:GetID())
  return true
end
