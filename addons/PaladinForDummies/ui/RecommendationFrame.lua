-- Ventana de recomendación: dos iconos con su porqué en el tooltip.
--   Sello:     el sello para la pelea.
--   Sentencia: el icono de Judgement con el sello que se juzga en la esquina; el
--              tooltip da los pasos antes del pull (core/Plan.lua).
-- Solo muestra lo que le pasan: no decide nada.
local _, ns = ...
ns.UI = ns.UI or {}

local RecommendationFrame = {}
ns.UI.RecommendationFrame = RecommendationFrame

local ICON_SIZE = 36
local QUESTION_MARK = 134400 -- INV_Misc_QuestionMark

local CONFIDENCE_TEXT = {
  mechanic = "Confianza: sale de la mecánica del hechizo",
  consensus = "Confianza: consenso de guías (por medir)",
  measured = "Confianza: medido con tus peleas",
}

local function spellTexture(spellId)
  if C_Spell and C_Spell.GetSpellTexture then
    local ok, icon = pcall(C_Spell.GetSpellTexture, spellId)
    if ok and icon then return icon end
  end
  return QUESTION_MARK
end

-- Nombre traducido del hechizo, solo para mostrarlo (las decisiones van por spellID).
local function spellName(spellId)
  if C_Spell and C_Spell.GetSpellName then
    local ok, name = pcall(C_Spell.GetSpellName, spellId)
    if ok and type(name) == "string" then return name end
  end
  return "spellID " .. tostring(spellId)
end

local STEP_TEXT = {
  apply = function(step) return "Ponte " .. spellName(step.spellId) end,
  judge = function() return "Lanza " .. spellName(ns.Data.Spells.judgement) .. " sobre el objetivo" end,
  switch = function(step) return "Cambia a " .. spellName(step.spellId) .. " para la pelea" end,
}

local function addReason(entry)
  GameTooltip:AddLine(" ")
  GameTooltip:AddLine(entry.why, 1, 1, 1, true)
  GameTooltip:AddLine(CONFIDENCE_TEXT[entry.confidence] or entry.confidence, 0.6, 0.8, 1, true)
end

-- Sello: el tooltip del propio hechizo y debajo el porqué.
local function showSealTooltip(slot)
  local entry = slot.entry
  if not entry then return end
  GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
  GameTooltip:SetSpellByID(entry.spellId)
  addReason(entry)
  GameTooltip:Show()
end

-- Sentencia: los pasos antes del pull y debajo el porqué.
local function showJudgementTooltip(slot)
  local entry = slot.entry
  if not entry then return end
  GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
  GameTooltip:AddLine("Antes del pull")
  for i, step in ipairs(slot.steps or {}) do
    GameTooltip:AddLine(("%d. %s"):format(i, STEP_TEXT[step.action](step)), 1, 0.82, 0, true)
  end
  addReason(entry)
  GameTooltip:Show()
end

local function createSlot(parent, label, onEnter)
  local slot = CreateFrame("Frame", nil, parent)
  slot:SetSize(ICON_SIZE, ICON_SIZE)
  slot.icon = slot:CreateTexture(nil, "ARTWORK")
  slot.icon:SetAllPoints()
  slot.label = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  slot.label:SetPoint("TOP", slot, "BOTTOM", 0, -2)
  slot.label:SetText(label)

  slot:EnableMouse(true)
  slot:RegisterForDrag("LeftButton")
  slot:SetScript("OnDragStart", function() if not parent.locked then parent:StartMoving() end end)
  slot:SetScript("OnDragStop", function() parent:StopMovingOrSizing(); parent:SavePosition() end)
  slot:SetScript("OnEnter", onEnter)
  slot:SetScript("OnLeave", function() GameTooltip:Hide() end)
  return slot
end

-- iconSpellId: el hechizo cuyo icono se muestra (para la Sentencia, Judgement).
local function fill(slot, entry, iconSpellId)
  slot.entry = entry
  if entry then
    slot.icon:SetTexture(spellTexture(iconSpellId or entry.spellId))
    slot.icon:SetDesaturated(false)
  else
    slot.icon:SetTexture(QUESTION_MARK)
    slot.icon:SetDesaturated(true)
  end
  if slot.badge then
    slot.badge:SetShown(entry ~= nil)
    if entry then slot.badge:SetTexture(spellTexture(entry.spellId)) end
  end
