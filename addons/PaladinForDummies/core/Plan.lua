-- Convierte una Recommendation en los pasos que hace el jugador antes del pull.
-- En Forever la Sentencia (Judgement) es un solo hechizo que libera el sello que
-- llevas puesto, así que "Sentencia de Crusader" son en realidad tres pasos:
--   apply  ponerte el sello de la Sentencia
--   judge  lanzar Judgement sobre el objetivo (el sello no se consume)
--   switch cambiar al sello de la pelea, si es otro
-- Lua puro: sin dependencias de WoW.
local _, ns = ...
ns.Core = ns.Core or {}

local Plan = {}
ns.Core.Plan = Plan

function Plan.prepull(recommendation)
  local seal, judgement = recommendation.seal, recommendation.judgement
  if not judgement then
    if seal then return { { action = "apply", spellId = seal.spellId } } end
    return {}
  end

  local steps = {
    { action = "apply", spellId = judgement.spellId },
    { action = "judge" },
  }
  if seal and seal.spellId ~= judgement.spellId then
    steps[#steps + 1] = { action = "switch", spellId = seal.spellId }
  end
  return steps
end
