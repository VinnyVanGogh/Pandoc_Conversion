#!/usr/bin/env bash
# Define the path to the config file
CONFIG_FILE="${HOME}/Documents/Configs/Pandoc/my_pandoc_config.sh"
# Define GitHub API URL for the file
FILE_URL="https://api.github.com/repos/OzakIOne/markdown-github-dark/contents/github-markdown.css"

# Define the path for the custom GitHub CSS
CUSTOM_GITHUB_CSS="${HOME}/Documents/configs/templates/github-darkmode-markdown.css"

create_config_file() {
  # Check if config file exists
  if [[ ! -f $CONFIG_FILE ]]; then
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$CONFIG_FILE")"
    
    # Create config file with default values
    cat <<- 'EOL' > "$CONFIG_FILE"
#!/usr/bin/env bash
# Script Name
SCRIPT_NAME="my_custom_pandoc.sh"

# Default Directories
HTML_DIRECTORY="${HOME}/Documents/Html" # Change this to your desired directory to save HTML files
PDF_DIRECTORY="${HOME}/Documents/Pdf" # Change this to your desired directory to save PDF files

# Custom CSS File
CUSTOM_GITHUB_CSS="${HOME}/Documents/configs/templates/github-darkmode-markdown.css" # Change this to your custom CSS file, this will be downloaded from GitHub

# Default Metadata
DEFAULT_AUTHOR="Your Name" # Change this to your name
DEFAULT_KEYWORDS="Add # Keywords: <keywords> to override this." # Change this to your desired default keywords
DEFAULT_SUBTITLE="add # Subtitle: <subtitle> to override this." # Change this to your desired default subtitle
DEFAULT_DESCRIPTION="Add # Description: <description> to override this." # Change this to your desired default description
DEFAULT_LANGUAGE="en-US" # Change this to your desired default language

# Pandoc Arguments
PANDOC_HTML_ARGS="--toc -s -f markdown -t html5 --css="$CUSTOM_GITHUB_CSS"" # Change this to your desired HTML arguments by default it uses github darkmode css
PANDOC_PDF_ARGS="--toc -s -f markdown -t pdf --pdf-engine=pdflatex" # Change this to your desired PDF arguments by default it uses pdflatex

# Colors and Formatting
BOLD_ITALICS='\033[4;3m' # Sets the text to bold and italics for the printf function
CYAN='\033[1;36m' # Sets the text to cyan for the printf function
PURPLE='\033[1;35m' # Sets the text to purple for the printf function
NC='\033[0m' # Resets the text to default for the printf function

# Editor
# CFG_EDITOR="code" # Uncomment this line and set your editor of choice default is vim

# Alias Setup
ALIAS_NAME="mypand" # Change this to your desired alias name
EOL
  fi
}

# Download and decode the file using curl and jq
curl -s "$FILE_URL" \
  | jq -r '.content' \
  | base64 --decode > "$CUSTOM_GITHUB_CSS"


# Source the config file
. "$CONFIG_FILE"


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

