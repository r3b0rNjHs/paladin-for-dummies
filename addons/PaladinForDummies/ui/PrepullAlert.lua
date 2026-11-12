-- El aviso antes del pull (core/Prepull.lua): una fila de iconos con el sistema
-- de diseño (ui/Style.lua) que SOLO aparece cuando tienes que hacer algo antes
-- de pelear. Si todo está en orden, no hay nada en pantalla.
--   rojo y "!"  te falta (sello, aura, bendición, Righteous Fury)
--   oro         lo que toca (el sello correcto, Exorcism contra no-muertos)
-- El tooltip dice qué hacer y por qué. Solo muestra lo que le pasan.
local _, ns = ...
ns.UI = ns.UI or {}
local L = ns.L
local Style = ns.UI.Style

local PrepullAlert = {}
ns.UI.PrepullAlert = PrepullAlert

local ICON_SIZE = 36
local GAP = 22 -- deja sitio a las etiquetas
local SLOTS = 5
local LABEL_HEIGHT = 14
local DEFAULT_POINT = { "CENTER", "CENTER", 0, -180 }

local CONFIDENCE = {
  mechanic = { color = "blue", text = function() return L.CONF_MECHANIC end },
  consensus = { color = "amber", text = function() return L.CONF_CONSENSUS end },
  measured = { color = "green", text = function() return L.CONF_MEASURED end },
}

local function c(name) return Style.COLORS[name] end

local function swatch(name)
  local col = c(name)
  return ("|TInterface\\Buttons\\WHITE8X8:8:8:0:0:8:8:0:8:0:8:%d:%d:%d|t"):format(
    math.floor(col[1] * 255), math.floor(col[2] * 255), math.floor(col[3] * 255))
end

local function spellTexture(spellId)
  if C_Spell and C_Spell.GetSpellTexture then
    local ok, icon = pcall(C_Spell.GetSpellTexture, spellId)
    if ok and icon then return icon end
  end
  return 134400 -- interrogación
end

-- Nombre del hechizo en el idioma del cliente (las decisiones van por spellID).
local function spellName(spellId)
  if C_Spell and C_Spell.GetSpellName then
    local ok, name = pcall(C_Spell.GetSpellName, spellId)
    if ok and type(name) == "string" then return name end
  end
  return "spellID " .. tostring(spellId)
end

local function gold(text) return Style.color("gold", text) end

local function whyText(entry)
  if entry and entry.ruleId then
    local key = ns.Locales.whyKey(entry.ruleId)
    local text = L[key]
    if text ~= key then return text end
  end
  return entry and entry.why
end

local STEP_TEXT = {
  apply = function(step) return L.STEP_APPLY:format(spellName(step.spellId)) end,
  judge = function() return L.STEP_JUDGE:format(spellName(ns.Data.Spells.judgement)) end,
  switch = function(step) return L.STEP_SWITCH:format(spellName(step.spellId)) end,
}

local function line(text, colorName)
  local col = c(colorName or "text")
  GameTooltip:AddLine(text, col[1], col[2], col[3], true)
end

-- Qué dice el tooltip de cada aviso.
local TOOLTIP = {
  seal = function(alert, frame)
    if alert.state == "missing" then
      line(L.ALERT_SEAL_MISSING:format(gold(spellName(alert.spellId))))
    else
      line(L.ALERT_SEAL_WRONG:format(gold(spellName(alert.spellId))))
    end
    local steps = frame.steps or {}
    if #steps > 0 then
      GameTooltip:AddLine(" ")
      line(L.TIP_BEFORE_PULL, "gold")
      for i, step in ipairs(steps) do line(("%d. %s"):format(i, STEP_TEXT[step.action](step))) end
    end
    local why = whyText(alert.entry)
    if why then
      GameTooltip:AddLine(" ")
      line(L.TIP_WHY, "muted")
      line(why)
      local conf = CONFIDENCE[alert.entry.confidence]
      if conf then line(swatch(conf.color) .. " " .. conf.text(), conf.color) end
    end
  end,
  aura = function(alert) line(L.ALERT_AURA:format(gold(spellName(alert.spellId)))) end,
  blessing = function(alert) line(L.ALERT_BLESSING:format(gold(spellName(alert.spellId)))) end,
  fury = function(alert) line(L.ALERT_FURY:format(gold(spellName(alert.spellId)))) end,
  tip = function(alert) line(L.ALERT_EXORCISM:format(gold(spellName(alert.spellId)))) end,
}

local LABEL = {
  seal = function() return L.ADVISOR_SEAL end,
  aura = function() return L.ALERT_LABEL_AURA end,
  blessing = function() return L.ALERT_LABEL_BLESSING end,
  fury = function() return L.ALERT_LABEL_FURY end,
  tip = function() return L.ALERT_LABEL_TIP end,
}

local function showTooltip(slot)
  local alert = slot.alert
  if not alert then return end
  GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
  GameTooltip:AddLine(spellName(alert.spellId), c("gold")[1], c("gold")[2], c("gold")[3])
  TOOLTIP[alert.kind](alert, slot:GetParent())
  local test = slot:GetParent().test
  if test then line(L.TIP_TEST:format(test), "muted") end
  GameTooltip:Show()
end

