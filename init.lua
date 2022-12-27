-- custom Console toolbar (adds Clear button)
-- source: https://github.com/Hammerspoon/hammerspoon/issues/991#issuecomment-529682755
local toolbar = require("hs.webview.toolbar")
local console = require("hs.console")
local image = require("hs.image")
console.defaultToolbar = toolbar.new("CustomToolbar", {
    { id="prefs", label="Preferences", image=image.imageFromName("NSPreferencesGeneral"), tooltip="Open Preferences", fn=function() hs.openPreferences() end },
    { id="reload", label="Reload config", image=image.imageFromName("NSSynchronize"), tooltip="Reload configuration", fn=function() hs.reload() end },
    { id="openCfg", label="Open config", image=image.imageFromName("NSActionTemplate"), tooltip="Edit configuration", fn=function() openConfig() end },
    { id="clearLog", label="Clear", image = hs.image.imageFromName("NSTrashEmpty"), tooltip="Clear Console", fn=function() console.clearConsole() end },
    { id="help", label="Help", image=image.imageFromName("NSInfo"), tooltip="Open API docs browser", fn=function() hs.doc.hsdocs.help() end }
  }):canCustomize(true):autosaves(true)
console.toolbar(console.defaultToolbar)

function openConfig()
  hs.open(hs.configdir .. "/init.lua")
end

-- Modal bindings for window move/resize using keyboard as grid

local firstpoint, lastpoint, points_captured

function reset_points() 
  firstpoint = { x = 0, y = 0 }
  lastpoint = { x = 9, y = 3 }
  points_captured = 0
end

function assign_point(x, y)
  assert(points_captured < 2, "Only two points can be specified")
  point = { x = x, y = y }
  if (points_captured == 0) then
    firstpoint = point
  else
    lastpoint = point
  end
  points_captured = points_captured + 1
end

function arrange_window()
  print("first: ", point_to_string(firstpoint))
  print("last:  ", point_to_string(lastpoint))

  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen():frame()

  f.x = screen.x + screen.w * math.min(firstpoint.x, lastpoint.x) / 10
  f.y = screen.y + screen.h * math.min(firstpoint.y, lastpoint.y) / 4
  f.w = screen.w * (math.max(firstpoint.x, lastpoint.x) + 1) / 10 - math.max(f.x - screen.x, 0)
  f.h = screen.h * (math.max(firstpoint.y, lastpoint.y) + 1) / 4 - math.max(f.y - screen.y, 0)

  print("max frame: ", rect_to_string(screen))
  print("new frame: ", rect_to_string(f))
  win:setFrame(f)

  winmode:exit()
end

function point_to_string(point) 
  return "(x: " .. point.x .. ", y: " .. point.y .. ")"
end

function rect_to_string(rect) 
  return "(x: " .. rect.x .. ", y: " .. rect.y .. ", w: " .. rect.w .. ", h: " .. rect.h .. ")"
end

winmode = hs.hotkey.modal.new({'cmd'}, 'm')
function winmode.entered() reset_points() end

winmode:bind('', 'escape', function () winmode:exit() end)
winmode:bind('', 'return', function () arrange_window() end)

-- left half

winmode:bind('', '1', function () assign_point(0,0) end)
winmode:bind('', '2', function () assign_point(1,0) end)
winmode:bind('', '3', function () assign_point(2,0) end)
winmode:bind('', '4', function () assign_point(3,0) end)
winmode:bind('', '5', function () assign_point(4,0) end)

winmode:bind('', '\'', function () assign_point(0,1) end)
winmode:bind('', ',', function () assign_point(1,1) end)
winmode:bind('', '.', function () assign_point(2,1) end)
winmode:bind('', 'p', function () assign_point(3,1) end)
winmode:bind('', 'y', function () assign_point(4,1) end)

winmode:bind('', 'a', function () assign_point(0,2) end)
winmode:bind('', 'o', function () assign_point(1,2) end)
winmode:bind('', 'e', function () assign_point(2,2) end)
winmode:bind('', 'u', function () assign_point(3,2) end)
winmode:bind('', 'i', function () assign_point(4,2) end)

winmode:bind('', ';', function () assign_point(0,3) end)
winmode:bind('', 'q', function () assign_point(1,3) end)
winmode:bind('', 'j', function () assign_point(2,3) end)
winmode:bind('', 'k', function () assign_point(3,3) end)
winmode:bind('', 'x', function () assign_point(4,3) end)

-- right half

winmode:bind('', '6', function () assign_point(5,0) end)
winmode:bind('', '7', function () assign_point(6,0) end)
winmode:bind('', '8', function () assign_point(7,0) end)
winmode:bind('', '9', function () assign_point(8,0) end)
winmode:bind('', '0', function () assign_point(9,0) end)

winmode:bind('', 'f', function () assign_point(5,1) end)
winmode:bind('', 'g', function () assign_point(6,1) end)
winmode:bind('', 'c', function () assign_point(7,1) end)
winmode:bind('', 'r', function () assign_point(8,1) end)
winmode:bind('', 'l', function () assign_point(9,1) end)

winmode:bind('', 'd', function () assign_point(5,2) end)
winmode:bind('', 'h', function () assign_point(6,2) end)
winmode:bind('', 't', function () assign_point(7,2) end)
winmode:bind('', 'n', function () assign_point(8,2) end)
winmode:bind('', 's', function () assign_point(9,2) end)

winmode:bind('', 'b', function () assign_point(5,3) end)
winmode:bind('', 'm', function () assign_point(6,3) end)
winmode:bind('', 'w', function () assign_point(7,3) end)
winmode:bind('', 'v', function () assign_point(8,3) end)
winmode:bind('', 'z', function () assign_point(9,3) end)
