-- Comidas de Fuerza o poder de ataque para un paladín de Retribución, por tramo
-- de nivel (investigación del 12 nov 2026, docs/research.md, "Comida para
-- Retribución"). Son datos de guías de la comunidad: los niveles mínimos son
-- aproximados y los nombres van en inglés porque no tenemos los IDs de objeto.
--   minLevel  desde qué nivel conviene (aproximado: míralo en el tooltip)
--   stat      STR (Fuerza) o AP (poder de ataque); amount, cuánto
--   skill     Cocina necesaria para la receta
--   source    de dónde sale la receta (Locales: FOOD_SRC_<source>)
--   oven      necesita el Iron Oven
local _, ns = ...
ns.Data = ns.Data or {}

ns.Data.Food = {
  { name = "Lean Venison", minLevel = 15, stat = "STR", amount = 5, skill = 110, source = "ULTHAAN" },
  { name = "Plain Ol' Paletusk", minLevel = 25, stat = "STR", amount = 10, skill = 185, source = "MARTHA" },
  { name = "Bear Brisket", minLevel = 25, stat = "STR", amount = 10, skill = 175, source = "BEARS" },
  { name = "Savory Stag Sliders", minLevel = 35, stat = "STR", amount = 15, skill = 225, source = "QIA" },
  { name = "Cooked Glossy Mightfish", minLevel = 35, stat = "AP", amount = 30, skill = 225, source = "KELSEY" },
  { name = "Steaming Stag Steak", minLevel = 45, stat = "STR", amount = 20, skill = 275, source = "HYJAL", oven = true },
  { name = "Mightfish Steak", minLevel = 45, stat = "AP", amount = 40, skill = 275, source = "FERALAS" },
  { name = "Poached Sunscale Salmon", minLevel = 45, stat = "AP", amount = 40, skill = 250, source = "GIKKIX", oven = true },
  { name = "Smoked Desert Dumplings", minLevel = 45, stat = "STR", amount = 20, skill = 285, source = "TRAINER" },
  { name = "Prowler Steak", minLevel = 55, stat = "STR", amount = 25, skill = 250, source = "UNKNOWN" },
}

-- El icono del aviso de comida: el del buff Well Fed.
ns.Data.FoodBuffSpell = 19705
