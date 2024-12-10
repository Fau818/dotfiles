local function is_builtin_display()
  local command = [[echo $(system_profiler SPDisplaysDataType | grep -B 3 'Main Display:' | awk '/Display Type/ {print $3}')]]
  local handle = io.popen(command)
  if handle then
    -- If is builtin display, it will be "Built-In"
    local result = handle:read("*a"):sub(1, -2)
    handle:close()
    return result == "Built-In"
  end
  return true  -- Default
end


return {
  media_offset = is_builtin_display() and 45 or 375
}
