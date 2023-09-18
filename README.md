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
- [License](#license)

## Prerequisites

- Bash
- Zsh (optional) - for setting up the alias and completion script
- Pandoc
- jq

## Installation

1. Clone this repository.
2. Run `./pandoc_conversion.sh setup` to set up the configuration file, and be prompted yes/no to download the GitHub CSS file, set up the alias default is `mypand`, and add the autocompletion script for `mypand open` to your .zshrc file.
   - **Note:** You can also run the individual commands if you skip any and want to add them later. 
   **_Shown below._**

- Run `./pandoc_conversion.sh config` to set up the configuration file. 
- Run `./pandoc_conversion.sh css` to download the GitHub CSS file to the current directory.
  - **Note:** If you want to use a different custom CSS file, set the `CUSTOM_GITHUB_CSS` variable in the config file; otherwise, it will use the one downloaded from GitHub.
- Modify the configuration file using `./pandoc_conversion.sh edit`.
- Run `./pandoc_conversion.sh zshrc` to set up the alias and completion script.
  - You can also run `./pandoc_conversion.sh alias` and `./pandoc_conversion.sh completion` separately.
    - **Note:** The default alias name is `mypand`. You can change this in the config file.
- If you are not setting an alias and plan to run this from outside the directory, make sure to chmod +x the script.
    - **Note** if you do choose to set an alias, setting an alias will automatically chmod +x the script for you, so long as the SCRIPT_NAME variable is set in the config file, and you run it from the directory the script is in.

## Usage

`mypand <command> [options]`

### Commands

- `./pandoc_conversion.sh setup`: Sets up a default configuration file, prompts you to download the CSS, setup the alias, and add the completion script to your .zshrc file. **You can also run the individual commands if you skip any and want to add them later.**
- `./pandoc_conversion.sh gh <file>...`: Convert markdown files to HTML using GitHub CSS
- `./pandoc_conversion.sh pdf <file>...`: Convert markdown files to PDF
- `./pandoc_conversion.sh open [pdf/html]`: List the HTML or PDF directories and input a number to open one
- `./pandoc_conversion.sh show`: Display the current configuration settings
- `./pandoc_conversion.sh edit`: Update the configuration settings
- `./pandoc_conversion.sh alias`: Set up the mypand alias (set the alias name in your config file)
- `./pandoc_conversion.sh completion`: Add completion script to ~/.zshrc to enable tab completion for the open command
- `./pandoc_conversion.sh css`: Download the GitHub CSS file to the current directory
- **Note:** The default alias name is `mypand`. You can change this in the config file.
  - **You can run the script directly if you'd rather not set up the alias in that case, replace mypand with ./pandoc_conversion.sh or /path/to/script/my_custom_pandoc.sh in the examples below.**
- `mypand help`: Show a help message, similar to the readme but toned down a bit.

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
