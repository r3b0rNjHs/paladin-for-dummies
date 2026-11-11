-- Adaptador: lee el estado al empezar una pelea.
-- Se llama en PLAYER_REGEN_DISABLED, cuando InCombatLockdown() todavía es false y
-- las auras propias aún se pueden leer (sondeo 1). Ya en combate,
-- C_UnitAuras.GetAuraDataByIndex da error, así que esto es todo lo que sabremos de
-- las auras durante la pelea.
--
-- Devuelve { t, seal, sealExpires, echoes = { [sello] = acumulaciones } }.
-- Reglas: todo con pcall, identificación por spellID y ningún valor secret.
local _, ns = ...
ns.Adapters = ns.Adapters or {}

local FightReader = {}
ns.Adapters.FightReader = FightReader

local MAX_AURAS = 40

local function readable(api, v)
  if v == nil then return nil end
  if type(api.issecretvalue) == "function" then
    local ok, secret = pcall(api.issecretvalue, v)
    if not ok or secret then return nil end
  end
  return v
end

local function auraField(api, aura, field)
  local ok, v = pcall(function() return aura[field] end)
  if not ok then return nil end
  return readable(api, v)
end

function FightReader.readOpening(api, catalog)
  local okTime, now = pcall(api.GetTime)
  local opening = { t = okTime and readable(api, now) or nil, echoes = {} }

  local getAura = api.C_UnitAuras and api.C_UnitAuras.GetAuraDataByIndex
  if type(getAura) ~= "function" then return opening end

  for i = 1, MAX_AURAS do
    local ok, aura = pcall(getAura, "player", i, "HELPFUL")
    if not ok or type(aura) ~= "table" then break end

    local spellId = auraField(api, aura, "spellId")
    if type(spellId) == "number" then
      local seal = catalog.sealBySpellId[spellId]
      local echo = catalog.echoBySpellId[spellId]
      if seal then
        opening.seal = seal
        local expires = auraField(api, aura, "expirationTime")
        if type(expires) == "number" and expires > 0 then opening.sealExpires = expires end
      elseif echo then
        local stacks = auraField(api, aura, "applications")
        if type(stacks) == "number" then opening.echoes[echo] = stacks end
      end
    end
  end
  return opening
end
