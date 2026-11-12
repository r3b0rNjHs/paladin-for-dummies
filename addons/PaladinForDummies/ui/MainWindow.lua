-- La ventana principal (/pfd, menú de addons del minimapa). Sistema de diseño
-- (ui/Style.lua), pestañas:
--   Hoy     Tu plan, lo que te falta ahora mismo, tus peleas y el modo entrenador
--   Peleas  de dónde sale tu daño (medidor de Blizzard) y tus últimas peleas
--   Macros  las macros del addon para arrastrarlas a la barra
--   Guía    abre la guía de las opciones; Ajustes, el panel de opciones
-- La primera vez, la pestaña Hoy enseña los primeros pasos.
-- Solo muestra lo que le da Main.lua (h.windowData): no decide nada.
local _, ns = ...
ns.UI = ns.UI or {}
local L = ns.L
local Style = ns.UI.Style

local MainWindow = {}
ns.UI.MainWindow = MainWindow

local WIDTH, HEIGHT = 660, 480
local PAD = 16
local ROW = 24
local MAX_PLAN, MAX_NOW, MAX_DAMAGE, MAX_FIGHTS = 12, 5, 7, 8

local function c(name) return Style.COLORS[name] end

local function spellTexture(spellId)
  if spellId and C_Spell and C_Spell.GetSpellTexture then
    local ok, icon = pcall(C_Spell.GetSpellTexture, spellId)
    if ok and icon then return icon end
  end
  return 134400
end

local function spellName(spellId)
  if C_Spell and C_Spell.GetSpellName then
    local ok, name = pcall(C_Spell.GetSpellName, spellId)
    if ok and type(name) == "string" then return name end
  end
  return "spellID " .. tostring(spellId)
end

-- Una línea con icono pequeño y texto.
local function iconLine(parent, width)
  local row = CreateFrame("Frame", nil, parent)
  row:SetSize(width, ROW)
  row.icon = row:CreateTexture(nil, "ARTWORK")
  row.icon:SetSize(20, 20)
  row.icon:SetPoint("LEFT", row, "LEFT", 0, 0)
  row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  row.text = Style.text(row, "GameFontHighlight", "text")
  row.text:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
  row.text:SetWidth(width - 28)
  row.text:SetJustifyH("LEFT")
  row.text:SetWordWrap(true)
  function row:Set(icon, text, colorName)
    if icon then self.icon:SetTexture(icon); self.icon:Show() else self.icon:Hide() end
    self.text:SetText(text)
    local col = c(colorName or "text")
    self.text:SetTextColor(col[1], col[2], col[3])
    self:Show()
  end
  row:Hide()
  return row
end

local function heading(parent, text)
  local fs = Style.text(parent, "GameFontNormal", "gold")
  fs:SetText(text)
  return fs
end

