-- =============================================
-- ========== General
-- =============================================
local app_icons = require("helpers.app_icons")
local space_icons = { "􀀺", "􀀼", "􀀾", "􀁀", "􀁂", "􀁄", "􀁆", "􀁈", "􀁊", "􀓵" }

local spaces       = {}  -- Used to store space items.
local space_popups = {}  -- Used to store space popup items.



-- =============================================
-- ========== Config
-- =============================================
local function _get_space_name(index) return ("space.%s"):format(index) end

-- -----------------------------------
-- -------- Space
-- -----------------------------------
local space_config = {}
local space_popup_config = {}
for i = 1, 10, 1 do
  space_config[i] = {
    space = i,
    icon = {
      string = space_icons[i],
      color = colors.status.inactive,
      highlight_color = colors.status.active,
      padding_left  = 12,
      padding_right = 5,
    },
    label = {
      font = "sketchybar-app-font:Regular:16.0",
      color = colors.inactive,
      highlight_color = colors.status.active,
      padding_right = 15,
    },
    background = { color = colors.red, height = 26 },
  }

  space_popup_config[i] = {
    position = ("popup.%s"):format(_get_space_name(i)),
    padding_left  = 1,
    padding_right = 0,
    background = { drawing = true, image = { corner_radius = 10, scale = 0.15 } },
  }
end


-- -----------------------------------
-- -------- Space Window Observer
-- -----------------------------------
local space_window_observer_config = { drawing = false, updates = true }


-- -----------------------------------
-- -------- Space Indicator
-- -----------------------------------
local space_indicator_config = {
  position = "left",
  display = "active",
  -- padding_left  = -4 * settings.group_padding,
  padding_right = 3 * settings.group_padding,
  icon  = {
    string = icons.switch.on,
    font = { style = "Bold", size = 16.0 },
    color  = colors.stardust,
    padding_left = 2 * settings.group_padding,
  },
  label = {
    string = "Menus",
    font = { style = "SemiBold", size = 12.0 },
    color = colors.status.active,
    padding_left  = 2 * settings.group_padding,
    padding_right = 3 * settings.group_padding,
    y_offset = 1,
    width = 0,
  },
}



-- =============================================
-- ========== Setup
-- =============================================
-- Space Items
for i = 1, 10, 1 do
  local space = sbar.add("space", _get_space_name(i), space_config[i])
  local space_popup = sbar.add("item", ("%s.popup"):format(_get_space_name(i)), space_popup_config[i])
  spaces[i], space_popups[i] = space, space_popup

  -- Add padding between space items.
  -- NOTE: Use add `space` to avoid extra paddings.
  -- sbar.add("item", ("space.%s.padding"):format(i), { position = "left", width = settings.group_padding })
  sbar.add("space", ("space.%s.padding"):format(i), { space = i, width = settings.group_padding })
end

-- Space Window Observer
local space_window_observer = sbar.add("item", space_window_observer_config)

-- Space State Observer.
-- Drives active/inactive state for all space items. See subscribe block below.
local space_state_observer = sbar.add("item", { drawing = false, updates = true })

-- Space Indicator
local space_indicator = sbar.add("item", space_indicator_config)



-- =============================================
-- ========== Functions
-- =============================================
-- -----------------------------------
-- -------- Space
-- -----------------------------------

---Set a space to active state (highlighted with type-colored background).
---@param space table Sketchybar space item handle.
---@param color number Background color.
local function set_active(space, color)
  sbar.animate("tanh", 5, function()
    space:set({
      icon = { highlight = true },
      label = { highlight = true },
      background = { color = color },
    })
  end)
end


---Set a space to inactive state (un-highlighted, transparent background).
---@param space table Sketchybar space item handle.
local function set_inactive(space)
  sbar.animate("tanh", 5, function()
    space:set({
      icon = { highlight = false },
      label = { highlight = false },
      background = { color = colors.almost_transparent },
    })
  end)
end


---Update app icons in space.
---@param env table Environment variables.
local function update_space_app(env)
  if env.INFO.space == nil then return end
  -- `spaces` only contains items 1..10; guard against extra spaces created beyond that.
  local space = spaces[env.INFO.space]
  if space == nil then return end
  local icon_line = ""
  local no_app = true
  for app, _ in pairs(env.INFO.apps) do
    local app_name = string.lower(app)
    if app_name ~= "grabit" then
      no_app = false
      local icon = app_icons[app_name] or app_icons["default"]
      icon_line = icon_line .. icon
    end
  end

  if no_app then icon_line = "—" end
  sbar.animate("tanh", 10, function() space:set({ label = icon_line }) end)
end


