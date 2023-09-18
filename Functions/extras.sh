#!/usr/bin/env bash

function open_directory() {
  local type="$1"  # 'pdf' or 'html'
  local arg="$2"   # optional directory name
  local target_directory=""

  if [ "$type" == "pdf" ]; then
    target_directory="$PDF_DIRECTORY"
  elif [ "$type" == "html" ]; then
    target_directory="$HTML_DIRECTORY"
  else
    echo "Invalid type. Use 'pdf' or 'html'."
    return 1
  fi

  if [ -z "$arg" ]; then
    select dir in $(ls -d "${target_directory}"/*/ | xargs -n 1 basename); do
      if [ -n "$dir" ]; then
        open "${target_directory}/${dir}"
        exit 0
      else
        echo "Invalid selection"
      fi
    done
  else
    open "${target_directory}/$arg"
    exit 0
  fi
}

function display_config() {
  if [ -f "$CONFIG_FILE" ]; then
    echo "Current Configuration Settings:"
    bat "$CONFIG_FILE"
  else
    echo "Config file not found."
  fi
}

function update_config() {
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found. Creating a new one."
    touch "$CONFIG_FILE"
  fi

  # Check if CFG_EDITOR is defined in the config file, otherwise use Vim as a fallback
  if [ -z "$CFG_EDITOR" ]; then
    editor="vim"  # Default editor is Vim
  else
    editor="$CFG_EDITOR"
  fi

  # Use the specified text editor to allow the user to update the config file
  $editor "$CONFIG_FILE"

  echo "Configuration settings opened in $editor."
}