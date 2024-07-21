-- -----------------------------------
-- -------- General
-- -----------------------------------
colors   = require("colors")
icons    = require("icons")
settings = require("settings")


-- -----------------------------------
-- -------- Left
-- -----------------------------------
require("items.apple")
require("items.menus")
require("items.spaces")
require("items.front_app")
require("items.yabai")


-- -----------------------------------
-- -------- Middle Left
-- -----------------------------------
require("items.media")


-- -----------------------------------
-- -------- Right
-- -----------------------------------
require("items.calendar")
require("items.widgets")


-- NOTE: Show `timersMenuBar`
sbar.add("item", "Raycast.padding", { position = "right", width = 2 * settings.group_padding })
local surge = sbar.add("alias", "Raycast", {
  position = "right",
  alias = {
    update_freq = 1,
    color = colors.stardust,
  },
  padding_left  = 0,
  padding_right = -2 * settings.group_padding,
  background = { color = colors.transparent }
})
