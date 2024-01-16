#!/bin/bash
# WARNING: Unused

# -----------------------------------
# -------- Initialization
# -----------------------------------
# Config path definition
ZSH_CONFIG_DIR="$HOME/.config/zsh"
TARGET_FILE="$ZSH_CONFIG_DIR/installer.sh"

# Create the target file and add title
cat > "$TARGET_FILE" <<EOF
#!/bin/bash
# ****************************************************************************
# ******************** Install script for Ubuntu or MacOS ********************
# ****************************************************************************
# Automatically generated on $(date)
# ****************************************************************************

EOF


# -----------------------------------
# -------- Functions
# -----------------------------------
# Source file
function source_file() {
  local file_path="$1"; eval file_path=$file_path
  if [[ -f "$file_path" ]]; then read_file "$file_path"
  else echo "# Tried to source $file_path but file not found" >> $TARGET_FILE
  fi
}

# Read file
function read_file() {
  local path="$1"
  # File Begin
  local delimiter='******************************'
  echo "# $delimiter* $path BEGIN *$delimiter" >> $TARGET_FILE
  # File Process
  while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^source ]]; then
      local sourced_file=$(echo $line | sed -e 's/source \(.*\)$/\1/')
      source_file "$sourced_file"
    else echo "$line" >> $TARGET_FILE
    fi
  done < "$path"
  # File End
  echo "# $delimiter* $path END *$delimiter" >> $TARGET_FILE
}


# -----------------------------------
# -------- Startup
# -----------------------------------
# Process config files
config_files=("$DOTFILE_PATH/zsh/.zshenv" "$ZSH_CONFIG_DIR/.zprofile" "$ZSH_CONFIG_DIR/.zshrc")
for file in "${config_files[@]}"; do
  if [[ -f "$file" ]]; then read_file "$file"; fi
done

# Finish!
echo "Merging complete. Your new configuration is at $TARGET_FILE"
