-- Copias de Unsealed Wrath (Echo of Command / Echo of Righteousness) en grande,
-- con un aviso que se enciende cuando toca cambiar de sello. EXPERIMENTAL.
--
-- En combate el addon no puede leer auras (son secret). Por eso se usa un
-- AuraContainer de Blizzard (12.1.0, también en Forever): el addon decide el
-- aspecto y el juego rellena y actualiza los datos él mismo, también en combate.
--   - AddAuraSlot + includeSpellIDs: un hueco para un solo hechizo. Filtrar
--     buffs propios por ID está permitido (CanApplyIdentityCandidateFilters).
--   - SetApplicationCount: el número de copias.
--   - SetApplicationBar con minApplications = N: el juego hace
--     statusBar:SetShown(copias >= N), así que el aviso que va dentro de la
--     barra solo aparece cuando toca. La comparación la hace el juego.
-- Detalle en docs/research.md ("Mostrar auras en combate").
local _, ns = ...
ns.UI = ns.UI or {}

local EchoTracker = {}
ns.UI.EchoTracker = EchoTracker

local SIZE = 48
local GAP = 24

-- ready: con cuántas copias toca cambiar (Icy Veins: 3 de Command; volver con 1 de Righteousness).
EchoTracker.ECHOES = {
  { key = "echoCommand", spellId = 1311703, ready = 3, label = "¡CAMBIA!" },
  { key = "echoRighteousness", spellId = 1311704, ready = 1, label = "¡VUELVE!" },
}

-- Construye el contenido de un botón de aura. Todo tiene que ser hijo del botón
-- (el contenedor lo exige). onError recibe los errores, porque el juego llama a
-- esta función en un entorno protegido y si no se perderían.
function EchoTracker.initializer(echo, onError)
  return function(button)
    local ok, err = pcall(function()
      button:SetSize(SIZE, SIZE)

      local icon = button:CreateTexture(nil, "ARTWORK")
      icon:SetAllPoints(button)
      button:SetIcon(icon)

      local count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")
      count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
      button:SetApplicationCount(count, {})

      -- Barra invisible que el juego solo muestra con `ready` copias o más:
      -- sirve de interruptor para el brillo y el texto que lleva dentro.
      local bar = CreateFrame("StatusBar", nil, button)
      bar:SetAllPoints(button)
      bar:SetFrameLevel(button:GetFrameLevel() + 2)
      bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
      bar:GetStatusBarTexture():SetVertexColor(0, 0, 0, 0)

      local glow = bar:CreateTexture(nil, "OVERLAY")
      glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
      glow:SetBlendMode("ADD")
      glow:SetVertexColor(1, 0.85, 0.2)
      glow:SetSize(SIZE * 1.9, SIZE * 1.9)
      glow:SetPoint("CENTER", button, "CENTER")

      local text = bar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
      text:SetPoint("TOP", button, "BOTTOM", 0, -4)
      text:SetText(echo.label)

      button:SetApplicationBar(bar, { minApplications = echo.ready, maxApplications = echo.ready })
    end)
    if not ok and onError then onError(echo.key, err) end
  end
end

local DEFAULT_POSITION = { point = "CENTER", relativePoint = "CENTER", x = 0, y = -80 }

-- Ancla propia (un marco normal, movible) a la que se sujeta el contenedor. El
-- contenedor de Blizzard tiene partes protegidas: no le ponemos scripts, solo lo
-- anclamos a este marco. Con el ancla desbloqueada se ve un recuadro para arrastrar.
local function createAnchor(db, width, height)
  local anchor = CreateFrame("Frame", "PaladinForDummiesEchoAnchor", UIParent, "BackdropTemplate")
  anchor:SetSize(width, height)
  anchor:SetMovable(true)
  anchor:SetClampedToScreen(true)
  anchor:RegisterForDrag("LeftButton")
  anchor:SetScript("OnDragStart", function(self) self:StartMoving() end)
  anchor:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local ok, point, _, relativePoint, x, y = pcall(self.GetPoint, self)
    if ok and point then db.echoPosition = { point = point, relativePoint = relativePoint, x = x, y = y } end
  end)

  if anchor.SetBackdrop then
    anchor:SetBackdrop({
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true, tileSize = 16, edgeSize = 12,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    anchor:SetBackdropColor(0.1, 0.4, 0.8, 0.5)
  end
  anchor.hint = anchor:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  anchor.hint:SetPoint("BOTTOM", anchor, "TOP", 0, 4)
  anchor.hint:SetText("Arrastra para mover · /pfd echo move para fijar")

  function anchor:ApplyPosition()
    local pos = db.echoPosition or DEFAULT_POSITION
    self:ClearAllPoints()
    self:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
  end

  -- Bloqueado: sin fondo, sin texto y sin ratón (no estorba en combate).
  function anchor:SetUnlocked(unlocked)
    self.unlocked = unlocked
    self:EnableMouse(unlocked)
    if self.SetBackdrop then
      self:SetBackdropColor(0.1, 0.4, 0.8, unlocked and 0.5 or 0)
      self:SetBackdropBorderColor(1, 1, 1, unlocked and 1 or 0)
    end
    self.hint:SetShown(unlocked)
  end

  anchor:ApplyPosition()
  anchor:SetUnlocked(false)
  return anchor
end

-- Crea el widget: el ancla y el contenedor con un hueco por cada copia.
-- Devuelve el ancla (que mueve, muestra y oculta el conjunto), o nil y el error
-- si el cliente no lo permite.
function EchoTracker.create(db, onError)
  local ok, result = pcall(function()
    local width, height = #EchoTracker.ECHOES * (SIZE + GAP), SIZE + 40
    local anchor = createAnchor(db, width, height)

    local container = CreateFrame("AuraContainer", "PaladinForDummiesEchoes", anchor, "CustomAuraContainerTemplate")
    container:SetSize(width, height)
    container:SetPoint("CENTER", anchor, "CENTER", 0, 0)
    container:SetUnit("player")
    anchor.container = container

    for i, echo in ipairs(EchoTracker.ECHOES) do
      local frame = container:AddAuraSlot(echo.key, "HELPFUL", {
        candidateFilters = { includeSpellIDs = { [echo.spellId] = true } },
        initializeFrame = EchoTracker.initializer(echo, onError),
      })
      frame:SetPoint("LEFT", container, "LEFT", (i - 1) * (SIZE + GAP), 0)
    end
    return anchor
  end)
  if not ok then return nil, result end
  return result
end
