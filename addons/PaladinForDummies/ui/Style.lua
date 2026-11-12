-- Sistema de diseño del addon (docs/product-plan.md, apartado 3): colores con
-- significado, iconos con el mismo aspecto y estados, anillos y latidos. Todo
-- lo que dibuja el addon pasa por aquí para que se vea de la misma familia.
local _, ns = ...
ns.UI = ns.UI or {}

local Style = {}
ns.UI.Style = Style

-- Colores (r, g, b de 0 a 1).
Style.COLORS = {
  gold = { 0.949, 0.757, 0.306 },   -- #F2C14E: lo que hay que hacer ya
  pink = { 0.957, 0.549, 0.729 },   -- #F48CBA: la marca
  red = { 0.898, 0.282, 0.302 },    -- #E5484D: falta
  amber = { 0.961, 0.647, 0.141 },  -- #F5A524: caduca o no es lo previsto
  green = { 0.275, 0.655, 0.345 },  -- #46A758: bien hecho
  blue = { 0.612, 0.765, 0.941 },   -- #9CC3F0: información
  text = { 0.910, 0.902, 0.890 },   -- #E8E6E3
  muted = { 0.659, 0.635, 0.604 },  -- #A8A29A
}
Style.BACKGROUND_ALPHA = 0.65

-- Código de color para textos ("|cffRRGGBB").
function Style.hex(name)
  local c = Style.COLORS[name] or Style.COLORS.text
  return ("|cff%02x%02x%02x"):format(math.floor(c[1] * 255 + 0.5), math.floor(c[2] * 255 + 0.5), math.floor(c[3] * 255 + 0.5))
end

function Style.color(name, text)
  return Style.hex(name) .. tostring(text) .. "|r"
end

-- Estados de un icono: color del anillo, si va en gris y si lleva la marca "!".
Style.STATES = {
  normal = {},
  recommended = { ring = "gold" },
  missing = { ring = "red", desaturate = true, marker = true },
  expiring = { ring = "amber" },
}

-- Movimiento reducido (opción del jugador): sin latidos.
Style.reduceMotion = false

-- Recorte del borde que traen los iconos del juego.
local CROP = { 0.08, 0.92, 0.08, 0.92 }
local RING = 2

-- Anillo de color alrededor de un marco: cuatro bandas de `thickness` px.
function Style.ring(frame, thickness, layer)
  thickness = thickness or RING
  local ring = {}
  local function band()
    local t = frame:CreateTexture(nil, layer or "OVERLAY")
    t:SetColorTexture(1, 1, 1, 1)
    ring[#ring + 1] = t
    return t
  end
  local top, bottom, left, right = band(), band(), band(), band()
  top:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", -thickness, 0)
  top:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", thickness, 0)
  top:SetHeight(thickness)
  bottom:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", -thickness, 0)
  bottom:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", thickness, 0)
  bottom:SetHeight(thickness)
  left:SetPoint("TOPRIGHT", frame, "TOPLEFT", 0, 0)
  left:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 0, 0)
  left:SetWidth(thickness)
  right:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, 0)
  right:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, 0)
  right:SetWidth(thickness)

  function ring.SetColor(_, name)
    local c = Style.COLORS[name] or Style.COLORS.gold
    for _, t in ipairs(ring) do t:SetVertexColor(c[1], c[2], c[3], 1) end
  end
  function ring.SetShown(_, shown)
    for _, t in ipairs(ring) do t:SetShown(shown) end
  end
  return ring
end

-- Latido suave en bucle (para "¡CAMBIA!" y lo que falta antes del pull).
-- Devuelve el grupo de animación; no hace nada con movimiento reducido.
function Style.pulse(region)
  local group = region:CreateAnimationGroup()
  group:SetLooping("BOUNCE")
  local fade = group:CreateAnimation("Alpha")
  fade:SetFromAlpha(1)
  fade:SetToAlpha(0.45)
  fade:SetDuration(0.6)
  fade:SetSmoothing("IN_OUT")
  function group.Start(self)
    if Style.reduceMotion then self:Stop() else self:Play() end
  end
  return group
end

-- Texto con la fuente del juego y contorno.
function Style.text(parent, template, colorName)
  local fs = parent:CreateFontString(nil, "OVERLAY", template or "GameFontNormalSmall")
  local c = Style.COLORS[colorName or "text"]
  fs:SetTextColor(c[1], c[2], c[3])
  fs:SetShadowOffset(1, -1)
  fs:SetShadowColor(0, 0, 0, 1)
  return fs
end

-- Icono: borde negro de 1 px, icono recortado, anillo de estado, marca "!" y
-- una insignia opcional en la esquina inferior derecha.
function Style.icon(parent, size, withBadge)
  local frame = CreateFrame("Frame", nil, parent)
  frame:SetSize(size, size)

  frame.border = frame:CreateTexture(nil, "BACKGROUND")
  frame.border:SetAllPoints(frame)
  frame.border:SetColorTexture(0, 0, 0, 1)

  frame.icon = frame:CreateTexture(nil, "ARTWORK")
  frame.icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
  frame.icon:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
  frame.icon:SetTexCoord(CROP[1], CROP[2], CROP[3], CROP[4])

  frame.ring = Style.ring(frame)
  frame.ring:SetShown(false)

  -- Marca "!" de lo que falta: un círculo rojo arriba a la derecha.
  frame.marker = CreateFrame("Frame", nil, frame)
  frame.marker:SetSize(14, 14)
  frame.marker:SetPoint("CENTER", frame, "TOPRIGHT", -1, -1)
  frame.marker.dot = frame.marker:CreateTexture(nil, "OVERLAY")
  frame.marker.dot:SetAllPoints(frame.marker)
  frame.marker.dot:SetColorTexture(Style.COLORS.red[1], Style.COLORS.red[2], Style.COLORS.red[3], 1)
  -- Máscara redonda (la de los retratos del juego) para que sea un círculo.
  local mask = frame.marker:CreateMaskTexture()
  mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
  mask:SetAllPoints(frame.marker)
  frame.marker.dot:AddMaskTexture(mask)
  frame.marker.text = Style.text(frame.marker, "GameFontHighlightSmall", "text")
  frame.marker.text:SetPoint("CENTER", frame.marker, "CENTER", 0, 0)
  frame.marker.text:SetText("!")
  frame.marker:Hide()

  if withBadge then
    local badge = CreateFrame("Frame", nil, frame)
    badge:SetSize(math.floor(size / 2), math.floor(size / 2))
    badge:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 4, -4)
    badge:SetFrameLevel(frame:GetFrameLevel() + 2)
    badge.border = badge:CreateTexture(nil, "BACKGROUND")
    badge.border:SetAllPoints(badge)
    badge.border:SetColorTexture(0, 0, 0, 1)
    badge.icon = badge:CreateTexture(nil, "ARTWORK")
    badge.icon:SetPoint("TOPLEFT", badge, "TOPLEFT", 1, -1)
    badge.icon:SetPoint("BOTTOMRIGHT", badge, "BOTTOMRIGHT", -1, 1)
    badge.icon:SetTexCoord(CROP[1], CROP[2], CROP[3], CROP[4])
    frame.badge = badge
  end

  function frame:SetState(name)
    local state = Style.STATES[name] or Style.STATES.normal
    self.state = name
    self.ring:SetShown(state.ring ~= nil)
    if state.ring then self.ring:SetColor(state.ring) end
    self.icon:SetDesaturated(state.desaturate and true or false)
    self.marker:SetShown(state.marker and true or false)
  end

  frame:SetState("normal")
  return frame
end
