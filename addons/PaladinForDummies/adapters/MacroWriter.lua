-- Adaptador: crea o actualiza las macros de personaje del addon.
-- CreateMacro y EditMacro no se pueden usar en combate (las macros están
-- protegidas): fuera de combate se escriben; en combate no se hace nada.
-- Solo se toca el cuerpo de las macros que cambian; el nombre y el icono que
-- haya puesto el jugador se respetan.
-- Recibe la API como parámetro para poder probarlo fuera de WoW.
local _, ns = ...
ns.Adapters = ns.Adapters or {}

local MacroWriter = {}
ns.Adapters.MacroWriter = MacroWriter

local QUESTION_MARK = 134400 -- con #showtooltip, el icono es el del hechizo
local DEFAULT_CHARACTER_SLOTS = 18

local function writeOne(api, macro)
  local index = api.GetMacroIndexByName(macro.name)
  if index == 0 then
    local _, perCharacter = api.GetNumMacros()
    if perCharacter >= (api.MAX_CHARACTER_MACROS or DEFAULT_CHARACTER_SLOTS) then return "full" end
    api.CreateMacro(macro.name, QUESTION_MARK, macro.body, true)
    return "created"
  end
  if api.GetMacroBody(index) == macro.body then return "unchanged" end
  api.EditMacro(index, nil, nil, macro.body)
  return "updated"
end

-- Devuelve una lista de { name, action = created|updated|unchanged|full|error, error? },
-- o nil y "combat" si estás en combate.
function MacroWriter.write(api, macros)
  local okCombat, inCombat = pcall(api.InCombatLockdown)
  if not okCombat or inCombat then return nil, "combat" end

  local results = {}
  for _, macro in ipairs(macros) do
    local ok, action = pcall(writeOne, api, macro)
    if ok then
      results[#results + 1] = { name = macro.name, action = action }
    else
      results[#results + 1] = { name = macro.name, action = "error", error = tostring(action) }
    end
  end
  return results
end
