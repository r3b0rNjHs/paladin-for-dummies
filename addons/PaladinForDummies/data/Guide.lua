-- La guía que se ve en las opciones (Opciones → Paladin for Dummies → Guía).
-- Pensada para leerse cómoda: encabezados, bloques cortos y un icono por bloque.
-- Cada capítulo tiene bloques:
--   { header = "CLAVE" }              encabezado (Locales: GUIDE_<CLAVE>)
--   { text = "CLAVE" }                texto
--   { text = "CLAVE", spell = id }    texto con el icono del hechizo
--   { text = "CLAVE", icon = ruta }   texto con un icono del juego
--   { text = "CLAVE", fun = true }    chiste: solo con el tono con humor
--   { numbers = true }                tus números (los calcula Main.lua)
-- Los títulos son GUIDE_<ID>_TITLE. Lo que no está comprobado en Forever lo
-- dice el propio texto. Los sellos sin spellID volcado van sin icono.
local _, ns = ...
ns.Data = ns.Data or {}

local Seals = ns.Data.Seals
local function seal(key) return Seals[key] and Seals[key].spellIds[1] end

local JUDGEMENT, HOLY_STRIKE = 20271, 679
local ECHO_OF_COMMAND = 1311703
local HAMMER_OF_JUSTICE, EXORCISM, DIVINE_PROTECTION, HOLY_LIGHT = 853, 879, 498, 635 -- sondeo 1
local BOOK = "Interface\\Icons\\INV_Misc_Book_09"
local QUESTION = "Interface\\Icons\\INV_Misc_QuestionMark"

ns.Data.Guide = {
  { id = "START", blocks = {
    { header = "START_H_WHAT" },
    { text = "START_BEFORE", spell = seal("crusader") },
    { text = "START_DURING", spell = ECHO_OF_COMMAND },
    { text = "START_AFTER", icon = BOOK },
    { header = "START_H_ICONS" },
    { text = "START_COLORS" },
    { text = "START_SOURCES" },
    { text = "START_JOKE", fun = true },
  } },
  { id = "BASICS", blocks = {
    { header = "BASICS_H_SEAL" },
    { text = "BASICS_SEAL", spell = seal("righteousness") },
    { header = "BASICS_H_JUDGEMENT" },
    { text = "BASICS_JUDGEMENT", spell = JUDGEMENT },
    { header = "BASICS_H_RULES" },
    { text = "BASICS_RULE_ONE", spell = JUDGEMENT },
    { text = "BASICS_RULE_PREPULL", spell = seal("crusader") },
    { text = "BASICS_RULE_STRIKE", spell = HOLY_STRIKE },
    { text = "BASICS_JOKE", fun = true },
  } },
  { id = "SEALS", blocks = {
    { header = "SEALS_H_DAMAGE" },
    { text = "SEAL_RIGHTEOUSNESS", spell = seal("righteousness") },
    { text = "SEAL_COMMAND", spell = seal("command") },
    { header = "SEALS_H_PREPULL" },
    { text = "SEAL_CRUSADER", spell = seal("crusader") },
    { header = "SEALS_H_SUSTAIN" },
    { text = "SEAL_LIGHT", spell = seal("light") },
    { text = "SEAL_WISDOM", spell = seal("wisdom") },
    { header = "SEALS_H_SPECIAL" },
    { text = "SEAL_JUSTICE", spell = seal("justice") },
    { text = "SEAL_FURY", spell = seal("fury") },
    { text = "SEALS_JOKE", fun = true },
  } },
  { id = "UNSEALED", blocks = {
    { header = "UNSEALED_H_WHAT" },
    { text = "UNSEALED_WHAT", spell = ECHO_OF_COMMAND },
    { header = "UNSEALED_H_HOW" },
    { text = "UNSEALED_STEP_1", spell = seal("command") },
    { text = "UNSEALED_STEP_2", spell = seal("righteousness") },
    { text = "UNSEALED_STEP_3", spell = seal("command") },
    { text = "UNSEALED_SHORTCUT" },
    { header = "UNSEALED_H_MEASURED" },
    { text = "UNSEALED_MEASURED" },
    { text = "UNSEALED_JOKE", fun = true },
  } },
  { id = "SITUATIONS", blocks = {
    { text = "SIT_SOLO", spell = seal("crusader") },
    { text = "SIT_DUNGEON", spell = seal("command") },
    { text = "SIT_BOSS", spell = JUDGEMENT },
    { text = "SIT_FLEE", spell = HAMMER_OF_JUSTICE },
    { text = "SIT_UNDEAD", spell = EXORCISM },
    { text = "SIT_TANK", spell = DIVINE_PROTECTION },
    { text = "SIT_JOKE", fun = true },
  } },
  { id = "MACROS", blocks = {
    { text = "MACROS_INTRO" },
    { text = "MACRO_GOLPE", spell = JUDGEMENT },
    { text = "MACRO_UNSEALED", spell = seal("command") },
    { text = "MACRO_SELLO", spell = seal("righteousness") },
    { text = "MACRO_UTILITY", spell = HOLY_LIGHT },
    { text = "MACROS_JOKE", fun = true },
  } },
  { id = "NUMBERS", blocks = {
    { numbers = true, icon = BOOK },
  } },
  { id = "GLOSSARY", blocks = {
    { text = "GLOSSARY_TEXT" },
  } },
  { id = "FAQ", blocks = {
    { header = "FAQ_Q_COMBAT" },
    { text = "FAQ_A_COMBAT", icon = QUESTION },
    { header = "FAQ_Q_AUTO" },
    { text = "FAQ_A_AUTO" },
    { header = "FAQ_Q_SOURCE" },
    { text = "FAQ_A_SOURCE" },
    { header = "FAQ_Q_BUG" },
    { text = "FAQ_A_BUG" },
    { text = "FAQ_JOKE", fun = true },
  } },
}
