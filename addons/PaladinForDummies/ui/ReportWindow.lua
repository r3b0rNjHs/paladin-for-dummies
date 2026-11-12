-- Ventana con el informe de errores (core/Report.lua) en un cuadro de texto para
-- seleccionar y copiar. Usa AceGUI, el sistema de ventanas de Ace3.
local _, ns = ...
ns.UI = ns.UI or {}
local L = ns.L

local ReportWindow = {}
ns.UI.ReportWindow = ReportWindow

local window

function ReportWindow.show(text)
  local AceGUI = LibStub("AceGUI-3.0")
  if window then window:Release() end

  window = AceGUI:Create("Frame")
  window:SetTitle(L.REPORT_TITLE)
  window:SetStatusText(L.REPORT_HINT)
  window:SetLayout("Fill")
  window:SetWidth(620)
  window:SetHeight(420)
  window:SetCallback("OnClose", function(widget)
    widget:Release()
    window = nil
  end)

  local box = AceGUI:Create("MultiLineEditBox")
  box:SetLabel("")
  box:DisableButton(true)
  box:SetText(text)
  window:AddChild(box)
  box:SetFocus()
  box:HighlightText()
end