# Create target directory if it does not exist
function create_target_directory() {
  target_dir="$(dirname "$target")"
  [ ! -d "$target_dir" ] && mkdir -p "$target_dir"
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

# Generate common metadata args for pandoc
function generate_metadata_args() {
  metadata_args=(
    "--metadata" "date=${metadata[Date]}"
    "--metadata" "subtitle=${metadata[Subtitle]}"
    "--metadata" "keywords=${metadata[Keywords]}"
    "--metadata" "title=${metadata[Title]}"
    "--metadata" "description=${metadata[Description]}"
    "--metadata" "lang=${metadata[Language]}"
  )
}

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

# Shared function for common operations
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

function github_pdf() {
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

function open_html_directory() {
    if [ -z "$1" ]; then
    select dir in $(ls -d ${HTML_DIRECTORY}/*/ | xargs -n 1 basename); do
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

# Function to display the current configuration settings
function display_config() {
  if [ -f "$CONFIG_FILE" ]; then
    echo "Current Configuration Settings:"
    bat "$CONFIG_FILE"
  else
    echo "Config file not found."
  fi
}

# Function to update the configuration interactively
function update_config() {
  # Check if the config file exists
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

function show_help() {
  # Create a temporary file for the help message
  temp_file=$(mktemp)
  
  # Use a here document to generate the help message
  cat << EOF > "$temp_file"
# mypandoc Help

## Usage

\`mypandoc <command> [options]\`

## Commands

- **gh <file>...**: Convert markdown files to HTML using GitHub CSS
- **pdf <file>...**: Convert markdown files to PDF
- **open [dir]**: Open the HTML directory in Finder
- **show**: Display the current configuration settings
- **cfg**: Update the configuration settings
- **alias**: Set up the mypand alias (set the alias name in your config file)
- **completion**: Add completion script to ~/.zshrc to enable tab completion for open command
- **zshrc**: Set up the mypand alias and add completion script to ~/.zshrc in one command

## Options

- **help**: Show this help message

## Setup Help

When running certain commands, make sure variables are set up properly in the config file:

1. To use a custom CSS file, set the \`CUSTOM_GITHUB_CSS\` variable in the config file; otherwise, it will use the one downloaded from GitHub.
2. To change the directories where files are saved, modify the \`HTML_DIRECTORY\` and \`PDF_DIRECTORY\` variables in the config file.
3. When using the alias command, ensure your script's name matches the \`SCRIPT_NAME\` variable in the config file.
   - **To change the alias name, modify the \`ALIAS_NAME\` variable in the config file.**
   - **Run the script from the directory where it is saved when setting up the alias.**
4. When using the completion command, make sure the \`ALIAS_NAME\` variable is set in the config file, and your .zshrc or another file you're sourcing.
  - **Autocompletion will be setup for the open command, everything else works best with default autocomplete.**
  - **You can run this from any directory**
5. If you want to setup both the alias and completion in 1 go by using the zshrc command, make sure you have the \`ALIAS_NAME\` variable set in the config file.
  - **Run the script from the directory where it is saved when setting up the alias.**
6. You can customize various other options like Default metadata and Pandoc arguments in the config file.

## Examples

| Command                        | Description                                       |
| ------------------------------ | ------------------------------------------------- |
| \`mypand gh file.md\`            | Convert a single markdown file to HTML            |
| \`mypand gh file1.md file2.md\`  | Convert multiple markdown files to HTML           |
| \`mypand pdf file.md\`           | Convert a single markdown file to PDF             |
| \`mypand pdf file1.md file2.md\` | Convert multiple markdown files to PDF            |
| \`mypand open\`                  | Open the HTML directory in Finder                 |
| \`mypand open 2021-01-01\`       | Open a specific HTML directory in Finder          |
| \`mypand show\`                  | Display the current configuration settings        |
| \`mypand cfg\`                   | Update the configuration settings                 |
| \`mypand alias\`                 | Set up the mypand alias (requires config setup)   |
| \`mypand help\`                  | Show this help message                            |
| \`mypand completion\`            | Add completion script to ~/.zshrc                 |
| \`mypand zshrc\`                 | Set up the mypand alias and add completion script |
EOF

  # Use bat to display the help message with syntax highlighting (Markdown language)
  bat --theme="Dracula" --color=always --language=markdown "$temp_file"
  
  # Remove the temporary file
  rm -f "$temp_file"
}

# Function to set up the mypand alias
# If you changed the script name, please change this in the config file as well
# If you don't want the alias name to be mypand, change that in the config file as well
function setup_mypand_alias() {
  # Check if the config file exists
  if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found. Creating a new one."
    touch "$CONFIG_FILE"
  fi

  # Read the alias name from the config file
  local ALIAS_NAME
  ALIAS_NAME=$(grep '^ALIAS_NAME=' "$CONFIG_FILE" | cut -d'=' -f2)

  # If ALIAS_NAME is not set in the config file, use a default value
  if [ -z "$ALIAS_NAME" ]; then
    ALIAS_NAME="mypand"
  fi

  # Ensure the script is executable
  chmod +x "$SCRIPT_NAME"

  # Create the alias in zshrc
  echo "alias $ALIAS_NAME=\"$PWD/$SCRIPT_NAME\"" >> "$HOME/.zshrc"

  # Reload the zshrc file to apply the alias immediately
  source "$HOME/.zshrc"

  echo "Alias '$ALIAS_NAME' created for '$SCRIPT_NAME'."
}

# Function to add completion script to ~/.zshrc
function add_completion_to_zshrc() {
  # Read the alias name from your config file (Assuming you have a variable named ALIAS_NAME)
  alias_name=$(grep 'ALIAS_NAME=' "$CONFIG_FILE" | cut -d'"' -f2)
  
  # Check if alias_name is empty (i.e., not found in the config file)
  if [ -z "$alias_name" ]; then
    echo "Alias name not found in the config file."
    echo "Please set the ALIAS_NAME variable in your config file."
    return 1
  fi

  # Define the completion script function with the alias name
  completion_script="_${alias_name}_completion() {
    local -a subdirs
    local base_dir=\"\$HTML\"

    # Populate array with subdirectories only
    subdirs=(\"\${base_dir}\"/*(/:t))

    case \$words[2] in
      open)
        _describe -t subdirs 'subdirectory' subdirs
        ;;
      *)
        _files -W \$base_dir  # For filename completion
        ;;
    esac
  }

  compdef _${alias_name}_completion $alias_name"

  # Add the completion script function to ~/.zshrc
  echo "$completion_script" >> ~/.zshrc

  echo "Completion script added to ~/.zshrc for alias: $alias_name"
}


command="$1"
shift

case $command in
  gh)
    github_html "$@"
    joined_args=$(combine_args "$@")
    printf "${BOLD_ITALICS}Converted:${NC} ${CYAN}%s${NC} ${BOLD_ITALICS}to HTML and saved to:${NC} ${PURPLE}%s/%s${NC}\n" "$joined_args" "$HTML_DIRECTORY" "$last_folder"
    ;;
  pdf)
    github_pdf "$@"
    joined_args=$(combine_args "$@")
    printf "${BOLD_ITALICS}Converted:${NC} ${CYAN}%s${NC} ${BOLD_ITALICS}to PDF and saved to:${NC} ${PURPLE}%s/%s${NC}\n" "$joined_args" "$PDF_DIRECTORY" "$last_folder"
    ;;
  open)
    open_html_directory "$@"
    ;;
  show)
    display_config
    ;;
  cfg)
    update_config
    ;;
  help)
    show_help
    ;;
  config)
    create_config_file
    ;;
  alias)
    setup_mypand_alias
    ;;
  completion)
    add_completion_to_zshrc
    ;;
  zshrc)
    setup_mypand_alias
    add_completion_to_zshrc
    ;;
  *)
    echo "Invalid command: $command"
    exit 1
    ;;
esac
