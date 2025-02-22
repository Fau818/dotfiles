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
-- TODO: Move window across monitors
---@param window hs.window
---@param position table { x, y, w, h }
local function _is_same(window, position)
  local window_frame = window:frame().table
  local wx, wy, ww, wh = window_frame.x, window_frame.y, window_frame.w, window_frame.h
  -- hs.alert.show(string.format("x: %d, y: %d, w: %d, h: %d", wx, wy, ww, wh))
  -- hs.alert.show(string.format("wx: %d, wy: %d, ww: %d, wh: %d, x: %d, y: %d, w: %d, h: %d", wx, wy, ww, wh, position.x, position.y, position.w, position.h))
  -- if wx == position.x and wy == position.y and ww == position.w and wh == position.h then return true else return false end
  return wx == position.x and wy == position.y and ww == position.w and wh == position.h
end

-- _is_same({}, {})

---Move and resize window
---@param position table {x, y, w, h}
---@param direction "left"|"right"?
local function _move_and_resize_window(position, direction)
  local special_app_list = { ["System Settings"] = true, ["Reminders"] = true, ["Quantumult X"] = true, ["Arc"] = false, ["AlDente"] = true }
  local window = hs.window.focusedWindow()
  if window then
    -- ==================== 左右横跳 ====================
    if _is_same(window, position) then
      hs.alert.show("SAME!!!")

      if direction then
        if direction == "left" then
          local next_screen = screen:toWest(screen)
          window:move(right_half, next_screen)
          hs.alert.show(next_screen)
        else
          local next_screen = screen:toEast(screen)
          window:move(left_half, next_screen)
          hs.alert.show(next_screen)
        end
        return
      end
    end

    local is_standard = window:isStandard()
    local app_name = window:application():name()
    -- hs.alert.show(app_name)

    -- EXIT: Special treatment for `Battle.net`.
    if app_name == "Battle.net" then if window:title() == "Battle.net Login" then window:centerOnScreen() else window:move(position) end return end

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
