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
    local created = api.CreateMacro(macro.name, QUESTION_MARK, macro.body, true)
    -- Si el juego no devuelve el índice, no hay prueba de que exista.
    if type(created) ~= "number" or created == 0 then return "notCreated" end
    return "created", created
  end
  if api.GetMacroBody(index) == macro.body then return "unchanged" end
  api.EditMacro(index, nil, nil, macro.body)
  return "updated"
end

-- Devuelve una lista de { name, action = created|notCreated|updated|unchanged|full|error,
-- index?, error? }, nil y cuántas macros dice el juego que hay al empezar
-- ({ global, character }, para diagnosticar); o nil y "combat" en combate.
function MacroWriter.write(api, macros)
  local okCombat, inCombat = pcall(api.InCombatLockdown)
  if not okCombat or inCombat then return nil, "combat" end

  local okCount, global, character = pcall(api.GetNumMacros)
  local counts = okCount and { global = global, character = character } or nil

  local results = {}
  for _, macro in ipairs(macros) do
    local ok, action, index = pcall(writeOne, api, macro)
    if ok then
      results[#results + 1] = { name = macro.name, action = action, index = index }
    else
      results[#results + 1] = { name = macro.name, action = "error", error = tostring(action) }
    end
  end
  return results, nil, counts
end