local function createSlot(parent)
  local slot = Style.icon(parent, ICON_SIZE)
  slot.label = Style.text(slot, "GameFontNormalSmall", "muted")
  slot.label:SetPoint("TOP", slot, "BOTTOM", 0, -3)
  -- El anillo late (los cuatro lados a la vez) mientras te falta algo.
  local pulses = {}
  for i = 1, 4 do pulses[i] = Style.pulse(slot.ring[i]) end
  slot.pulse = {
    Start = function() for _, p in ipairs(pulses) do p:Start() end end,
    Stop = function() for _, p in ipairs(pulses) do p:Stop() end end,
  }
  slot:EnableMouse(true)
  slot:SetScript("OnEnter", showTooltip)
  slot:SetScript("OnLeave", function() GameTooltip:Hide() end)
  slot:Hide()
  return slot
end

local function applyPoint(frame, pos)
  frame:ClearAllPoints()
  if pos then
    frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
  else
    frame:SetPoint(DEFAULT_POINT[1], UIParent, DEFAULT_POINT[2], DEFAULT_POINT[3], DEFAULT_POINT[4])
  end
end

-- db: tabla donde se guarda la posición (profile.advisor de AceDB).
function PrepullAlert.create(db)
  local frame = CreateFrame("Frame", "PaladinForDummiesFrame", UIParent)
  frame:SetSize(SLOTS * ICON_SIZE + (SLOTS - 1) * GAP, ICON_SIZE + LABEL_HEIGHT + 3)
  frame:SetFrameStrata("MEDIUM")
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
  frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); self:SavePosition() end)
  frame:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" and self.unlocked then self:SetUnlocked(false) end
  end)
  applyPoint(frame, db.position)

  function frame:SavePosition()
    local ok, point, _, relativePoint, x, y = pcall(self.GetPoint, self)
    if ok and point then db.position = { point = point, relativePoint = relativePoint, x = x, y = y } end
  end

  -- Recuadro para moverlo (sin avisos no hay nada que arrastrar).
  local box = CreateFrame("Frame", nil, frame, "BackdropTemplate")
  box:SetAllPoints(frame)
  box:SetFrameStrata("DIALOG")
  if box.SetBackdrop then
    box:SetBackdrop({
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true, tileSize = 16, edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    box:SetBackdropColor(0.1, 0.4, 0.8, 0.5)
  end
  box.hint = Style.text(box, "GameFontNormal", "text")
  box.hint:SetPoint("BOTTOM", box, "TOP", 0, 4)
  box.hint:SetText(L.ALERT_DRAG_HINT)
  box:Hide()

  frame.slots = {}
  for i = 1, SLOTS do
    local slot = createSlot(frame)
    slot:SetPoint("TOPLEFT", frame, "TOPLEFT", (i - 1) * (ICON_SIZE + GAP), 0)
    frame.slots[i] = slot
  end

  function frame:ShowAlerts(alerts, recommendation)
    self.alerts = alerts or {}
    self.steps = recommendation and ns.Core.Plan.prepull(recommendation) or {}
    for i, slot in ipairs(self.slots) do
      local alert = self.alerts[i]
      slot.alert = alert
      if alert then
        slot.icon:SetTexture(spellTexture(alert.spellId))
        slot:SetState(alert.state)
        slot.label:SetText(LABEL[alert.kind]())
        slot:Show()
        if alert.state == "missing" then slot.pulse:Start() else slot.pulse:Stop() end
      else
        slot.pulse:Stop()
        slot:Hide()
      end
    end
  end

  function frame:HasAlerts() return #(self.alerts or {}) > 0 end

  function frame:SetFrozen(frozen) self.frozen = frozen end
  function frame:SetTest(test) self.test = test end

  -- shown: la opción "Mostrar". Se ve con avisos y fuera de combate, o al moverlo.
  function frame:ApplyVisibility(shown)
    if self.unlocked or (shown and not self.frozen and self:HasAlerts()) then
      self:Show()
    else
      self:Hide()
    end
  end

  function frame:SetUnlocked(unlocked)
    self.unlocked = unlocked and true or false
    self:EnableMouse(self.unlocked)
    box:SetShown(self.unlocked)
    if self.onVisibilityChange then self.onVisibilityChange() end
  end

  -- Para /pfd ui: estado del aviso en texto. Todo con pcall y sin tocar secrets.
  function frame:Describe()
    local function get(method)
      local ok, a, b, cc, d, e = pcall(self[method], self)
      if not ok then return "error" end
      local out = {}
      for _, v in ipairs({ a, b, cc, d, e }) do
        if issecretvalue and issecretvalue(v) then
          out[#out + 1] = "<secret>"
        elseif type(v) == "number" then
          out[#out + 1] = ("%g"):format(math.floor(v * 100 + 0.5) / 100)
        elseif type(v) ~= "table" then
          out[#out + 1] = tostring(v)
        end
      end
      return table.concat(out, " ")
    end
    local kinds = {}
    for _, alert in ipairs(self.alerts or {}) do kinds[#kinds + 1] = alert.kind .. ":" .. alert.state end
    return {
      ("mostrado %s, visible %s, escala %s"):format(get("IsShown"), get("IsVisible"), get("GetEffectiveScale")),
      ("posición %s"):format(get("GetPoint")),
      ("avisos: %s"):format(#kinds > 0 and table.concat(kinds, ", ") or "ninguno"),
    }
  end

  function frame:UseStore(store)
    db = store
    applyPoint(self, db.position)
  end

  function frame:ResetPosition()
    db.position = nil
    applyPoint(self, nil)
  end

  return frame
end
