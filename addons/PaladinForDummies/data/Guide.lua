-- La guía que se ve en las opciones (Opciones → Paladin for Dummies → Guía).
-- Escrita para quien acaba de instalar el addon: primero qué hacer (Tu plan,
-- según los hechizos que conoces), después el porqué. Bloques cortos con un
-- icono, y los nombres de hechizo del propio cliente (en tu idioma) en lugar de
-- las marcas {COMMAND}, {JUDGEMENT}... (core/Guide.lua).
-- Bloques:
--   { header = "CLAVE" }               encabezado (Locales: GUIDE_<CLAVE>)
--   { text = "CLAVE", icon = "TOKEN" } texto con el icono de un hechizo de SPELLS
--   { text = "CLAVE", icon = ruta }    texto con un icono del juego
--   { text = "CLAVE", fun = true }     chiste: solo con el tono con humor
--   { plan = true }                    Tu plan (core/Guide.lua, Main.lua)
--   { fights = true }                  Tus peleas (Main.lua)
-- Los títulos son GUIDE_<ID>_TITLE.
local _, ns = ...
ns.Data = ns.Data or {}

local Seals = ns.Data.Seals
local function seal(key) return Seals[key] and Seals[key].spellIds[1] end

-- Marcas de hechizo → spellID (sondeo 1). Sin spellID volcado, el nombre sale de
-- Locales (SPELL_<TOKEN>) y no hay icono.
ns.Data.GuideSpells = {
  RIGHTEOUSNESS = seal("righteousness"),
  CRUSADER = seal("crusader"),
  COMMAND = seal("command"),
  LIGHT = seal("light"),
  WISDOM = seal("wisdom"),
  JUSTICE = seal("justice"),
  FURY = seal("fury"),
  JUDGEMENT = 20271,
  HOLY_STRIKE = 679,
  ECHO = 1311703, -- Echo of Command
  HAMMER = 853,
  EXORCISM = 879,
  REPENTANCE = 20066,
  DIVINE_SHIELD = 642,
  DIVINE_PROTECTION = 498,
  HOLY_LIGHT = 635,
  FLASH_OF_LIGHT = 19750,
  PURIFY = 1152,
  FREEDOM = 1044,
  REDEMPTION = 7328,
  PROTECTION = 1022, -- Blessing of Protection
  LAY_ON_HANDS = 2800,
  MIGHT = 19740,
  KINGS = 20217,
  DEVOTION = 465,
  RETRIBUTION_AURA = 7294,
  WELL_FED = 19705,
}

local BOOK = "Interface\\Icons\\INV_Misc_Book_09"
local QUESTION = "Interface\\Icons\\INV_Misc_QuestionMark"

ns.Data.Guide = {
  { id = "PLAN", blocks = {
    { plan = true },
  } },
  { id = "HELP", blocks = {
    { text = "HELP_BEFORE", icon = "CRUSADER" },
    { text = "HELP_DURING", icon = "ECHO" },
    { text = "HELP_SUSTAIN", icon = "LIGHT" },
    { text = "HELP_AFTER", icon = BOOK },
    { header = "HELP_H_ICONS" },
    { text = "HELP_COLORS" },
    { text = "HELP_SOURCES" },
    { text = "HELP_JOKE", fun = true },
  } },
  { id = "BASICS", blocks = {
    { header = "BASICS_H_SEAL" },
    { text = "BASICS_SEAL", icon = "RIGHTEOUSNESS" },
    { header = "BASICS_H_JUDGEMENT" },
    { text = "BASICS_JUDGEMENT", icon = "JUDGEMENT" },
    { header = "BASICS_H_RULES" },
    { text = "BASICS_RULE_ONE", icon = "JUDGEMENT" },
    { text = "BASICS_RULE_PREPULL", icon = "CRUSADER" },
    { text = "BASICS_RULE_STRIKE", icon = "HOLY_STRIKE" },
    { text = "BASICS_JOKE", fun = true },
  } },
  { id = "SEALS", blocks = {
    { header = "SEALS_H_DAMAGE" },
    { text = "SEAL_RIGHTEOUSNESS", icon = "RIGHTEOUSNESS" },
    { text = "SEAL_COMMAND", icon = "COMMAND" },
    { header = "SEALS_H_PREPULL" },
    { text = "SEAL_CRUSADER", icon = "CRUSADER" },
    { header = "SEALS_H_SUSTAIN" },
    { text = "SEAL_LIGHT", icon = "LIGHT" },
    { text = "SEAL_WISDOM", icon = "WISDOM" },
    { header = "SEALS_H_SPECIAL" },
    { text = "SEAL_JUSTICE", icon = "JUSTICE" },
    { text = "SEAL_FURY", icon = "FURY" },
    { text = "SEALS_JOKE", fun = true },
  } },
  { id = "UNSEALED", blocks = {
    { text = "UNSEALED_WHAT", icon = "ECHO" },
    { header = "UNSEALED_H_HOW" },
    { text = "UNSEALED_STEP_1", icon = "COMMAND" },
    { text = "UNSEALED_STEP_2", icon = "RIGHTEOUSNESS" },
    { text = "UNSEALED_STEP_3", icon = "COMMAND" },
    { text = "UNSEALED_SHORTCUT" },
    { text = "UNSEALED_JOKE", fun = true },
  } },
  { id = "SITUATIONS", blocks = {
    { text = "SIT_SOLO", icon = "CRUSADER" },
    { text = "SIT_DUNGEON", icon = "COMMAND" },
    { text = "SIT_GROUP", icon = "JUDGEMENT" },
    { text = "SIT_FLEE", icon = "HAMMER" },
    { text = "SIT_UNDEAD", icon = "EXORCISM" },
    { text = "SIT_DANGER", icon = "DIVINE_SHIELD" },
    { text = "SIT_SUSTAIN", icon = "WISDOM" },
    { text = "SIT_JOKE", fun = true },
  } },
  { id = "FOOD", blocks = {
    { text = "FOOD_HOW", icon = "WELL_FED" },
    { food = true },
    { text = "FOOD_OVEN" },
    { text = "FOOD_JOKE", fun = true },
  } },
  { id = "MACROS", blocks = {
    { text = "MACROS_INTRO" },
    { text = "MACRO_GOLPE", icon = "JUDGEMENT" },
    { text = "MACRO_UNSEALED", icon = "COMMAND" },
    { text = "MACRO_SELLO", icon = "RIGHTEOUSNESS" },
    { text = "MACRO_UTILITY", icon = "HOLY_LIGHT" },
    { text = "MACROS_JOKE", fun = true },
  } },
  { id = "FIGHTS", blocks = {
    { fights = true, icon = BOOK },
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
