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
local GLOW = 1.9 -- el brillo de "¡CAMBIA!" es 1,9 veces el icono
local TEXT_HEIGHT = 26 -- texto del aviso debajo del icono
-- Margen para que el brillo quepa dentro del recuadro de mover.
local PAD = math.ceil(SIZE * (GLOW - 1) / 2) + 4

-- ready: con cuántas copias toca cambiar (Icy Veins: 3 de Command; volver con 1 de Righteousness).
-- switchTo: el sello al que hay que ir (su icono es el que se ve; Jorge, 12 nov).
EchoTracker.ECHOES = {
  { key = "echoCommand", spellId = 1311703, ready = 3, labelKey = "ECHO_SWITCH", switchTo = 21084 },      -- a Righteousness
  { key = "echoRighteousness", spellId = 1311704, ready = 1, labelKey = "ECHO_BACK", switchTo = 20375 }, -- a Command
}

-- Icono del sello al que hay que cambiar, o nil si no se puede leer.
function EchoTracker.destinationIcon(echo, getTexture)
  if not (echo.switchTo and getTexture) then return nil end
  local ok, icon = pcall(getTexture, echo.switchTo)
  if ok and icon then return icon end
  return nil
end

local function spellTexture()
  return C_Spell and C_Spell.GetSpellTexture
end

-- Construye el contenido de un botón de aura. Todo tiene que ser hijo del botón
-- (el contenedor lo exige). onError recibe los errores, porque el juego llama a
-- esta función en un entorno protegido y si no se perderían.
-- Qué pasos de la construcción se completaron, por copia (para /pfd echo debug).
EchoTracker.progress = {}

function EchoTracker.initializer(echo, onError)
  return function(button)
    local progress = {}
    EchoTracker.progress[echo.key] = progress
    EchoTracker.buttons = EchoTracker.buttons or {}
    EchoTracker.buttons[echo.key] = button
    local ok, err = pcall(function()
      button:SetSize(SIZE, SIZE)

      -- El juego pinta el icono del aura (el sello que llevas) en `auraIcon`.
      -- Si se puede leer el del sello al que hay que ir, ese es el que se ve y
      -- el del aura queda invisible.
      -- Sistema de diseño (ui/Style.lua): borde negro de 1 px e icono recortado.
      local border = button:CreateTexture(nil, "BACKGROUND")
      border:SetAllPoints(button)
      border:SetColorTexture(0, 0, 0, 1)
      local auraIcon = button:CreateTexture(nil, "ARTWORK")
      auraIcon:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
      auraIcon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
      auraIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      button:SetIcon(auraIcon)
      local destination = EchoTracker.destinationIcon(echo, spellTexture())
      if destination then
        auraIcon:SetAlpha(0)
        local icon = button:CreateTexture(nil, "ARTWORK", nil, 1)
        icon:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
        icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        icon:SetTexture(destination)
      end
      progress.icon = true
      progress.destinationIcon = destination and true or false

      local count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")
      count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
      button:SetApplicationCount(count, {})
      progress.count = true
      button.pfdCount = count

      -- Barra invisible que el juego solo muestra con `ready` copias o más:
      -- sirve de interruptor para el brillo y el texto que lleva dentro.
      local bar = CreateFrame("StatusBar", nil, button)
      bar:SetAllPoints(button)
      bar:SetFrameLevel(button:GetFrameLevel() + 2)
      bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
      bar:GetStatusBarTexture():SetVertexColor(0, 0, 0, 0)

      -- Anillo de oro (sistema de diseño) y un halo suave que late.
      local Style = ns.UI.Style
      local ring = Style.ring(bar, 2)
      ring:SetColor("gold")
      local gold = Style.COLORS.gold
      local glow = bar:CreateTexture(nil, "OVERLAY")
      glow:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
      glow:SetBlendMode("ADD")
      glow:SetVertexColor(gold[1], gold[2], gold[3])
      glow:SetSize(SIZE * GLOW, SIZE * GLOW)
      glow:SetPoint("CENTER", button, "CENTER")
      -- Sin scripts en la barra (la maneja el juego): el latido corre siempre y
      -- solo se ve cuando el juego muestra la barra.
      Style.pulse(glow):Start()

      local text = Style.text(bar, "GameFontNormalLarge", "gold")
      text:SetPoint("TOP", button, "BOTTOM", 0, -4)
      text:SetText(ns.L[echo.labelKey])

      button:SetApplicationBar(bar, { minApplications = echo.ready, maxApplications = echo.ready })
      progress.bar = true
      button.pfdBar = bar
      button.pfdText = text
    end)
    progress.error = (not ok) and tostring(err) or nil
    if not ok and onError then onError(echo.key, err) end
  end
end

local DEFAULT_POSITION = { point = "CENTER", relativePoint = "CENTER", x = 0, y = -80 }
-- Tamaño del recuadro hasta la v0.9.2 (dos huecos en fila): las posiciones
-- guardadas entonces son de una esquina de un recuadro de este tamaño.
local LEGACY_WIDTH, LEGACY_HEIGHT = 144, 88

-- Convierte una posición guardada por una esquina o un lado (lo que da GetPoint
-- tras arrastrar) en la del centro de un recuadro de width x height. Así la
-- posición no se mueve aunque cambie el tamaño del recuadro.
function EchoTracker.toCenter(pos, width, height)
  if type(pos) ~= "table" or type(pos.point) ~= "string"
    or type(pos.x) ~= "number" or type(pos.y) ~= "number" then return nil end
  local x, y = pos.x, pos.y
  if pos.point:find("LEFT") then x = x + width / 2 elseif pos.point:find("RIGHT") then x = x - width / 2 end
  if pos.point:find("TOP") then y = y - height / 2 elseif pos.point:find("BOTTOM") then y = y + height / 2 end
  return { point = "CENTER", relativePoint = pos.relativePoint or pos.point, x = x, y = y }
