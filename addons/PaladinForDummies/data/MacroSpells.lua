-- Hechizos que usan las macros de utilidad (core/Macros.lua), por spellID.
-- spellIds va de menor a mayor rango. Con conocer cualquiera basta: /cast con el
-- nombre lanza el rango más alto que tengas.
-- Los IDs del sondeo 1 (grimorio de nivel 40) están verificados; los marcados
-- "classic" son rangos que aún no estaban entrenados, sacados de Classic y sin
-- verificar en Forever: solo sirven para reconocer el hechizo si se aprende.
local _, ns = ...
ns.Data = ns.Data or {}

ns.Data.MacroSpells = {
  flashOfLight         = { spellIds = { 19750, 19939, 19940 } },
  holyLight            = { spellIds = { 635, 639, 647, 1026, 1042, 3472 } },
  blessingOfProtection = { spellIds = { 1022, 5599, 10278 } },
  divineProtection     = { spellIds = { 498, 5573 } },
  blessingOfFreedom    = { spellIds = { 1044 } },
  layOnHands           = { spellIds = { 633, 2800 } },                 -- 633: classic
  purify               = { spellIds = { 1152 } },
  hammerOfJustice      = { spellIds = { 853, 5588, 5589, 10308 } },    -- 10308: classic
  repentance           = { spellIds = { 20066 } },
  divineShield         = { spellIds = { 642, 1020 } },                 -- 1020: classic
  blessingOfMight      = { spellIds = { 19740, 19834, 19835, 19836, 19837, 19838, 25291 } }, -- 19837+: classic
  blessingOfKings      = { spellIds = { 20217 } },
  devotionAura         = { spellIds = { 465, 10290, 643, 10291, 1032, 10292, 10293 } },     -- salvo 10290: classic
  retributionAura      = { spellIds = { 7294, 10298, 10299, 10300, 10301 } },               -- salvo 10299: classic
  redemption           = { spellIds = { 7328, 10322, 10324, 20772, 20773 } },               -- 10322+: classic
  exorcism             = { spellIds = { 879, 5614, 5615, 10312, 10313, 10314 } },           -- 10312+: classic
}

-- Sellos y hechizos de macros juntos: lo que el adaptador busca en el grimorio.
ns.Data.TrackedSpells = {}
for key, spell in pairs(ns.Data.Seals) do ns.Data.TrackedSpells[key] = spell end
for key, spell in pairs(ns.Data.MacroSpells) do ns.Data.TrackedSpells["macro:" .. key] = spell end
