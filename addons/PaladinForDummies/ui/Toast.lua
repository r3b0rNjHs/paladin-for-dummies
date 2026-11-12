-- Aviso pequeño del modo entrenador: aparece arriba, en el centro, unos segundos
-- y se desvanece solo. Con un clic abre la guía. Sistema de diseño (ui/Style.lua).
local _, ns = ...
ns.UI = ns.UI or {}
local Style = ns.UI.Style

local Toast = {}
ns.UI.Toast = Toast

local WIDTH = 380
local VISIBLE_SECONDS = 8

function Toast.create(onClick)
  local frame = CreateFrame("Frame", "PaladinForDummiesToast", UIParent, "BackdropTemplate")
  frame:SetSize(WIDTH, 64)
  frame:SetPoint("TOP", UIParent, "TOP", 0, -140)
  frame:SetFrameStrata("HIGH")
  if frame.SetBackdrop then
    frame:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    frame:SetBackdropColor(0.04, 0.04, 0.05, 0.88)
    frame:SetBackdropBorderColor(0, 0, 0, 1)
  end

  -- Barra dorada a la izquierda (sistema de diseño: oro = lo que hay que mirar).
  local bar = frame:CreateTexture(nil, "ARTWORK")
  bar:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
  bar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 6)
  bar:SetWidth(3)
  local gold = Style.COLORS.gold
  bar:SetColorTexture(gold[1], gold[2], gold[3], 1)

  frame.title = Style.text(frame, "GameFontNormal", "gold")
  frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -8)
  frame.body = Style.text(frame, "GameFontHighlight", "text")
  frame.body:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -4)
  frame.body:SetWidth(WIDTH - 28)
  frame.body:SetJustifyH("LEFT")
  frame.hint = Style.text(frame, "GameFontDisableSmall", "muted")
  frame.hint:SetPoint("TOPLEFT", frame.body, "BOTTOMLEFT", 0, -4)

  -- Se desvanece solo al cabo de unos segundos.
  local fade = frame:CreateAnimationGroup()
  local out = fade:CreateAnimation("Alpha")
  out:SetFromAlpha(1)
  out:SetToAlpha(0)
  out:SetStartDelay(VISIBLE_SECONDS)
  out:SetDuration(1)
  fade:SetScript("OnFinished", function() frame:Hide() end)

  frame:EnableMouse(true)
  frame:SetScript("OnMouseUp", function(self)
    fade:Stop()
    self:Hide()
    if onClick then onClick() end
  end)

  function frame:Present(title, body, hint)
    self.title:SetText(title)
    self.body:SetText(body)
    self.hint:SetText(hint or "")
    local function heightOf(fs, default)
      local ok, h = pcall(fs.GetStringHeight, fs)
      return (ok and type(h) == "number") and h or default
    end
    self:SetHeight(16 + heightOf(self.title, 14) + heightOf(self.body, 14) + heightOf(self.hint, 10) + 12)
    fade:Stop()
    self:SetAlpha(1)
    self:Show()
    fade:Play()
  end

  frame:Hide()
  return frame
end
