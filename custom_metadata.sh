#!/usr/bin/env bash

typeset -A metadata  # Declare metadata as a global associative array

# Format the name of the markdown file
function format_name() {
  local arg="$1"
  base_name="${arg%.md}"
  name_with_spaces="${base_name//_/ }"
  DEFAULT_TITLE=$(echo "$name_with_spaces" | awk '{ for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2)); }1')
}

# Extract metadata from markdown file
function extract_metadata() {
  local arg="$1"
  while IFS= read -r line; do
    key="${line%%:*}"
    value="${line#*:}"
    sanitized_key=$(echo "$key" | tr -d '[:space:]#')
    metadata["$sanitized_key"]="$value"
  done < <(grep '^# [a-zA-Z]*:' "$arg")

  # Fallback to defaults if not set
  [ -z "${metadata[Title]}" ] && metadata[Title]="$DEFAULT_TITLE"
  [ -z "${metadata[Author]}" ] && metadata[Author]="$DEFAULT_AUTHOR"
  [ -z "${metadata[Keywords]}" ] && metadata[Keywords]="$DEFAULT_KEYWORDS"
  [ -z "${metadata[Subtitle]}" ] && metadata[Subtitle]="$DEFAULT_SUBTITLE"
  [ -z "${metadata[Description]}" ] && metadata[Description]="$DEFAULT_DESCRIPTION"
  [ -z "${metadata[Language]}" ] && metadata[Language]="$DEFAULT_LANGUAGE"
}

function create_target_directory() {
  html_target_dir="${HTML_DIRECTORY}/${last_folder}"
  pdf_target_dir="${PDF_DIRECTORY}/${last_folder}"

  [ ! -d "$html_target_dir" ] && mkdir -p "$html_target_dir"
  [ ! -d "$pdf_target_dir" ] && mkdir -p "$pdf_target_dir"
}

function process_metadata() {
  local arg="$1"
  sed -f- "$arg" << SED_SCRIPT
  /^# Subtitle:/d
  /^# Author:/d
  /^# Keywords:/d
  /^# Title:/d
  /^# Description:/d
  /^# Date:/d
  /^# Language:/d
SED_SCRIPT
}

function generate_metadata_args() {
  export metadata_args=(
    "--metadata" "date=${metadata[Date]}"
    "--metadata" "subtitle=${metadata[Subtitle]}"
    "--metadata" "keywords=${metadata[Keywords]}"
    "--metadata" "title=${metadata[Title]}"
    "--metadata" "description=${metadata[Description]}"
    "--metadata" "lang=${metadata[Language]}"
  )
}

