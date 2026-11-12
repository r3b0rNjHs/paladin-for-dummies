-- El asesor: dos iconos con el sistema de diseño (ui/Style.lua) y su porqué en
-- el tooltip.
--   Sello:     el sello para la pelea, con el anillo de oro de "recomendado".
--   Sentencia: el icono de Judgement con el sello que se juzga en la insignia;
--              el tooltip da los pasos antes del pull (core/Plan.lua).
-- Sin fondo ni título: solo iconos y una etiqueta pequeña debajo. Cuándo se ve
-- lo decide core/HudState.lua (atenuado sin objetivo, oculto en combate).
-- Solo muestra lo que le pasan: no decide nada.
local _, ns = ...
ns.UI = ns.UI or {}
local L = ns.L
local Style = ns.UI.Style

local RecommendationFrame = {}
ns.UI.RecommendationFrame = RecommendationFrame

local ICON_SIZE = 36
local GAP = 6
local LABEL_HEIGHT = 14
local QUESTION_MARK = 134400 -- INV_Misc_QuestionMark
local DEFAULT_POINT = { "CENTER", "CENTER", 0, -180 }

-- Color de cada nivel de confianza (sistema de diseño: verde = medido por ti).
local CONFIDENCE = {
  mechanic = { color = "blue", text = function() return L.CONF_MECHANIC end },
  consensus = { color = "amber", text = function() return L.CONF_CONSENSUS end },
  measured = { color = "green", text = function() return L.CONF_MEASURED end },
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
  apply = function(step) return L.STEP_APPLY:format(spellName(step.spellId)) end,
  judge = function() return L.STEP_JUDGE:format(spellName(ns.Data.Spells.judgement)) end,
  switch = function(step) return L.STEP_SWITCH:format(spellName(step.spellId)) end,
}

local function c(name) return Style.COLORS[name] end

local function addReason(entry, test)
  GameTooltip:AddLine(" ")
  GameTooltip:AddLine(L.TIP_WHY, c("muted")[1], c("muted")[2], c("muted")[3])
  GameTooltip:AddLine(entry.why, c("text")[1], c("text")[2], c("text")[3], true)
  local conf = CONFIDENCE[entry.confidence]
  if conf then
    local color = c(conf.color)
    GameTooltip:AddLine("● " .. conf.text(), color[1], color[2], color[3], true)
  end
  if test then
    GameTooltip:AddLine(L.TIP_TEST:format(test), c("muted")[1], c("muted")[2], c("muted")[3])
  end
end

local function showEmptyTooltip(slot)
  GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
  GameTooltip:AddLine(L.TIP_NO_ADVICE, c("muted")[1], c("muted")[2], c("muted")[3], true)
  GameTooltip:Show()
end

-- Sello: el tooltip del propio hechizo y debajo el porqué.
local function showSealTooltip(slot)
  local entry = slot.entry
  if not entry then return showEmptyTooltip(slot) end
  GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
  GameTooltip:SetSpellByID(entry.spellId)
  addReason(entry, slot:GetParent().test)
  GameTooltip:Show()
end

-- Sentencia: los pasos antes del pull y debajo el porqué.
local function showJudgementTooltip(slot)
  local entry = slot.entry
  if not entry then return showEmptyTooltip(slot) end
  GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
  GameTooltip:AddLine(L.TIP_BEFORE_PULL, c("gold")[1], c("gold")[2], c("gold")[3])
  for i, step in ipairs(slot.steps or {}) do
    GameTooltip:AddLine(("%d. %s"):format(i, STEP_TEXT[step.action](step)), c("text")[1], c("text")[2], c("text")[3], true)
  end
  addReason(entry, slot:GetParent().test)
  GameTooltip:Show()
end

local function createSlot(parent, label, onEnter, withBadge)
  local slot = Style.icon(parent, ICON_SIZE, withBadge)
  slot.label = Style.text(slot, "GameFontNormalSmall", "muted")
  slot.label:SetPoint("TOP", slot, "BOTTOM", 0, -3)
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
local function fill(slot, entry, iconSpellId, state)
  slot.entry = entry
  if entry then
    slot.icon:SetTexture(spellTexture(iconSpellId or entry.spellId))
    slot:SetState(state or "normal")
  else
    slot.icon:SetTexture(QUESTION_MARK)
    slot:SetState("normal")
    slot.icon:SetDesaturated(true)
  end
  if slot.badge then
    slot.badge:SetShown(entry ~= nil)
    if entry then slot.badge.icon:SetTexture(spellTexture(entry.spellId)) end
  end
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
function RecommendationFrame.create(db)
  local frame = CreateFrame("Frame", "PaladinForDummiesFrame", UIParent)
  frame:SetSize(ICON_SIZE * 2 + GAP, ICON_SIZE + LABEL_HEIGHT + 3)
  frame:SetFrameStrata("MEDIUM")
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)

  applyPoint(frame, db.position)

  function frame:SavePosition()
    local ok, point, _, relativePoint, x, y = pcall(self.GetPoint, self)
    if ok and point then
      db.position = { point = point, relativePoint = relativePoint, x = x, y = y }
    end
  end

  frame.seal = createSlot(frame, L.ADVISOR_SEAL, showSealTooltip)
  frame.seal:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
  frame.judgement = createSlot(frame, L.ADVISOR_JUDGEMENT, showJudgementTooltip, true)
  frame.judgement:SetPoint("TOPLEFT", frame.seal, "TOPRIGHT", GAP, 0)

  function frame:ShowRecommendation(recommendation)
    fill(self.seal, recommendation.seal, nil, "recommended")
    fill(self.judgement, recommendation.judgement, ns.Data.Spells.judgement, "normal")
    self.judgement.steps = ns.Core.Plan.prepull(recommendation)
  end

  -- En combate la recomendación está congelada (regla 1). La visibilidad la
  -- da HudState a través de ApplyVisibility.
  function frame:SetFrozen(frozen)
    self.frozen = frozen
  end

  -- La prueba activa (/pfd test) se ve en el tooltip.
  function frame:SetTest(test)
    self.test = test
  end

  -- shown: la opción "Mostrar"; alpha: la de core/HudState.lua (0 = oculto).
  function frame:ApplyVisibility(shown, alpha)
    if not shown or alpha <= 0 then
      self:Hide()
    else
      self:SetAlpha(alpha)
      self:Show()
    end
  end

  -- Para /pfd ui: estado de la ventana en texto. Todo con pcall y sin tocar secrets.
  function frame:Describe()
    local function get(method, ...)
      local ok, a, b, cc, d, e = pcall(self[method], self, ...)
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
    applyPoint(self, db.position)
  end

  function frame:ResetPosition()
    db.position = nil
    applyPoint(self, nil)
  end

  return frame
end
