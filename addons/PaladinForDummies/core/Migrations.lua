-- Migración de SavedVariables. Hasta la v0.8 PaladinForDummiesDB era una tabla
-- plana de cuenta (ajustes, peleas y diagnósticos mezclados). Desde la v0.9 la
-- gestiona AceDB: ajustes en el perfil y peleas en el personaje.
-- Lua puro: sin dependencias de WoW.
local _, ns = ...
ns.Core = ns.Core or {}

local Migrations = {}
ns.Core.Migrations = Migrations

local LEGACY_KEYS = { "fights", "hidden", "position", "echo", "echoPosition", "macros", "quiet", "snapshot" }

function Migrations.isLegacy(saved)
  if type(saved) ~= "table" or saved.profileKeys or saved.profiles then return false end
  for _, key in ipairs(LEGACY_KEYS) do
    if saved[key] ~= nil then return true end
  end
  return false
end

-- Devuelve { profile, char } con lo que el usuario había cambiado. Lo que no se
-- había tocado se omite para que mandan los valores por defecto nuevos (por
-- ejemplo, el resumen en el chat pasa a estar apagado por defecto).
function Migrations.fromLegacy(old)
  local profile = { advisor = {}, echo = {}, macros = {} }
  if old.hidden then profile.advisor.shown = false end
  profile.advisor.position = old.position
  profile.advisor.scale = old.advisorScale
  profile.advisor.locked = old.advisorLocked
  if old.echo then profile.echo.shown = true end
  profile.echo.position = old.echoPosition
  profile.echo.scale = old.echoScale
  if old.macros then profile.macros.auto = true end
  profile.macros.disabled = old.macroDisabled

  local char = {
    fights = old.fights,
    test = old.test,
    specOverride = old.specOverride,
    welcomed = true, -- ya lo usaba: no hace falta darle la bienvenida
  }
  return { profile = profile, char = char }
end

-- Copia values dentro de target (tablas de AceDB) sin sustituir las tablas.
function Migrations.apply(target, values)
  for key, value in pairs(values) do
    if type(value) == "table" and type(target[key]) == "table" then
      Migrations.apply(target[key], value)
    else
      target[key] = value
    end
  end
end