local function button(parent, text, width, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(width, 24)
  b:SetText(text)
  b:SetScript("OnClick", onClick)
  return b
end

-- Pestaña Hoy -------------------------------------------------------------

local function buildToday(page, h)
  local colWidth = (WIDTH - PAD * 3) / 2

  page.planTitle = heading(page, L.WIN_PLAN)
  page.planTitle:SetPoint("TOPLEFT", page, "TOPLEFT", 0, 0)
  page.plan = {}
  for i = 1, MAX_PLAN do
    local row = iconLine(page, colWidth)
    row:SetPoint("TOPLEFT", page.planTitle, "BOTTOMLEFT", 0, -6 - (i - 1) * ROW)
    page.plan[i] = row
  end

  page.nowTitle = heading(page, L.WIN_NOW)
  page.nowTitle:SetPoint("TOPLEFT", page, "TOPLEFT", colWidth + PAD, 0)
  page.now = {}
  for i = 1, MAX_NOW do
    local row = iconLine(page, colWidth)
    row:SetPoint("TOPLEFT", page.nowTitle, "BOTTOMLEFT", 0, -6 - (i - 1) * ROW)
    page.now[i] = row
  end

  page.fightsTitle = heading(page, L.GUIDE_FIGHTS_TITLE)
  page.fightsTitle:SetPoint("TOPLEFT", page.nowTitle, "BOTTOMLEFT", 0, -16 - MAX_NOW * ROW)
  page.fightsText = Style.text(page, "GameFontHighlight", "text")
  page.fightsText:SetPoint("TOPLEFT", page.fightsTitle, "BOTTOMLEFT", 0, -6)
  page.fightsText:SetWidth(colWidth)
  page.fightsText:SetJustifyH("LEFT")

  page.trainer = button(page, L.WIN_TRAINER_ON, 220, function()
    h.toggleTrainer()
    page:Refresh()
  end)
  page.trainer:SetPoint("BOTTOMLEFT", page, "BOTTOMLEFT", colWidth + PAD, 0)

  -- Primeros pasos: la primera vez, encima de todo lo demás.
  local welcome = CreateFrame("Frame", nil, page, "BackdropTemplate")
  welcome:SetAllPoints(page)
  welcome:SetFrameLevel(page:GetFrameLevel() + 10)
  if welcome.SetBackdrop then
    welcome:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
    welcome:SetBackdropColor(0.04, 0.04, 0.05, 0.97)
  end
  welcome:EnableMouse(true)
  welcome.title = Style.text(welcome, "GameFontNormalLarge", "pink")
  welcome.title:SetPoint("TOPLEFT", welcome, "TOPLEFT", 8, -8)
  welcome.title:SetText(L.WIN_WELCOME_TITLE)
  local previous = welcome.title
  welcome.steps = {}
  for i = 1, 4 do
    local fs = Style.text(welcome, "GameFontHighlight", "text")
    fs:SetPoint("TOPLEFT", previous, "BOTTOMLEFT", 0, -14)
    fs:SetWidth(WIDTH - PAD * 2 - 16)
    fs:SetJustifyH("LEFT")
    welcome.steps[i] = fs
    previous = fs
  end
  welcome.ok = button(welcome, L.WIN_WELCOME_OK, 160, function()
    h.finishWelcome()
    welcome:Hide()
  end)
  welcome.ok:SetPoint("BOTTOMRIGHT", welcome, "BOTTOMRIGHT", -8, 8)
  page.welcome = welcome

  function page:Refresh()
    local data = h.windowData()

    for i, row in ipairs(self.plan) do
      local step = data.plan[i]
      if step then
        if step.key:find("^H_") then
          row:Set(nil, data.fill(L["GUIDE_PLAN_" .. step.key]), "gold")
        else
          row:Set(step.icon and data.icon(step.icon), data.fill(L["GUIDE_PLAN_" .. step.key]))
        end
      else
        row:Hide()
      end
    end

    for _, row in ipairs(self.now) do row:Hide() end
    if not data.hasTarget then
      self.now[1]:Set(nil, L.WIN_NOW_NO_TARGET, "muted")
    elseif #data.alerts == 0 then
      self.now[1]:Set(nil, L.WIN_NOW_OK, "green")
    else
      for i, alert in ipairs(data.alerts) do
        if self.now[i] then
          self.now[i]:Set(spellTexture(alert.spellId), L["WIN_ALERT_" .. alert.kind:upper()]:format(spellName(alert.spellId)),
            alert.state == "missing" and "red" or "gold")
        end
      end
    end

    self.fightsText:SetText(data.fightsText)
    self.trainer:SetText(data.trainerActive and L.WIN_TRAINER_OFF or L.WIN_TRAINER_ON)

    if data.welcome then
      for i, fs in ipairs(self.welcome.steps) do fs:SetText(data.fill(L["WIN_WELCOME_" .. i])) end
      self.welcome:Show()
    else
      self.welcome:Hide()
    end
  end
end

-- Pestaña Peleas ----------------------------------------------------------

local function buildFights(page, h)
  page.damageTitle = heading(page, L.WIN_DAMAGE)
  page.damageTitle:SetPoint("TOPLEFT", page, "TOPLEFT", 0, 0)
  local barWidth = WIDTH - PAD * 2 - 260
  page.bars = {}
  for i = 1, MAX_DAMAGE do
    local row = CreateFrame("Frame", nil, page)
    row:SetSize(WIDTH - PAD * 2, 20)
    row:SetPoint("TOPLEFT", page.damageTitle, "BOTTOMLEFT", 0, -6 - (i - 1) * 22)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(18, 18)
    row.icon:SetPoint("LEFT", row, "LEFT", 0, 0)
    row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    row.name = Style.text(row, "GameFontHighlightSmall", "text")
    row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
    row.name:SetWidth(180)
    row.name:SetJustifyH("LEFT")
    row.back = row:CreateTexture(nil, "BACKGROUND")
    row.back:SetPoint("LEFT", row, "LEFT", 210, 0)
    row.back:SetSize(barWidth, 10)
    row.back:SetColorTexture(1, 1, 1, 0.08)
    row.bar = row:CreateTexture(nil, "ARTWORK")
    row.bar:SetPoint("LEFT", row.back, "LEFT", 0, 0)
    row.bar:SetHeight(10)
    local gold = c("gold")
    row.bar:SetColorTexture(gold[1], gold[2], gold[3], 0.9)
    row.pct = Style.text(row, "GameFontHighlightSmall", "muted")
    row.pct:SetPoint("LEFT", row.back, "RIGHT", 8, 0)
    row:Hide()
    page.bars[i] = row
  end
  page.damageEmpty = Style.text(page, "GameFontHighlight", "muted")
  page.damageEmpty:SetPoint("TOPLEFT", page.damageTitle, "BOTTOMLEFT", 0, -6)

  page.lastTitle = heading(page, L.WIN_LAST)
  page.lastTitle:SetPoint("TOPLEFT", page.damageTitle, "BOTTOMLEFT", 0, -16 - MAX_DAMAGE * 22)
  local columns = { 0, 90, 190, 320 }
  local headers = { L.WIN_COL_DURATION, L.WIN_COL_DPS, L.WIN_COL_JUDGE, L.WIN_COL_STYLE }
  for i, x in ipairs(columns) do
    local fs = Style.text(page, "GameFontNormalSmall", "muted")
    fs:SetPoint("TOPLEFT", page.lastTitle, "BOTTOMLEFT", x, -6)
    fs:SetText(headers[i])
  end
  page.rows = {}
  for r = 1, MAX_FIGHTS do
    local cells = {}
    for i, x in ipairs(columns) do
      local fs = Style.text(page, "GameFontHighlightSmall", "text")
      fs:SetPoint("TOPLEFT", page.lastTitle, "BOTTOMLEFT", x, -24 - (r - 1) * 18)
      cells[i] = fs
    end
    page.rows[r] = cells
  end

  function page:Refresh()
    local data = h.windowData()
    local breakdown = data.breakdown
    for i, row in ipairs(self.bars) do
      local spell = breakdown and breakdown.spells[i]
      if spell then
        row.icon:SetTexture(spellTexture(spell.spellId))
        row.name:SetText(spell.spellId == 6603 and L.WIN_MELEE or spellName(spell.spellId))
        row.bar:SetWidth(math.max(1, barWidth * spell.percent / 100))
        row.pct:SetText(("%s %%"):format(spell.percent))
        row:Show()
      else
        row:Hide()
      end
    end
    self.damageEmpty:SetText(breakdown and "" or L.WIN_DAMAGE_EMPTY)

    for r, cells in ipairs(self.rows) do
      local fight = data.lastFights[r]
      for i, fs in ipairs(cells) do fs:SetText(fight and fight[i] or "") end
    end
  end
end

-- Pestaña Macros ----------------------------------------------------------

local function buildMacros(page, h)
  page.hint = Style.text(page, "GameFontHighlight", "muted")
  page.hint:SetPoint("TOPLEFT", page, "TOPLEFT", 0, 0)
  page.hint:SetWidth(WIDTH - PAD * 2)
  page.hint:SetJustifyH("LEFT")
  page.hint:SetText(L.WIN_MACROS_HINT)

  page.buttons = {}
  local perRow, size, cellW, cellH = 5, 36, (WIDTH - PAD * 2) / 5, 64
  for i, info in ipairs(ns.Data.MacroInfo) do
    local b = CreateFrame("Button", nil, page)
    b:SetSize(cellW, cellH)
    b:SetPoint("TOPLEFT", page.hint, "BOTTOMLEFT", ((i - 1) % perRow) * cellW, -14 - math.floor((i - 1) / perRow) * cellH)
    b.icon = Style.icon(b, size)
    b.icon:SetPoint("TOP", b, "TOP", 0, 0)
    b.icon:EnableMouse(false)
    b.label = Style.text(b, "GameFontHighlightSmall", "text")
    b.label:SetPoint("TOP", b.icon, "BOTTOM", 0, -4)
    b.label:SetText(info.name)
    b.info = info
    b:RegisterForDrag("LeftButton")
    b:SetScript("OnDragStart", function(self) h.pickupMacro(self.info.name) end)
    b:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
      local gold = c("gold")
      GameTooltip:AddLine(self.info.name, gold[1], gold[2], gold[3])
      GameTooltip:AddLine(h.windowData().fill(L["MACRO_DESC_" .. self.info.key]), 1, 1, 1, true)
      if not self.exists then
        local muted = c("muted")
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(L.WIN_MACRO_MISSING, muted[1], muted[2], muted[3], true)
      end
      GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    page.buttons[i] = b
  end

  function page:Refresh()
    local data = h.windowData()
    for _, b in ipairs(self.buttons) do
      b.exists = data.macroExists(b.info.name)
      b.icon.icon:SetTexture(data.icon(b.info.icon) or 134400)
      b.icon:SetState("normal")
      b.icon.icon:SetDesaturated(not b.exists)
    end
  end
end

-- La ventana ----------------------------------------------------------------

function MainWindow.create(h)
  local frame = CreateFrame("Frame", "PaladinForDummiesWindow", UIParent, "BackdropTemplate")
  frame:SetSize(WIDTH, HEIGHT)
  frame:SetPoint("CENTER")
  frame:SetFrameStrata("DIALOG")
  frame:SetMovable(true)
  frame:SetClampedToScreen(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  if frame.SetBackdrop then
    frame:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
    frame:SetBackdropColor(0.04, 0.04, 0.05, 0.96)
    frame:SetBackdropBorderColor(0, 0, 0, 1)
  end
  -- Se cierra con Escape, como las ventanas del juego.
  if type(UISpecialFrames) == "table" then table.insert(UISpecialFrames, "PaladinForDummiesWindow") end

  frame.title = Style.text(frame, "GameFontNormalLarge", "pink")
  frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD, -12)
  frame.title:SetText("Paladin for Dummies")
  local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)

  -- Pestañas: texto con una raya dorada bajo la activa.
  local pages, tabs = {}, {}
  local function select(key)
    for k, page in pairs(pages) do page:SetShown(k == key) end
    for k, tab in pairs(tabs) do
      tab.line:SetShown(k == key)
      local col = c(k == key and "gold" or "muted")
      tab.text:SetTextColor(col[1], col[2], col[3])
    end
    frame.current = key
    pages[key]:Refresh()
  end

  local x = PAD
  local function tab(key, label, onClick)
    local t = CreateFrame("Button", nil, frame)
    t:SetSize(100, 26)
    t:SetPoint("TOPLEFT", frame, "TOPLEFT", x, -40)
    t.text = Style.text(t, "GameFontNormal", "muted")
    t.text:SetPoint("CENTER")
    t.text:SetText(label)
    local w = t.text:GetStringWidth()
    if type(w) == "number" and w > 0 then t:SetWidth(w + 24) end
    t.line = t:CreateTexture(nil, "ARTWORK")
    t.line:SetPoint("BOTTOMLEFT", t, "BOTTOMLEFT", 6, 0)
    t.line:SetPoint("BOTTOMRIGHT", t, "BOTTOMRIGHT", -6, 0)
    t.line:SetHeight(2)
    local gold = c("gold")
    t.line:SetColorTexture(gold[1], gold[2], gold[3], 1)
    t.line:Hide()
    t:SetScript("OnClick", onClick or function() select(key) end)
    tabs[key] = t
    local width = t:GetWidth()
    x = x + ((type(width) == "number" and width) or 100) + 4
    return t
  end

  local function page(key, build)
    local p = CreateFrame("Frame", nil, frame)
    p:SetPoint("TOPLEFT", frame, "TOPLEFT", PAD, -80)
    p:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -PAD, PAD)
    build(p, h)
    p:Hide()
    pages[key] = p
  end

  tab("today", L.WIN_TAB_TODAY)
  tab("fights", L.WIN_TAB_FIGHTS)
  tab("macros", L.WIN_TAB_MACROS)
  local guideTab = tab("guide", L.OPT_GUIDE, function() frame:Hide(); h.openGuide() end)
  tabs.guide = nil -- no es una página: abre la guía de las opciones
  guideTab.text:SetTextColor(c("muted")[1], c("muted")[2], c("muted")[3])

  page("today", buildToday)
  page("fights", buildFights)
  page("macros", buildMacros)

  local settings = button(frame, L.WIN_SETTINGS, 100, function() frame:Hide(); h.openSettings() end)
  settings:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -36, -40)

  function frame:Open(key)
    self:Show()
    select(key or self.current or "today")
  end

  function frame:RefreshIfShown()
    if self:IsShown() and self.current then pages[self.current]:Refresh() end
  end

  frame:Hide()
  return frame
end
