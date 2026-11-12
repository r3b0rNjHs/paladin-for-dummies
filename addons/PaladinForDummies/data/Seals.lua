-- Sellos del paladín en Forever, identificados por spellID (nunca por nombre).
-- spellIds va ordenado de menor a mayor rango.
-- Fuente: volcado del grimorio del sondeo 1 (docs/probe-results/2026-11-11-sondeo-1.md).
-- Un sello sin spellIds todavía no se ha volcado: el motor nunca lo recomienda.
local _, ns = ...
ns.Data = ns.Data or {}

ns.Data.Seals = {
  righteousness = { spellIds = { 21084 } },                      -- solo rango 1 volcado
  crusader      = { spellIds = { 21082, 20162, 20305, 20306 } },
  command       = { spellIds = { 20375, 20915, 20918 } },        -- talento de Ret
  light         = { spellIds = { 20165 } },
  fury          = { spellIds = {} },                             -- pendiente de volcar
  justice       = { spellIds = {} },                             -- pendiente de volcar
  wisdom        = { spellIds = {} },                             -- pendiente de volcar
}

-- Otros hechizos que usa el addon.
ns.Data.Spells = {
  judgement = 20271, -- libera el sello activo sin consumirlo (sondeo 1)
  holyStrike = 679,  -- rango 1; /cast con el nombre usa el rango más alto (sondeo 1)
}

-- Catálogo para registrar peleas (core/Fight.lua): qué es cada spellID.
-- Holy Strike y Command (activación) salen del sondeo 1. Echo of Righteousness
-- (1311704) sale de Icy Veins, sin confirmar en nuestro cliente.
local HOLY_STRIKE_RANKS = { 679, 678, 1866, 680, 2495 }

local function set(ids)
  local out = {}
  for _, id in ipairs(ids) do out[id] = true end
  return out
end

local sealBySpellId = {}
for key, seal in pairs(ns.Data.Seals) do
  for _, id in ipairs(seal.spellIds) do sealBySpellId[id] = key end
end

ns.Data.Catalog = {
  sealBySpellId = sealBySpellId,
  echoBySpellId = { [1311703] = "command", [1311704] = "righteousness" },
  judgement = set({ ns.Data.Spells.judgement }),
  holyStrike = set(HOLY_STRIKE_RANKS),
  commandProc = set({ 20424 }),
}
