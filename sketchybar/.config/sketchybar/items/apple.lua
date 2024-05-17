-- =============================================
-- ========== Config
-- =============================================
local apple_config = {
  position = "left",
  icon = {
    string = icons.aqi,
    font = { style = "Black", size = 13.0 },
    color = colors.stardust,
  },
  label = { drawing = false },
  -- padding_left  = 10,
  padding_right = 10,

  click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
}



-- =============================================
-- ========== Setup
-- =============================================
local apple = sbar.add("item", "apple", apple_config)
