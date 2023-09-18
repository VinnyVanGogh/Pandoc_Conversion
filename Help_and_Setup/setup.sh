#!/usr/bin/env bash

# Define the path to the config file
export CONFIG_FILE="./Configuration/my_pandoc.cfg"

create_config_file() {
  # Check if config file exists
  if [[ ! -f $CONFIG_FILE ]]; then
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$CONFIG_FILE")"
    
    # Create config file with default values
    cat <<- 'EOL' > "$CONFIG_FILE"
# This is your configuration file for the pandoc conversion script, anything that you want to change should be changed here.

# Name of the main script
SCRIPT_NAME="pandoc_conversion.sh"

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
PANDOC_HTML_ARGS="--toc -s -f markdown -t html5 --css='$CUSTOM_GITHUB_CSS'" # Change this to your desired HTML arguments by default it uses github darkmode css
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

# URL for downloading the custom CSS file
FILE_URL="https://api.github.com/repos/OzakIOne/markdown-github-dark/contents/github-markdown.css" # Change this to your desired URL by default it uses the github darkmode css

# Define the path for the custom GitHub CSS
CUSTOM_GITHUB_CSS="${HOME}/Documents/configs/templates/github-darkmode-markdown.css" # Change this to your desired path by default it saves to Documents/configs/templates as github-darkmode-markdown.css
EOL
    chmod +x "$CONFIG_FILE"
    echo "Config file created at: $CONFIG_FILE"
  else
    echo "Config file already exists at: $CONFIG_FILE"
  fi
}

download_css() {
  # Create the directory if it doesn't exist
  mkdir -p "$(dirname "$CUSTOM_GITHUB_CSS")"
  # Download the custom CSS file from GitHub
  curl -s "$FILE_URL" \
  | jq -r '.content' \
  | base64 --decode > "$CUSTOM_GITHUB_CSS"

  echo "Custom CSS file downloaded to: $CUSTOM_GITHUB_CSS"
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
  local ALIAS_NAME="$1"
  ALIAS_NAME=$(grep '^ALIAS_NAME=' "$CONFIG_FILE" | cut -d'=' -f2)

  # If ALIAS_NAME is not set in the config file, use a default value
  if [ -z "$ALIAS_NAME" ]; then
    ALIAS_NAME="mypand"
  fi

  # Ensure the script is executable
  chmod +x "$SCRIPT_NAME"

  # Create the alias in zshrc
  echo "alias ${ALIAS_NAME//\"}=\"$PWD/$SCRIPT_NAME\"" >> "${HOME}/.zshrc"

  # Reload the zshrc file to apply the alias immediately
  source "${HOME}/.zshrc"

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

setup_environment() {
  # Create the config file if it doesn't exist
  create_config_file

  # Variable to store user input
  local user_input

  # Alias setup
  echo -n "Do you want to create an alias for the script? [y/n]: "
  read -r user_input
  if [[ $user_input =~ ^[yY](es)?$ ]]; then
    echo -n "Enter alias name [Default: mypand]: "
    read -r alias_name
    alias_name=${alias_name:-mypand}
    
    # Update the config file
    sed -i '' "s/^ALIAS_NAME=.*/ALIAS_NAME=\"$alias_name\"/" "$CONFIG_FILE"
    
    # Call the alias setup function with the new alias name
    setup_mypand_alias "$alias_name"
  fi

  # Autocomplete setup for Zsh
  echo -n "Do you want to setup autocomplete in Zsh? [y/n]: "
  read -r user_input
  if [[ $user_input =~ ^[yY](es)?$ ]]; then
    add_completion_to_zshrc
  fi

  # Download CSS
  echo -n "Do you want to download the custom CSS? [y/n]: "
  read -r user_input
  if [[ $user_input =~ ^[yY](es)?$ ]]; then
    download_css
  fi
}