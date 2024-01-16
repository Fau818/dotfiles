--- NOTE: Use `~/.config/hammerspoon` as the config directory.
--- defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

--- Global Variable
Fau_hs = {}

-- =============================================
-- ========== Load Spoon
-- =============================================
-- Update the annotations (NOTE: it's slow.)
hs.loadSpoon("EmmyLua")

-- hs.loadSpoon("LeftRightHotkey")



-- =============================================
-- ========== Load Extension
-- =============================================
--- stackline
local stackline = require("stackline")
stackline:init()

--- yabai
-- require("yabai")

--- window manager
Fau_hs.window = require("user.window")


-- =============================================
-- ========== Key Binding
-- =============================================
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function() hs.reload() end)



-- =============================================
-- ========== TEST
-- =============================================
-- spoon.LeftRightHotkey:bind({ "lCtrl", "rCtrl" }, "g", function()
--   hs.alert.show("YES!!!")
-- end)



-- =============================================
-- ========== Start Spoon
-- =============================================
-- spoon.LeftRightHotkey:start()



--- Support commandline
hs.ipc.cliInstall()
--- Report
hs.alert.show("Hammerspoon Config Loaded!")
