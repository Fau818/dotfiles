-- =============================================
-- ========== Window Management
-- =============================================
-- -----------------------------------
-- -------- Configuration
-- -----------------------------------
local screen = hs.screen.mainScreen()
local screen_frame = screen:frame()
local gap = 8


-- -----------------------------------
-- -------- Layouts
-- -----------------------------------
local left_half = {
  x = screen_frame.x + gap,
  y = screen_frame.y + gap,
  w = (screen_frame.w / 2) - (gap * 1.5),
  h = screen_frame.h - (gap * 2),
}
local right_half = {
  x = screen_frame.x + (screen_frame.w / 2) + (gap / 2),
  y = screen_frame.y + gap,
  w = (screen_frame.w / 2) - (gap * 1.5),
  h = screen_frame.h - (gap * 2),
}
local maximum = {
  x = screen_frame.x + gap,
  y = screen_frame.y + gap,
  w = screen_frame.w - (gap * 2),
  h = screen_frame.h - (gap * 2),
}


-- -----------------------------------
-- -------- Functions
-- -----------------------------------
---Move and resize window
---@param position table {x, y, w, h}
local function _move_and_resize_window(position)
  local window = hs.window.focusedWindow()
  if window then window:move(position)
  else hs.alert.show("ERROR: No active window!")
  end
end


---Center window
---@param scale number the scale ratio from 0.0 to 1.0
local function center_window(scale)
  scale = scale or 0.85
  local center = {
    x = screen_frame.x + (screen_frame.w * (1 - scale)) / 2,
    y = screen_frame.y + (screen_frame.h * (1 - scale)) / 2,
    w = screen_frame.w * scale,
    h = screen_frame.h * scale,
  }
  if screen_frame.w * scale > maximum.w or screen_frame.h * scale > maximum.h then center = maximum end
  _move_and_resize_window(center)
end


local function move_window_to_left_half() _move_and_resize_window(left_half) end
local function move_window_to_right_half() _move_and_resize_window(right_half) end
local function maximize_window() _move_and_resize_window(maximum) end


-- -----------------------------------
-- -------- Return
-- -----------------------------------
return {
  move_window_to_left_half = move_window_to_left_half,
  move_window_to_right_half = move_window_to_right_half,
  maximize_window = maximize_window,
  center_window = center_window,
}