---Click space event.
---`cmd + left`: Show space thumbnail.
---`left / right`: Focus/Destroy space.
---@param env table Environment variables.
local function click_space(env)
  --- Get space and selected status.
  assert(env.SID ~= nil, "SID is nil")
  local space_id = tonumber(env.SID)
  local space, space_popup = spaces[space_id], space_popups[space_id]

  -- CASE 1: Show space thumbnail.
  if env.MODIFIER == "cmd" and env.BUTTON == "left" then
    space:set({ popup = { drawing = "toggle" } })
    space_popup:set({ background = { image = "space." .. env.SID } })
  else -- CASE 2: Focus or Destroy space.
    local op = env.BUTTON == "left" and "--focus" or "--destroy"
    sbar.exec(("yabai -m space %s %s"):format(op, env.SID))
  end
end


-- -----------------------------------
-- -------- Triggers
-- -----------------------------------

---Trigger `space_windows_change` event.
---@param env table Environment variables.
local function trigger_space_windows_change_event(env)
  local selected = env.SELECTED == "true"
  if selected then sbar.trigger("space_windows_change") end
end


---Trigger `swap_menus_and_spaces` event.
---@param env table Environment variables.
local function trigger_swap_menus_and_spaces_event(env) sbar.trigger("swap_menus_and_spaces") end


-- -----------------------------------
-- -------- Space Indicator
-- -----------------------------------

---Expand space indicator.
---@param env table Environment variables.
local function expand_indicator(env)
  sbar.animate("tanh", 30, function()
    space_indicator:set({
      background = { color = colors.stardust, border_color = { alpha = 1.0 } },
      icon = { color = colors.status.active },
      label = { width = "dynamic" },
    })
  end)
end


---Collapse space indicator.
---@param env table Environment variables.
local function collapse_indicator(env)
  sbar.animate("tanh", 30, function()
    space_indicator:set({ background = { color = colors.almost_transparent }, icon = { color = colors.stardust }, label = { width = 0 } })
  end)
end


---Toggle space indicator.
---@param env table Environment variables.
local function toggle_indicator(env)
  local currently_on = space_indicator:query().icon.value == icons.switch.on
  space_indicator:set({ icon = currently_on and icons.switch.off or icons.switch.on, label = currently_on and "Spaces" or "Menus" } )
end



-- =============================================
-- ========== Listeners
-- =============================================
-- -----------------------------------
-- -------- Space
-- -----------------------------------
for i = 1, 10, 1 do
  local space = spaces[i]
  -- mouse.clicked: Trigger click space funtion.
  space:subscribe("mouse.clicked", click_space)
  -- mouse.exited: Hide space thumbnail.
  space:subscribe("mouse.exited", function(env) space:set({ popup = { drawing = false } }) end)
end


-- -----------------------------------
-- -------- Space Window Observer
-- -----------------------------------
-- NOTE: Sketchybar does not capture all windows, the `yabai_window_created` and `yabai_application_visible` events are used for additional cases.
-- yabai_window_created, yabai_application_visible: Update app icons in space.
space_window_observer:subscribe({ "yabai_window_created", "yabai_application_visible" }, trigger_space_windows_change_event)
-- space_windows_change: Update app icons in space.
space_window_observer:subscribe("space_windows_change", update_space_app)


-- -----------------------------------
-- -------- Space State Observer
-- -----------------------------------
--- Track active space index and type to update space item states accordingly.
local last_idx, last_type = nil, nil
space_state_observer:subscribe({ "forced", "space_change", "skhd_space_type_changed", "yabai_loaded" }, function()
  sbar.exec("yabai -m query --spaces --space", function(focused)
    if type(focused) ~= "table" then return end
    local new_idx, new_type = focused.index, focused.type
    local color = colors.yabai[new_type] or colors.yabai.error

    if last_idx == nil then
      -- CASE1: Initialization
      for i = 1, 10 do
        local s = spaces[i]
        if s then if i == new_idx then set_active(s, color) else set_inactive(s) end end
      end
    elseif last_idx ~= new_idx then
      -- CASE2: Active space changed. Set old to inactive, new to active.
      if spaces[last_idx] then set_inactive(spaces[last_idx]) end
      if spaces[new_idx]  then set_active(spaces[new_idx], color) end
    elseif last_type ~= new_type then
      -- CASE3: Same active space, but type changed. Update bg color.
      sbar.animate("tanh", 5, function() spaces[new_idx]:set({ background = { color = color } }) end)
    end

    last_idx, last_type = new_idx, new_type
  end)
end)


-- -----------------------------------
-- -------- Space Indicator
-- -----------------------------------
-- swap_menus_and_spaces: Toogle indicator icon and label.
space_indicator:subscribe("swap_menus_and_spaces", toggle_indicator)
-- mouse.entered: Expand indicator.
space_indicator:subscribe("mouse.entered", expand_indicator)
-- mouse.exited: Collapse indicator.
space_indicator:subscribe("mouse.exited", collapse_indicator)
-- mouse.clicked: Toogle menus and spaces.
space_indicator:subscribe("mouse.clicked", trigger_swap_menus_and_spaces_event)
