-- =============================================
-- ========== Config
-- =============================================
local qq_config = {
  position = "right",
  click_script = "open -a 'QQ'",
  padding_left = 2 * settings.group_padding,
  padding_right = settings.item_padding,
  icon = {
    string = icons.app.qq,
    font = { family = settings.font.nerd_font, style = "Regular", size = 18.0 },
    color = colors.app.qq,
    padding_right = 1,
  },
  label = {
    string = "?",
    font = { style = "Medium", size = 13.0 },
    color = colors.white,
    padding_left = 0,
  },
  background = { color = colors.almost_transparent }
}


local wechat_config = {
  position = "right",
  click_script = "open -a 'WeChat'",
  padding_right = settings.item_padding,
  icon = {
    string = icons.app.wechat,
    font = { family = settings.font.nerd_font, style = "Regular", size = 19.0 },
    color = colors.app.wechat,
    padding_right = 1,
  },
  label = {
    string = "?",
    font = { style = "Medium", size = 13.0 },
    color = colors.white,
    padding_left = 0,
  },
  background = { color = colors.almost_transparent }
}


local mail_config = {
  position = "right",
  click_script = "open -a 'Mail'",
  icon = {
    string = icons.app.mail,
    font = { family = settings.font.nerd_font, style = "Regular", size = 18.0 },
    color = colors.app.mail,
    padding_right = 1,
  },
  label = {
    string = "?",
    font = { style = "Medium", size = 13.0 },
    color = colors.white,
    padding_left = 0,
  },
  background = { color = colors.almost_transparent }
}


-- =============================================
-- ========== Setup
-- =============================================
local mail   = sbar.add("item", "app.mail", mail_config)
local wechat = sbar.add("item", "app.wechat", wechat_config)
local qq     = sbar.add("item", "app.qq", qq_config)

local event_listener = sbar.add("item", "app.event_listener", { drawing = false, updates = true, update_freq = 30 })



-- =============================================
-- ========== Functions
-- =============================================
local function update_app_status(env)
  local app_list = { "qq", "wechat", "mail" }
  for _, app_name in ipairs(app_list) do
    if app_name == "mail" then
      sbar.exec([[osascript -e 'tell application "Mail" to return the unread count of inbox']], function(result)
        local label = result:sub(1, -2)
        sbar.set(("app.%s"):format(app_name), { label = label })
      end)
    else
      sbar.exec(([[lsappinfo -all list | grep "%s" | egrep -o "\"StatusLabel\"=\{ \"label\"=\"?(.*?)\"? \}" | sed 's/\"StatusLabel\"={ \"label\"=\(.*\) }/\1/g']]):format(app_name), function(result)
        local label = result:sub(1, -2)
        label = label:match("%d+") or 0
        sbar.set(("app.%s"):format(app_name), { label = label })
      end)
    end
  end

end



-- =============================================
-- ========== Listeners
-- =============================================
event_listener:subscribe({ "forced", "routine" }, update_app_status)
