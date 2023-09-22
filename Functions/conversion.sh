#!/usr/bin/env bash

function convert_md_to_html() {
  local arg="$1"
  generate_metadata_args
  process_metadata "$arg" | pandoc \
    "${metadata_args[@]}" \
    $PANDOC_HTML_ARGS \
    -o "$target" -
}

function convert_md_to_pdf() {
  local arg="$1"
  generate_metadata_args
  process_metadata "$arg" | pandoc \
    "${metadata_args[@]}" \
    $PANDOC_PDF_ARGS \
    -o "$target" -
}

function prepare_conversion() {
  full_path=$(realpath "$1")
  dir_name=$(dirname "$full_path")
  last_folder=$(basename "$dir_name")
  format_name "$1"
  extract_metadata "$1"
  create_target_directory
}

function github_html() {
  for arg in "$@"; do
    prepare_conversion "$arg"
    target="${HTML_DIRECTORY}/${last_folder}/${base_name##*/}.html"
    convert_md_to_html "$arg"
  done
}

function pdf() {
  for arg in "$@"; do
    prepare_conversion "$arg"
    target="${PDF_DIRECTORY}/${last_folder}/${base_name##*/}.pdf"
    convert_md_to_pdf "$arg"
  done
}

combine_args() {
  local arg
  local joined_args=""
  local last_index=$# 

  for ((i = 1; i <= last_index; i++)); do
    arg=$1
    shift

    if [ "$i" -eq "$last_index" ]; then
      if [ "$last_index" -gt 1 ]; then
        joined_args+="and "
      fi
      joined_args+="$arg"
    else
      joined_args+="$arg, "
    fi
  done
  printf "%s" "$joined_args"
}