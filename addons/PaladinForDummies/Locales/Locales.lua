-- Textos traducibles. Cada idioma registra una tabla { CLAVE = "texto" } y ns.L
-- devuelve el texto del idioma activo; si falta, el inglés; si tampoco está, la
-- propia clave (así un texto sin traducir se nota pero no rompe nada).
-- El idioma se elige en las opciones: automático (el del cliente), inglés o
-- español. No se usa AceLocale porque solo sigue el idioma del cliente.
-- Tono (Jorge, 12 nov: "toques satíricos", nos llamamos *for Dummies*): con el
-- tono "fun", si el idioma activo tiene CLAVE_FUN se usa esa variante. Nunca se
-- toma el chiste de otro idioma. Los avisos importantes no tienen variante.
local _, ns = ...

local Locales = { tables = {}, active = "enUS", tone = "fun" }
ns.Locales = Locales

-- Variantes de un idioma que comparten traducción.
local ALIASES = { esMX = "esES" }

function Locales.register(code, strings)
  Locales.tables[code] = strings
end

-- setting: "auto", "enUS" o "esES". clientLocale: GetLocale().
function Locales.resolve(setting, clientLocale)
  local code = (setting and setting ~= "auto") and setting or clientLocale
  code = ALIASES[code] or code
  if not Locales.tables[code] then code = "enUS" end
  return code
end

function Locales.use(code)
  Locales.active = code
end

-- "fun" (por defecto) o "plain".
function Locales.setTone(tone)
  Locales.tone = (tone == "plain") and "plain" or "fun"
end

ns.L = setmetatable({}, {
  __index = function(_, key)
    local active = Locales.tables[Locales.active]
    local text
    if Locales.tone == "fun" and active then text = active[key .. "_FUN"] end
    if text == nil then text = active and active[key] end
    if text == nil then
      local english = Locales.tables.enUS
      text = english and english[key]
    end
    return text or key
  end,
})
