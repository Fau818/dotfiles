-- =============================================
-- ========== Window Management
-- =============================================
-- -----------------------------------
-- -------- Configuration
-- -----------------------------------
local screen = hs.screen.mainScreen()
local screen_frame = screen:frame()
local gap = 8
local top = 32
hs.window.animationDuration = -1  -- Disable animation


-- -----------------------------------
-- -------- Layouts
-- -----------------------------------
local left_half = {
  x = screen_frame.x + gap,
  y = screen_frame.y + gap + top,
  w = (screen_frame.w / 2) - (gap * 1.5),
  h = screen_frame.h - (gap * 2) - top,
}
local right_half = {
  x = screen_frame.x + (screen_frame.w / 2) + (gap / 2),
  y = screen_frame.y + gap + top,
  w = (screen_frame.w / 2) - (gap * 1.5),
  h = screen_frame.h - (gap * 2) - top,
}
local maximum = {
  x = screen_frame.x + gap,
  y = screen_frame.y + gap + top,
  w = screen_frame.w - (gap * 2),
  h = screen_frame.h - (gap * 2) - top,
}


-- -----------------------------------
-- -------- Functions
-- -----------------------------------
---Move and resize window
---@param position table {x, y, w, h}
local function _move_and_resize_window(position)
  local special_app_list = { ["System Settings"] = true, ["Quantumult X"] = true, ["Arc"] = false }
  local window = hs.window.focusedWindow()
  if window then
    local is_standard = window:isStandard()
    local app_name = window:application():name()
    -- hs.alert.show(app_name)
    if special_app_list[app_name] ~= nil then
      if special_app_list[app_name] then window:centerOnScreen() else window:move(position) end
    elseif not is_standard then window:centerOnScreen()
    else window:move(position)
    end
  else hs.alert.show("ERROR: No active window!")
  end
end


---Center window
---@param scale number the scale ratio from 0.0 to 1.0
local function center_window(scale)
  scale = scale or 0.85
  local center = {
    x = screen_frame.x + (screen_frame.w * (1 - scale)) / 2,
    y = screen_frame.y + (screen_frame.h * (1 - scale)) / 2 + top,
    w = screen_frame.w * scale,
    h = screen_frame.h * scale - top,
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
