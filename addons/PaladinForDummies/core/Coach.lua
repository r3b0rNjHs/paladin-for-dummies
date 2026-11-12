-- El modo entrenador (Lua puro, sin WoW). Lo activa el jugador cuando quiere
-- practicar (decisión de Jorge, 12 nov: si sale tras cada pelea, cansa):
--   fightTip  el consejo más importante de una pelea, o nil si fue bien
--   session   el resumen de la sesión, de 10, y la mejora frente a la anterior
local _, ns = ...
ns.Core = ns.Core or {}

local Coach = {}
ns.Core.Coach = Coach

local MIN_DURATION = 15     -- peleas más cortas no dan para un consejo
local NO_SEAL_SECONDS = 8   -- más tiempo sin sello que esto, se avisa
local MISSED = 2            -- Sentencias o Holy Strike sin usar para avisar

local function sealTime(fight)
  local total = 0
  for _, seconds in pairs(fight.sealSeconds or {}) do total = total + seconds end
  return total
end

-- known = { holyStrike = true/false }. Devuelve { key, value } o nil.
function Coach.fightTip(fight, known)
  local duration = type(fight.duration) == "number" and fight.duration or 0
  if duration < MIN_DURATION then return nil end

  local withoutSeal = math.floor(duration - sealTime(fight) + 0.5)
  if withoutSeal > NO_SEAL_SECONDS then return { key = "NO_SEAL", value = withoutSeal } end

  local usage = ns.Core.Guide.usage({ fight })
  local judgeMissed = usage.judgement.possible - usage.judgement.used
  if judgeMissed >= MISSED then return { key = "JUDGE", value = judgeMissed } end

  if known and known.holyStrike then
    local strikeMissed = usage.holyStrike.possible - usage.holyStrike.used
    if strikeMissed >= MISSED then return { key = "STRIKE", value = strikeMissed } end
  end
  return nil
end

local function per10(u)
  if u.possible == 0 then return nil end
  return math.floor(u.used / u.possible * 10 + 0.5)
end

-- previous = { judgement, holyStrike } (de 10) de la sesión anterior, o nil.
function Coach.session(fights, previous)
  local usage = ns.Core.Guide.usage(fights)
  if usage.fights == 0 then return nil end
  local s = { fights = usage.fights, judgement = per10(usage.judgement), holyStrike = per10(usage.holyStrike) }
  if previous then
    if s.judgement and previous.judgement then s.judgementChange = s.judgement - previous.judgement end
    if s.holyStrike and previous.holyStrike then s.holyStrikeChange = s.holyStrike - previous.holyStrike end
  end
  return s
end
