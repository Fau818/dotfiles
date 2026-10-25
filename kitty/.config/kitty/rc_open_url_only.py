# Checks password-less remote control requests (kitty.conf: `remote_control_password "" rc_open_url_only.py`).
# Anything printed in a kitty window can send one, so only nvim's `action open_url` for web and mailto links passes.
# NOTE: kitty caches this module; restart kitty after editing it.


def is_cmd_allowed(pcmd, window, from_socket, extra_data):
  """Return True for an `action open_url <web or mailto link>` request, False for any other request."""
  payload = pcmd.get("payload")
  if pcmd.get("cmd") != "action" or not isinstance(payload, dict): return False

  # Exactly `open_url URL`; file:// stays out, as macOS `open` would launch what it points to.
  words = str(payload.get("action", "")).split()
  return len(words) == 2 and words[0] == "open_url" and words[1].startswith(("https://", "http://", "mailto:"))
