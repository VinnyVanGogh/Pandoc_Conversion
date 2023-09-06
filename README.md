# mypandoc

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A script for converting markdown files to HTML and PDF with custom styles.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Commands](#commands)
  - [Options](#options)
  - [Setup Help](#setup-help)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Acknowledgments](#acknowledgments)
- [Screenshots](#screenshots)
- [Changelog](#changelog)
- [Compatibility](#compatibility)
- [Security Considerations](#security-considerations)
- [License](#license)

## Prerequisites

- Bash
- Pandoc
- jq

## Installation

1. Clone this repository.
2. Modify the configuration file `my_pandoc_config.sh` to customize settings.
3. Run `./mypandoc zshrc` to set up the alias and completion script.

## Usage

`mypandoc <command> [options]`

## Commands

- **gh <file>...**: Convert markdown files to HTML using GitHub CSS
- **pdf <file>...**: Convert markdown files to PDF
- **open [dir]**: Open the HTML directory in Finder
- **show**: Display the current configuration settings
- **cfg**: Update the configuration settings
- **alias**: Set up the mypand alias (set the alias name in your config file)
- **completion**: Add completion script to ~/.zshrc to enable tab completion for the open command
- **zshrc**: Set up the mypand alias and add completion script to ~/.zshrc in one command

## Options

- **help**: Show this help message

## Setup Help

When running certain commands, make sure variables are set up properly in the config file:

1. To use a custom CSS file, set the `CUSTOM_GITHUB_CSS` variable in the config file; otherwise, it will use the one downloaded from GitHub.
2. To change the directories where files are saved, modify the `HTML_DIRECTORY` and `PDF_DIRECTORY` variables in the config file.
3. When using the alias command, ensure your script's name matches the `SCRIPT_NAME` variable in the config file.
   - **To change the alias name, modify the `ALIAS_NAME` variable in the config file.**
   - **Run the script from the directory where it is saved when setting up the alias.**
4. When using the completion command, make sure the `ALIAS_NAME` variable is set in the config file and your .zshrc or another file you're sourcing.
   - **Autocompletion will be set up for the open command; everything else works best with default autocomplete.**
   - **You can run this from any directory.**
5. If you want to set up both the alias and completion in one go by using the zshrc command, make sure you have the `ALIAS_NAME` variable set in the config file.
   - **Run the script from the directory where it is saved when setting up the alias.**
6. You can customize various other options like Default metadata and Pandoc arguments in the config file.

## Examples

| Command                        | Description                                       |
| ------------------------------ | ------------------------------------------------- |
| `mypand gh file.md`            | Convert a single markdown file to HTML            |
| `mypand gh file1.md file2.md`  | Convert multiple markdown files to HTML           |
| `mypand pdf file.md`           | Convert a single markdown file to PDF             |
| `mypand pdf file1.md file2.md` | Convert multiple markdown files to PDF            |
| `mypand open`                  | Open the HTML directory in Finder                 |
| `mypand open 2021-01-01`       | Open a specific HTML directory in Finder          |
| `mypand show`                  | Display the current configuration settings        |
| `mypand cfg`                   | Update the configuration settings                 |
| `mypand alias`                 | Set up the mypand alias (requires config setup)   |
| `mypand help`                  | Show this help message                            |
| `mypand completion`            | Add completion script to ~/.zshrc                 |
| `mypand zshrc`                 | Set up the mypand alias and add completion script |


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)