end

-- Ancla propia (un marco normal, movible) a la que se sujeta el contenedor. El
-- contenedor de Blizzard tiene partes protegidas: no le ponemos scripts, solo lo
-- anclamos a este marco. Con el ancla desbloqueada se ve un recuadro para arrastrar.
local function createAnchor(db, width, height)
  local anchor = CreateFrame("Frame", "PaladinForDummiesEchoAnchor", UIParent)
  anchor:SetSize(width, height)
  anchor:SetMovable(true)
  anchor:SetClampedToScreen(true)
  anchor:RegisterForDrag("LeftButton")
  anchor:SetScript("OnDragStart", function(self) self:StartMoving() end)
  anchor:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local ok, point, _, relativePoint, x, y = pcall(self.GetPoint, self)
    if ok and point then
      db.position = EchoTracker.toCenter({ point = point, relativePoint = relativePoint, x = x, y = y },
        self:GetWidth(), self:GetHeight())
    end
  end)
  -- Clic derecho: fijarlo sin volver a las opciones.
  anchor:SetScript("OnMouseUp", function(self, mouseButton)
    if mouseButton == "RightButton" and self.unlocked then self:SetUnlocked(false) end
  end)

  -- El recuadro azul va en un marco hijo propio que se oculta entero al fijarlo
  -- (antes se le ponía transparencia y el borde se quedaba detrás).
  local box = CreateFrame("Frame", nil, anchor, "BackdropTemplate")
  box:SetAllPoints(anchor)
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
  box.hint = box:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  box.hint:SetPoint("BOTTOM", box, "TOP", 0, 4)
  box.hint:SetText(ns.L.ECHO_DRAG_HINT)
  anchor.box = box

  function anchor:ApplyPosition()
    -- Posiciones antiguas, guardadas por una esquina: se pasan al centro una vez.
    if db.position and db.position.point ~= "CENTER" then
      db.position = EchoTracker.toCenter(db.position, LEGACY_WIDTH, LEGACY_HEIGHT)
    end
    local pos = db.position or DEFAULT_POSITION
    self:ClearAllPoints()
    self:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
  end

  -- Fijado: sin recuadro, sin texto y sin ratón (no estorba en combate).
  function anchor:SetUnlocked(unlocked)
    self.unlocked = unlocked and true or false
    self:EnableMouse(self.unlocked)
    self.box:SetShown(self.unlocked)
  end

  -- Cambia la tabla donde se guarda la posición (al cambiar de perfil).
  function anchor:UseStore(store)
    db = store
    self:ApplyPosition()
  end

  anchor:ApplyPosition()
  anchor:SetUnlocked(false)
  return anchor
end

-- Diagnóstico para /pfd echo debug: qué partes existen y cuáles se ven.
-- Fuera de combate estos datos no son secret; en combate pueden serlo.
local function describeValue(fn)
  local ok, v = pcall(fn)
  if not ok then return "error" end
  if issecretvalue and issecretvalue(v) then return "<secret>" end
  return tostring(v)
end

function EchoTracker.describe()
  local lines = {}
  for _, echo in ipairs(EchoTracker.ECHOES) do
    local p = EchoTracker.progress[echo.key]
    local b = EchoTracker.buttons and EchoTracker.buttons[echo.key]
    if not p then
      lines[#lines + 1] = echo.key .. ": el juego no ha construido el botón todavía"
    else
      lines[#lines + 1] = ("%s: icono %s, número %s, aviso %s%s"):format(echo.key,
        tostring(p.icon == true), tostring(p.count == true), tostring(p.bar == true),
        p.error and (" | error: " .. p.error) or "")
      if b then
        lines[#lines + 1] = ("   botón visible %s | número '%s' visible %s | aviso visible %s"):format(
          describeValue(function() return b:IsVisible() end),
          describeValue(function() return b.pfdCount and b.pfdCount:GetText() end),
          describeValue(function() return b.pfdCount and b.pfdCount:IsVisible() end),
          describeValue(function() return b.pfdBar and b.pfdBar:IsVisible() end))
      end
    end
  end
  return lines
end

-- Crea el widget: el ancla y el contenedor con un hueco por cada copia. Los dos
-- huecos van en el mismo sitio: nunca hay copias de los dos sellos a la vez (el
-- golpe con el otro sello gasta las que había), así que solo se ve uno.
-- Devuelve el ancla (que mueve, muestra y oculta el conjunto), o nil y el error
-- si el cliente no lo permite.
function EchoTracker.create(db, onError)
  local ok, result = pcall(function()
    local width, height = SIZE + 2 * PAD, PAD + SIZE + TEXT_HEIGHT
    local anchor = createAnchor(db, width, height)

    local container = CreateFrame("AuraContainer", "PaladinForDummiesEchoes", anchor, "CustomAuraContainerTemplate")
    container:SetSize(width, height)
    container:SetPoint("CENTER", anchor, "CENTER", 0, 0)
    container:SetUnit("player")
    anchor.container = container

    for _, echo in ipairs(EchoTracker.ECHOES) do
      local frame = container:AddAuraSlot(echo.key, "HELPFUL", {
        candidateFilters = { includeSpellIDs = { [echo.spellId] = true } },
        initializeFrame = EchoTracker.initializer(echo, onError),
      })
      frame:SetPoint("TOP", container, "TOP", 0, -PAD)
    end
    return anchor
  end)
  if not ok then return nil, result end
  return result
end
