-- Cuándo se ve el asesor (Lua puro, sin WoW). El consejo es para antes del
-- pull: con un objetivo atacable se ve entero; sin objetivo, atenuado u oculto
-- (lo elige el jugador); en combate se aparta, salvo que pida verlo siempre.
local _, ns = ...
ns.Core = ns.Core or {}

local HudState = {}
ns.Core.HudState = HudState

HudState.FADED = 0.4
HudState.MODES = { "fade", "hide", "always" }

-- state = { mode = fade|hide|always, inCombat, hasTarget } → opacidad (0 = oculto).
function HudState.advisorAlpha(state)
  local mode = state.mode
  if mode == "always" then return 1 end
  if state.inCombat then return 0 end
  if state.hasTarget then return 1 end
  if mode == "hide" then return 0 end
  return HudState.FADED
end
