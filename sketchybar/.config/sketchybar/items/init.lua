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


-- NOTE: Show `Amphetamine`
sbar.add("alias", "Amphetamine", {
  position = "center",
  alias = { update_freq = 1, color = colors.stardust },
  -- padding_left  = 500,
  padding_right = 600,
  background = { color = colors.transparent }
})


-- -- NOTE: Show `timersMenuBar`
-- sbar.add("alias", "Raycast", {
--   position = "left",
--   alias = {
--     update_freq = 1,
--     color = colors.stardust,
--     scale = 1.1,
--   },
--   padding_left  = 0,
--   padding_right = 0,
--   background = { color = colors.transparent }
-- })


-- -----------------------------------
-- -------- Middle Right
-- -----------------------------------
require("items.media")


-- -----------------------------------
-- -------- Right
-- -----------------------------------
require("items.calendar")
require("items.widgets")
