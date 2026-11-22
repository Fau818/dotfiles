# Pane mode: tmux's keys with no prefix, entered with ctrl+s; kitty.conf includes the map lines this prints.
#   1. ctrl+s enters `hold`, whose keys keep it on.
#   2. On releasing ctrl+s, Karabiner (karabiner.json, kitty only) sends esc, which leaves the mode, or f20 if
#      nothing else was pressed, which switches to `pane`, left after its next key.
#   3. Both modes get the same keys below.

ON = "set_colors --all --configured tab_bar_background=#FF966C active_border_color=#FF966C"
OFF = "pop_keyboard_mode : set_colors --reset"

KEYS = {
  # ┄┄┄ Split and Layout
  "x": "close_window_with_confirmation ignore-shell",
  "shift+5": "launch --location=vsplit --cwd=current",
  "shift+apostrophe": "launch --location=hsplit --cwd=current",
  "z": "toggle_layout stack",
  "space": "layout_action rotate",  # A side-by-side split turns stacked, and back.
  # ┄┄┄ Move
  "left": "neighboring_window left",
  "down": "neighboring_window down",
  "up": "neighboring_window up",
  "right": "neighboring_window right",
  "h": "neighboring_window left",
  "j": "neighboring_window down",
  "k": "neighboring_window up",
  "l": "neighboring_window right",
  ";": "nth_window -1",
  "shift+[": "move_window_backward",
  "shift+]": "move_window_forward",
  # ┄┄┄ Resize
  "shift+left": "resize_window narrower",
  "shift+down": "resize_window shorter",
  "shift+up": "resize_window taller",
  "shift+right": "resize_window wider",
  "shift+h": "resize_window narrower",
  "shift+j": "resize_window shorter",
  "shift+k": "resize_window taller",
  "shift+l": "resize_window wider",
  "equal": "resize_window reset",
  # ┄┄┄ Tab
  "c": "launch --type=tab --cwd=current",
  "shift+1": "detach_window new-tab",
  "n": "next_tab",
  "p": "previous_tab",
  **{str(n): f"goto_tab {n}" for n in range(1, 10)},
}

# NOTE: These open a prompt or a list, so they leave the mode first, or its keys would swallow what is typed there.
PROMPTS = {
  "q": "focus_visible_window",
  # 'w': 'select_tab',
  ",": "set_tab_title",
  "[": "show_scrollback",
}

# NOTE: No keyboard has f34 or f35, so only the maps below enter them.
print("map --new-mode hold --on-unknown ignore f34")
print("map --new-mode pane --on-unknown ignore f35")

print(f"map ctrl+s combine : push_keyboard_mode hold : {ON}")
print("map --mode hold f20 combine : pop_keyboard_mode : push_keyboard_mode pane")

# NOTE: As tmux's prefix pressed twice: ctrl+s reaches the program. Its own tap's f20 then arrives with no mode on.
print(f"map --mode pane ctrl+s combine : {OFF} : send_key ctrl+s")
print("map f20 no_op")

for mode in ("hold", "pane"):
  for key in ("esc", "a"):
    print(f"map --mode {mode} {key} combine : {OFF}")
  for key, action in PROMPTS.items():
    print(f"map --mode {mode} {key} combine : {OFF} : {action}")

for key, action in KEYS.items():
  print(f"map --mode hold {key} {action}")
  print(f"map --mode pane {key} combine : {OFF} : {action}")
