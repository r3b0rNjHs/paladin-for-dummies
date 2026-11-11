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
}
