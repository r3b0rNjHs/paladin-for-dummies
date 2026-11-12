-- Texto del informe de errores (/pfd report): la configuración, los datos y los
-- últimos errores, para que alguien que no es Jorge pueda adjuntarlo al avisar
-- de un fallo. Va en inglés a propósito: lo lee quien mantiene el addon.
-- Lua puro: sin dependencias de WoW (la fecha llega como función).
local _, ns = ...
ns.Core = ns.Core or {}

local Report = {}
ns.Core.Report = Report

local MAX_ERRORS = 10

local function onOff(value) return value and "on" or "off" end

local function sortedKeys(t)
  local keys = {}
  for k in pairs(t or {}) do keys[#keys + 1] = k end
  table.sort(keys)
  return keys
end

function Report.build(i)
  local lines = {}
  local function add(...) lines[#lines + 1] = table.concat({ ... }) end
  local c = i.client or {}

  add(("Paladin for Dummies %s | client %s (%s, toc %s) | locale %s, language %s"):format(
    tostring(i.addonVersion), tostring(c.version), tostring(c.build), tostring(c.toc),
    tostring(i.locale), tostring(i.language)))
  add(("Level %s, spec %s (%s), weapon %s s, spell power %s"):format(
    tostring(i.level), tostring(i.spec), tostring(i.specSource), tostring(i.weaponSpeed), tostring(i.spellPower)))

  add("Known ranks:")
  for _, key in ipairs(sortedKeys(i.ranks)) do
    local ids = {}
    for _, id in ipairs(i.ranks[key]) do ids[#ids + 1] = tostring(id) end
    add("  ", key, ": ", table.concat(ids, ", "))
  end

  local s = i.settings or {}
  add(("Settings: advisor=%s echo=%s macros=%s chatSummary=%s devMode=%s"):format(
    onOff(s.advisor), onOff(s.echo), onOff(s.macros), onOff(s.chatSummary), onOff(s.devMode)))

  local fights = ("Fights: %d"):format(i.fightCount or 0)
  if i.commandPerMinute then fights = fights .. (" | Seal of Command: %s procs/min"):format(tostring(i.commandPerMinute)) end
  add(fights)
  if i.lastFight then add("Last fight: ", i.lastFight) end

  local errors = i.errors or {}
  if #errors == 0 then
    add("Errors: none")
  else
    add(("Errors (last %d of %d):"):format(math.min(#errors, MAX_ERRORS), #errors))
    for n = math.max(1, #errors - MAX_ERRORS + 1), #errors do
      local e = errors[n]
      add("  ", i.date(e.time), " | ", tostring(e.context), " | ", tostring(e.message))
    end
  end
  return table.concat(lines, "\n")
end
