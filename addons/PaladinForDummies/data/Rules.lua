-- Reglas declarativas: cuándo conviene cada sello.
-- Campos:
--   id          identificador único
--   priority    mayor gana
--   when        condiciones (ver core/Conditions.lua); vacío = siempre
--   recommend   { seal = clave, judgement = clave } (claves de data/Seals.lua)
--   why         el porqué que verá el jugador
--   confidence  mechanic (sale de la mecánica) | consensus (guías) | measured (datos propios)
--
-- Solo entran reglas que se apoyan en datos que podemos leer (ver CLAUDE.md):
-- nada de maná ni vida, que son secret siempre.
local _, ns = ...
ns.Data = ns.Data or {}

local CREATURE_HUMANOID = 7 -- 2.º retorno de UnitCreatureType (sondeo 1)

ns.Data.Rules = {
  {
    id = "humanoid-justice",
    priority = 30,
    when = { targetCreatureType = CREATURE_HUMANOID },
    recommend = { seal = "justice" },
    why = "Los humanoides huyen con poca vida; Justice los aturde y su Sentencia impide que huyan.",
    confidence = "mechanic",
  },
  {
    id = "ret-command",
    priority = 20,
    when = { spec = "retribution" },
    recommend = { seal = "command" },
    why = "Command golpea por el 74% del daño del arma; es el sello de daño de Retribución.",
    confidence = "mechanic",
  },
  {
    id = "prepull-crusader",
    priority = 20,
    when = {},
    recommend = { judgement = "crusader" },
    why = "La Sentencia ya no consume el sello: juzga Crusader antes del pull (el objetivo recibe más daño Sagrado durante 40 s) y cambia a tu sello de daño.",
    confidence = "consensus",
  },
  {
    id = "fallback-righteousness",
    priority = 0,
    when = {},
    recommend = { seal = "righteousness", judgement = "righteousness" },
    why = "Righteousness está disponible desde el nivel 1 y añade daño Sagrado a cada golpe.",
    confidence = "mechanic",
  },
}
