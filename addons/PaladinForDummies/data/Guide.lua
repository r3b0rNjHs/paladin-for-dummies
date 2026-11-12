-- La guía que se ve en las opciones (Opciones → Paladin for Dummies → Guía).
-- Cada capítulo tiene bloques:
--   { text = "CLAVE" }               texto (Locales: GUIDE_<CLAVE>)
--   { text = "CLAVE", spell = id }   texto con el icono del hechizo
--   { text = "CLAVE", fun = true }   solo con el tono con humor
--   { numbers = true }               tus números (los calcula Main.lua)
-- Los títulos son GUIDE_<ID>_TITLE. Lo que no está comprobado en Forever lo
-- dice el propio texto. Los sellos sin spellID volcado van sin icono.
local _, ns = ...
ns.Data = ns.Data or {}

local Seals = ns.Data.Seals
local function seal(key) return Seals[key] and Seals[key].spellIds[1] end

ns.Data.Guide = {
  { id = "START", blocks = {
    { text = "START_WHAT" },
    { text = "START_HUD" },
    { text = "START_JOKE", fun = true },
  } },
  { id = "BASICS", blocks = {
    { text = "BASICS_SEAL" },
    { text = "BASICS_JUDGEMENT", spell = 20271 },
    { text = "BASICS_RULES" },
    { text = "BASICS_JOKE", fun = true },
  } },
  { id = "SEALS", blocks = {
    { text = "SEAL_RIGHTEOUSNESS", spell = seal("righteousness") },
    { text = "SEAL_CRUSADER", spell = seal("crusader") },
    { text = "SEAL_COMMAND", spell = seal("command") },
    { text = "SEAL_LIGHT", spell = seal("light") },
    { text = "SEAL_FURY", spell = seal("fury") },
    { text = "SEAL_JUSTICE", spell = seal("justice") },
    { text = "SEAL_WISDOM", spell = seal("wisdom") },
    { text = "SEALS_JOKE", fun = true },
  } },
  { id = "UNSEALED", blocks = {
    { text = "UNSEALED_WHAT", spell = 1311703 },
    { text = "UNSEALED_HOW" },
    { text = "UNSEALED_MEASURED" },
    { text = "UNSEALED_JOKE", fun = true },
  } },
  { id = "SITUATIONS", blocks = {
    { text = "SIT_SOLO" },
    { text = "SIT_DUNGEON" },
    { text = "SIT_BOSS" },
    { text = "SIT_FLEE" },
    { text = "SIT_UNDEAD" },
    { text = "SIT_TANK" },
    { text = "SIT_JOKE", fun = true },
  } },
  { id = "MACROS", blocks = {
    { text = "MACROS_INTRO" },
    { text = "MACROS_LIST" },
    { text = "MACROS_JOKE", fun = true },
  } },
  { id = "NUMBERS", blocks = {
    { numbers = true },
  } },
  { id = "GLOSSARY", blocks = {
    { text = "GLOSSARY_TEXT" },
  } },
  { id = "FAQ", blocks = {
    { text = "FAQ_TEXT" },
    { text = "FAQ_JOKE", fun = true },
  } },
}
