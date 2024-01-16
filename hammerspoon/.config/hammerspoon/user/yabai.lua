-- function keybind(type, key, fun)
--   local mods = {
--     WINKEY1 = { "shift", "alt", "fn" }
--   }

-- end


-- BUG: The parameter `message` of LeftRightHotkey:bind is fake.
-- \    The order of the parameters is: `mods`, `key`, `pressedFn`, `releasedFn`, `repeatFn`.
spoon.LeftRightHotkey:bind(
  { "rShift" },
  "h",
  function() os.execute("yabai -m window --resize left:-20:0  || yabai -m window --resize right:-20:0") end,
  nil,
  function() os.execute("yabai -m window --resize left:-20:0  || yabai -m window --resize right:-20:0") end
)

spoon.LeftRightHotkey:bind(
  { "rShift" },
  "j",
  function() os.execute("yabai -m window --resize bottom:0:20 || yabai -m window --resize top:0:20") end,
  nil,
  function() os.execute("yabai -m window --resize bottom:0:20 || yabai -m window --resize top:0:20") end
)

spoon.LeftRightHotkey:bind(
  { "rShift" },
  "k",
  function() os.execute("yabai -m window --resize top:0:-20   || yabai -m window --resize bottom:0:-20") end,
  nil,
  function() os.execute("yabai -m window --resize top:0:-20   || yabai -m window --resize bottom:0:-20") end
)

spoon.LeftRightHotkey:bind(
  { "rShift" },
  "l",
  function() os.execute("yabai -m window --resize right:20:0  || yabai -m window --resize left:20:0") end,
  -- function() os.execute("yabai -m window --resize right:20:0  || yabai -m window --resize left:20:0") end
  nil,
  function() os.execute("yabai -m window --resize right:20:0  || yabai -m window --resize left:20:0") end
)
