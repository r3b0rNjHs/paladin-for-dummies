-- Carga los archivos del addon igual que WoW: cada archivo recibe (addonName, ns)
-- como argumentos variables. Así los tests ejercitan el mismo código que el juego,
-- sin `require` (que en WoW no existe).
local ROOT = "addons/PaladinForDummies/"

local Addon = {}

function Addon.load(files)
  local ns = {}
  for _, file in ipairs(files) do
    local chunk = assert(loadfile(ROOT .. file))
    chunk("PaladinForDummies", ns)
  end
  return ns
end

_G.Addon = Addon
