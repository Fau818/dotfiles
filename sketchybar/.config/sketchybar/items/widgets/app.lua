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
    font = { family = settings.font.nerd_font, style = "Regular", size = 16.5 },
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
    font = { family = settings.font.nerd_font, style = "Regular", size = 17.0 },
    color = colors.app.mail,
    padding_right = 2,
  },
  label = {
    string = "?",
    font = { style = "Medium", size = 13.0 },
    color = colors.white,
    padding_left = 0,
  },
  background = { color = colors.almost_transparent }
}


local discord_config = {
  position = "right",
  click_script = "open -a 'Discord'",
  icon = {
    string = icons.app.discord,
    font = { family = settings.font.nerd_font_alternative, style = "Regular", size = 27.0 },
    color = colors.app.discord,
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
local discord = sbar.add("item", "app.discord", discord_config)
local mail    = sbar.add("item", "app.mail", mail_config)
local wechat  = sbar.add("item", "app.wechat", wechat_config)
local qq      = sbar.add("item", "app.qq", qq_config)

local event_listener = sbar.add("item", "app.event_listener", { drawing = false, updates = true, update_freq = 30 })



-- =============================================
-- ========== Functions
-- =============================================
local function update_app_status(env)
  local app_list = {
    ["qq"] = "com.tencent.qq",
    ["wechat"] = "com.tencent.xinWeChat",
    ["mail"] = "com.apple.mail",
    ["discord"] = "com.hnc.Discord",
  }
  for app_name, app_bundle_id in pairs(app_list) do
    sbar.exec(([[lsappinfo info -only StatusLabel "%s"]]):format(app_bundle_id), function(result)
      -- local label = result:sub(1, -2)
      local label = result:match("%d+") or "0"
      sbar.set(("app.%s"):format(app_name), { label = label })
    end)
  end
end



-- =============================================
-- ========== Listeners
-- =============================================
event_listener:subscribe({ "forced", "routine" }, update_app_status)
