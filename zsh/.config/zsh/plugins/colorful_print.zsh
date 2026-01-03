# =============================================
# ======== Colorful Print
# =============================================
function echo_black()  { echo "\e[90m$1\e[0m" }
function echo_red()    { echo "\e[91m$1\e[0m" }
function echo_green()  { echo "\e[92m$1\e[0m" }
function echo_yellow() { echo "\e[93m$1\e[0m" }
function echo_blue()   { echo "\e[94m$1\e[0m" }
function echo_purple() { echo "\e[95m$1\e[0m" }
function echo_cyan()   { echo "\e[96m$1\e[0m" }
function echo_white()  { echo "\e[97m$1\e[0m" }


# =============================================
# ======== Status Print
# =============================================
function echo_info()  { echo "\e[1;34m[INFO]\e[0m $1" }
function echo_ok()    { echo "\e[1;32m[OK]\e[0m $1" }
function echo_warn()  { echo "\e[1;33m[WARN]\e[0m $1" }
function echo_error() { echo "\e[1;31m[ERROR]\e[0m $1" }