end

-- db: tabla donde se guarda la posición (profile.advisor de AceDB).
function RecommendationFrame.create(db)
  local frame = CreateFrame("Frame", "PaladinForDummiesFrame", UIParent, "BackdropTemplate")
  frame:SetSize(ICON_SIZE * 2 + 60, ICON_SIZE + 52)
  frame:SetFrameStrata("MEDIUM")
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(self) if not self.locked then self:StartMoving() end end)
  frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); self:SavePosition() end)

  -- Fondo oscuro con borde para que la ventana se vea siempre.
  if frame.SetBackdrop then
    frame:SetBackdrop({
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true, tileSize = 16, edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    frame:SetBackdropColor(0, 0, 0, 0.75)
  end

  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  frame.title:SetPoint("TOP", frame, "TOP", 0, -6)
  frame.title:SetText("Paladin for Dummies")

  local pos = db.position
  if pos then
    frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
  else
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, -180)
  end

  function frame:SavePosition()
    local ok, point, _, relativePoint, x, y = pcall(self.GetPoint, self)
    if ok and point then
      db.position = { point = point, relativePoint = relativePoint, x = x, y = y }
    end
  end

  frame.seal = createSlot(frame, "Sello", showSealTooltip)
  frame.seal:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -20)
  frame.judgement = createSlot(frame, "Sentencia", showJudgementTooltip)
  -- Icono pequeño del sello que se juzga, en la esquina del icono de Judgement.
  frame.judgement.badge = frame.judgement:CreateTexture(nil, "OVERLAY")
  frame.judgement.badge:SetSize(ICON_SIZE / 2, ICON_SIZE / 2)
  frame.judgement.badge:SetPoint("BOTTOMRIGHT", frame.judgement, "BOTTOMRIGHT", 4, -4)
  frame.judgement:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -20)

  frame.status = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  frame.status:SetPoint("BOTTOM", frame, "BOTTOM", 0, 4)

  function frame:ShowRecommendation(recommendation)
    fill(self.seal, recommendation.seal)
    fill(self.judgement, recommendation.judgement, ns.Data.Spells.judgement)
    self.judgement.steps = ns.Core.Plan.prepull(recommendation)
  end

  -- Línea de estado: "en combate" y la prueba activa, si la hay.
  local function updateStatus(self)
    local parts = {}
    if self.frozen then parts[#parts + 1] = "en combate" end
    if self.test then parts[#parts + 1] = "prueba " .. self.test end
    self.status:SetText(table.concat(parts, " · "))
  end

  function frame:SetFrozen(frozen)
    self.frozen = frozen
    updateStatus(self)
  end

  function frame:SetTest(test)
    self.test = test
    updateStatus(self)
  end

  -- Para /pfd ui: estado de la ventana en texto. Todo con pcall y sin tocar secrets.
  function frame:Describe()
    local function get(method, ...)
      local ok, a, b, c, d, e = pcall(self[method], self, ...)
      if not ok then return "error" end
      local out = {}
      for _, v in ipairs({ a, b, c, d, e }) do
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
    return {
      ("mostrada %s, visible %s, opacidad %s, escala %s"):format(
        get("IsShown"), get("IsVisible"), get("GetAlpha"), get("GetEffectiveScale")),
      ("tamaño %s, posición %s (centro %s)"):format(get("GetSize"), get("GetPoint"), get("GetCenter")),
      ("icono sello: %s | icono Sentencia: %s"):format(
        tostring(self.seal.icon:GetTexture()), tostring(self.judgement.icon:GetTexture())),
    }
  end

  -- Bloqueada: no se arrastra, pero los tooltips siguen funcionando.
  function frame:SetLocked(locked)
    self.locked = locked and true or nil
  end

  -- Cambia la tabla donde se guarda la posición (al cambiar de perfil).
  function frame:UseStore(store)
    db = store
    self:ClearAllPoints()
    local p = db.position
    if p then
      self:SetPoint(p.point, UIParent, p.relativePoint, p.x, p.y)
    else
      self:SetPoint("CENTER", UIParent, "CENTER", 0, -180)
    end
  end

  function frame:ResetPosition()
    db.position = nil
    self:ClearAllPoints()
    self:SetPoint("CENTER", UIParent, "CENTER", 0, -180)
  end

  return frame
end
