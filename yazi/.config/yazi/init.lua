---@diagnostic disable: undefined-global

require("full-border"):setup()


-- -- =============================================
-- -- ========== Show Symbol Link
-- -- =============================================
function Status:name()
  local h = cx.active.current.hovered
  if not h then return ui.Span("") end

  local linked = ""
  if h.link_to ~= nil then linked = " -> " .. tostring(h.link_to) end
  return ui.Span(" " .. h.name .. linked)
end



-- =============================================
-- ========== Show User/Group of Files
-- =============================================
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line {}
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	}
end, 500, Status.RIGHT)



-- =============================================
-- ========== Show Username and Hostname
-- =============================================
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line {}
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)
