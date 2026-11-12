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

-- Todo lo que el adaptador busca en el grimorio: sellos, hechizos de macros y
-- otros grupos. Son las mismas tablas, así que LearnRanks las amplía todas.
ns.Data.TrackedSpells = {}
for key, spell in pairs(ns.Data.Seals) do ns.Data.TrackedSpells[key] = spell end
for key, spell in pairs(ns.Data.MacroSpells) do ns.Data.TrackedSpells["macro:" .. key] = spell end
for key, spell in pairs(ns.Data.SpellGroups) do ns.Data.TrackedSpells["spell:" .. key] = spell end

-- Añade los rangos descubiertos en el grimorio ({ [clave] = { spellIDs en orden
-- del grimorio } }). Los IDs listados que no aparecieron van delante (no se
-- conocen); los descubiertos detrás, en orden, para que el rango más alto sea el
-- último. Después rehace el catálogo de peleas.
function ns.Data.LearnRanks(discovered)
  for key, ids in pairs(discovered or {}) do
    local spell = ns.Data.TrackedSpells[key]
    if spell and #ids > 0 then
      local found = {}
      for _, id in ipairs(ids) do found[id] = true end
      local merged = {}
      for _, id in ipairs(spell.spellIds) do
        if not found[id] then merged[#merged + 1] = id end
      end
      for _, id in ipairs(ids) do merged[#merged + 1] = id end
      spell.spellIds = merged
    end
  end
  ns.Data.RebuildCatalog()
end

-- Cómo se presentan las macros en las opciones: grupo, icono (marca de
-- data/Guide.lua GuideSpells) y descripción (Locales: MACRO_DESC_<key>).
-- Los nombres tienen que coincidir con core/Macros.lua (Macros.ALL_NAMES).
ns.Data.MacroGroups = { "COMBAT", "HEAL", "SAFETY", "CONTROL", "BUFFS" }
ns.Data.MacroInfo = {
  { name = "PFD Golpe", group = "COMBAT", icon = "JUDGEMENT", key = "GOLPE" },
  { name = "PFD Unsealed", group = "COMBAT", icon = "COMMAND", key = "UNSEALED" },
  { name = "PFD Sello", group = "COMBAT", icon = "RIGHTEOUSNESS", key = "SELLO" },
  { name = "PFD Exorcismo", group = "COMBAT", icon = "EXORCISM", key = "EXORCISMO" },
  { name = "PFD Cura", group = "HEAL", icon = "FLASH_OF_LIGHT", key = "CURA" },
  { name = "PFD Purificar", group = "HEAL", icon = "PURIFY", key = "PURIFICAR" },
  { name = "PFD Libertad", group = "HEAL", icon = "FREEDOM", key = "LIBERTAD" },
  { name = "PFD Resucitar", group = "HEAL", icon = "REDEMPTION", key = "RESUCITAR" },
  { name = "PFD Escudo", group = "SAFETY", icon = "DIVINE_SHIELD", key = "ESCUDO" },
  { name = "PFD Proteccion", group = "SAFETY", icon = "PROTECTION", key = "PROTECCION" },
  { name = "PFD Manos", group = "SAFETY", icon = "LAY_ON_HANDS", key = "MANOS" },
  { name = "PFD Martillo", group = "CONTROL", icon = "HAMMER", key = "MARTILLO" },
  { name = "PFD Arrepentir", group = "CONTROL", icon = "REPENTANCE", key = "ARREPENTIR" },
  { name = "PFD Bendicion", group = "BUFFS", icon = "MIGHT", key = "BENDICION" },
  { name = "PFD Auras", group = "BUFFS", icon = "DEVOTION", key = "AURAS" },
}
