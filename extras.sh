#!/usr/bin/env bash

function open_html_directory() {
    if [ -z "$1" ]; then
    select dir in $(ls -d "${HTML_DIRECTORY}"/*/ | xargs -n 1 basename); do
      if [ -n "$dir" ]; then
        open "${HTML_DIRECTORY}/${dir}"
        exit 0
      else
        echo "Invalid selection"
      fi
    done
  else
    open "${HTML_DIRECTORY}/$1"
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