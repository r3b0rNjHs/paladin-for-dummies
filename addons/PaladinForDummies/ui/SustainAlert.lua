-- Poca vida o poco maná: el icono de Light o de Wisdom con "¡CAMBIA!".
-- El addon no lee tu vida ni tu maná (son secret siempre, sondeo 1): le da al
-- juego una curva (core/Sustain.lua) y el juego devuelve la transparencia del
-- icono (UnitHealthPercent / UnitPowerPercent con curva, SetAlpha admite valores
-- secret). Funciona también en combate. Nada de esto se guarda (regla 4): en
-- db.status solo van datos de diagnóstico (si las funciones existen, si dieron
-- error, si el resultado era secret).
local _, ns = ...
ns.UI = ns.UI or {}
local L = ns.L
local Style = ns.UI.Style
local Sustain = ns.Core.Sustain

local SustainAlert = {}
ns.UI.SustainAlert = SustainAlert

local SIZE = 40
local GAP = 24
local UPDATE_SECONDS = 0.2
local DEFAULT_POINT = { "CENTER", "CENTER", 120, -80 }
local SEAL = { light = "light", wisdom = "wisdom" }

local function spellTexture(spellId)
  if spellId and C_Spell and C_Spell.GetSpellTexture then
    local ok, icon = pcall(C_Spell.GetSpellTexture, spellId)
    if ok and icon then return icon end
  end
  return 134400
end

-- Curva lineal del juego con los puntos de core/Sustain.lua.
local function makeCurve(threshold)
  if not (C_CurveUtil and C_CurveUtil.CreateCurve) then return nil, "no C_CurveUtil.CreateCurve" end
  local ok, curve = pcall(C_CurveUtil.CreateCurve)
  if not ok or not curve then return nil, tostring(curve) end
  if Enum and Enum.LuaCurveType and Enum.LuaCurveType.Linear and curve.SetType then
    pcall(curve.SetType, curve, Enum.LuaCurveType.Linear)
  end
  for _, point in ipairs(Sustain.points(threshold)) do
    local added, err = pcall(curve.AddPoint, curve, point[1], point[2])
    if not added then return nil, tostring(err) end
  end
  return curve
end

local function applyPoint(frame, pos)
  frame:ClearAllPoints()
  if pos then
    frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
  else
    frame:SetPoint(DEFAULT_POINT[1], UIParent, DEFAULT_POINT[2], DEFAULT_POINT[3], DEFAULT_POINT[4])
  end
end

-- db = profile.sustain { shown, health, mana, position }; status = tabla de diagnóstico.
function SustainAlert.create(db, status)
  local frame = CreateFrame("Frame", "PaladinForDummiesSustain", UIParent)
  frame:SetSize(SIZE * 2 + GAP, SIZE + 24)
  frame:SetFrameStrata("MEDIUM")
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
  frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local ok, point, _, relativePoint, x, y = pcall(self.GetPoint, self)
    if ok and point then db.position = { point = point, relativePoint = relativePoint, x = x, y = y } end
  end)
  frame:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" and self.unlocked then self:SetUnlocked(false) end
  end)
  applyPoint(frame, db.position)

  -- Recuadro para moverlo (como el aviso antes del pull).
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

  local slots = {}
  for i, kind in ipairs({ "light", "wisdom" }) do
    local slot = Style.icon(frame, SIZE)
    slot:SetPoint("TOPLEFT", frame, "TOPLEFT", (i - 1) * (SIZE + GAP), 0)
    slot:SetState("recommended")
    slot:EnableMouse(false)
    slot.label = Style.text(slot, "GameFontNormal", "gold")
    slot.label:SetPoint("TOP", slot, "BOTTOM", 0, -3)
    slot.label:SetText(L.SUSTAIN_SWITCH)
    slot:SetAlpha(0)
    slot:Hide()
    slots[kind] = slot
  end
  frame.slots = slots

  local curves = {}
  function frame:SetThresholds(health, mana)
    local err
    curves.light, err = makeCurve(health)
    status.healthCurve = curves.light ~= nil or err
    curves.wisdom, err = makeCurve(mana)
    status.manaCurve = curves.wisdom ~= nil or err
  end
  frame:SetThresholds(db.health, db.mana)

  -- Qué sellos conoces (fuera de combate): solo esos huecos.
  function frame:SetKnown(known)
    local active = {}
    for _, kind in ipairs(Sustain.slots(known)) do active[kind] = true end
    for kind, slot in pairs(slots) do
      slot.known = active[kind] or false
      slot.icon:SetTexture(spellTexture(known[kind .. "SpellId"]))
      slot:SetShown(slot.known or self.unlocked)
    end
  end

  -- El juego evalúa la curva y el resultado va tal cual a SetAlpha: nunca se
  -- compara ni se guarda.
  local function evaluate(kind)
    local slot, curve = slots[kind], curves[kind]
    if not (slot.known and curve) then return end
    local ok, alpha
    if kind == "light" then
      if type(UnitHealthPercent) ~= "function" then status.health = "missing" return end
      ok, alpha = pcall(UnitHealthPercent, "player", true, curve)
    else
      if type(UnitPowerPercent) ~= "function" then status.mana = "missing" return end
      local manaType = Enum and Enum.PowerType and Enum.PowerType.Mana or 0
      ok, alpha = pcall(UnitPowerPercent, "player", manaType, false, curve)
    end
    local key = kind == "light" and "health" or "mana"
    if not ok then status[key] = "error: " .. tostring(alpha) return end
    if status[key] ~= "ok" then
      status[key] = "ok"
      status[key .. "Secret"] = (issecretvalue and issecretvalue(alpha)) and true or false
    end
    local set, err = pcall(slot.SetAlpha, slot, alpha)
    if not set then status[key] = "SetAlpha: " .. tostring(err) end
  end

  local elapsed = 0
  frame:SetScript("OnUpdate", function(self, dt)
    if self.unlocked or not db.shown then return end
    elapsed = elapsed + (type(dt) == "number" and dt or 0)
    if elapsed < UPDATE_SECONDS then return end
    elapsed = 0
    evaluate("light")
    evaluate("wisdom")
  end)

  function frame:SetUnlocked(unlocked)
    self.unlocked = unlocked and true or false
    self:EnableMouse(self.unlocked)
    box:SetShown(self.unlocked)
    for _, slot in pairs(slots) do
      slot:SetShown(slot.known or self.unlocked)
      if self.unlocked then slot:SetAlpha(1) else slot:SetAlpha(0) end
    end
  end

  function frame:UseStore(store)
    db = store
    applyPoint(self, db.position)
    self:SetThresholds(db.health, db.mana)
  end

  function frame:ResetPosition()
    db.position = nil
    applyPoint(self, nil)
  end

  frame:SetShown(db.shown)
  return frame
end
