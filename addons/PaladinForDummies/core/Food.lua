-- Qué comida te conviene (Lua puro, sin WoW). El catálogo está en data/Food.lua
-- (guías de la comunidad: los niveles son aproximados).
--   forPlayer: lo mejor para tu nivel ahora, lo siguiente y si sabes cocinarlo.
local _, ns = ...
ns.Core = ns.Core or {}

local Food = {}
ns.Core.Food = Food

local function withCooking(item, cooking)
  local out = {}
  for k, v in pairs(item) do out[k] = v end
  if cooking and type(cooking.skill) == "number" then
    out.canCook = cooking.skill >= item.skill
    out.skillMissing = out.canCook and 0 or (item.skill - cooking.skill)
  end
  return out
end

-- cooking = { skill, max } o nil. Devuelve { now, next, nextLevel }.
function Food.forPlayer(catalog, level, cooking)
  level = level or 1
  local current, nextLevel = nil, nil
  for _, item in ipairs(catalog) do
    if item.minLevel <= level and (not current or item.minLevel > current) then current = item.minLevel end
  end
  for _, item in ipairs(catalog) do
    if item.minLevel > level and (not nextLevel or item.minLevel < nextLevel) then nextLevel = item.minLevel end
  end
  local now, next = {}, {}
  for _, item in ipairs(catalog) do
    if item.minLevel == current then now[#now + 1] = withCooking(item, cooking) end
    if item.minLevel == nextLevel then next[#next + 1] = withCooking(item, cooking) end
  end
  return { now = now, next = next, nextLevel = nextLevel }
end
