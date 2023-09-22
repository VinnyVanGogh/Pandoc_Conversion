#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")

source "$SCRIPT_DIR/Help_and_Setup/help.sh"
source "$SCRIPT_DIR/Help_and_Setup/setup.sh"
source "$SCRIPT_DIR/Functions/custom_metadata.sh"
source "$SCRIPT_DIR/Functions/conversion.sh"
source "$SCRIPT_DIR/Functions/extras.sh"
source "$SCRIPT_DIR/Configuration/my_pandoc.cfg"


command="$1"
shift

case $command in
  setup)
    setup_environment
    ;;
  gh)
    github_html "$@"
    joined_args=$(combine_args "$@")
    printf "${BOLD_ITALICS}Converted:${NC} ${CYAN}%s${NC} ${BOLD_ITALICS}to HTML and saved to:${NC} ${PURPLE}%s/%s${NC}\n" "$joined_args" "$HTML_DIRECTORY" "$last_folder"
    ;;
  pdf)
    pdf "$@"
    joined_args=$(combine_args "$@")
    printf "${BOLD_ITALICS}Converted:${NC} ${CYAN}%s${NC} ${BOLD_ITALICS}to PDF and saved to:${NC} ${PURPLE}%s/%s${NC}\n" "$joined_args" "$PDF_DIRECTORY" "$last_folder"
    ;;
  open)
    open_directory "$@"
    ;;
  show)
    display_config
    ;;
  edit)
    update_config
    ;;
  help)
    show_help
    ;;
  config)
    create_config_file
    ;;
  css)
    download_github_css
    ;;
  alias)
    setup_mypand_alias
    ;;
  completion)
    add_completion_to_zshrc
    ;;
  *)
    echo "Invalid command: $command"
    exit 1
    ;;
esac
