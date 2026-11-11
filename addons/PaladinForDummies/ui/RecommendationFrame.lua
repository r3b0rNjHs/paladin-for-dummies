-- Ventana de recomendación: dos iconos (sello y Sentencia) con su porqué en el tooltip.
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

local function showTooltip(slot)
  local entry = slot.entry
  if not entry then return end
  GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
  GameTooltip:SetSpellByID(entry.spellId)
  GameTooltip:AddLine(" ")
  GameTooltip:AddLine(entry.why, 1, 1, 1, true)
  GameTooltip:AddLine(CONFIDENCE_TEXT[entry.confidence] or entry.confidence, 0.6, 0.8, 1, true)
  GameTooltip:Show()
end

local function createSlot(parent, label)
  local slot = CreateFrame("Frame", nil, parent)
  slot:SetSize(ICON_SIZE, ICON_SIZE)
  slot.icon = slot:CreateTexture(nil, "ARTWORK")
  slot.icon:SetAllPoints()
  slot.label = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  slot.label:SetPoint("TOP", slot, "BOTTOM", 0, -2)
  slot.label:SetText(label)

  slot:EnableMouse(true)
  slot:RegisterForDrag("LeftButton")
  slot:SetScript("OnDragStart", function() parent:StartMoving() end)
  slot:SetScript("OnDragStop", function() parent:StopMovingOrSizing(); parent:SavePosition() end)
  slot:SetScript("OnEnter", showTooltip)
  slot:SetScript("OnLeave", function() GameTooltip:Hide() end)
  return slot
end

local function fill(slot, entry)
  slot.entry = entry
  if entry then
    slot.icon:SetTexture(spellTexture(entry.spellId))
    slot.icon:SetDesaturated(false)
  else
    slot.icon:SetTexture(QUESTION_MARK)
    slot.icon:SetDesaturated(true)
  end
end

-- db: tabla de SavedVariables donde se guarda la posición.
function RecommendationFrame.create(db)
  local frame = CreateFrame("Frame", "PaladinForDummiesFrame", UIParent, "BackdropTemplate")
  frame:SetSize(ICON_SIZE * 2 + 60, ICON_SIZE + 52)
  frame:SetFrameStrata("MEDIUM")
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
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

  frame.seal = createSlot(frame, "Sello")
  frame.seal:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -20)
  frame.judgement = createSlot(frame, "Sentencia")
  frame.judgement:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -20)

  frame.status = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  frame.status:SetPoint("BOTTOM", frame, "BOTTOM", 0, 4)

  function frame:ShowRecommendation(recommendation)
    fill(self.seal, recommendation.seal)
    fill(self.judgement, recommendation.judgement)
  end

  function frame:SetFrozen(frozen)
    self.status:SetText(frozen and "en combate" or "")
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

  function frame:ResetPosition()
    db.position = nil
    self:ClearAllPoints()
    self:SetPoint("CENTER", UIParent, "CENTER", 0, -180)
  end

  return frame
end
