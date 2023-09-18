#!/usr/bin/env bash

function show_help() {
  HELP_TEXT=$(cat << 'EOF'
# mypandoc Help
## Usage
`mypandoc <command> [options]`
## Commands
- **gh <file>...**: Convert to HTML
- **pdf <file>...**: Convert to PDF
- **open [dir]**: Open HTML directory
- **show**: Display settings
- **cfg**: Update settings
- **alias**: Set up alias
- **completion**: Add to ~/.zshrc
- **zshrc**: Set up alias and add to ~/.zshrc

## Options
- **help**: Show help

## Setup Help
1. Custom CSS: Set `CUSTOM_GITHUB_CSS`.
2. Change directories: Modify `HTML_DIRECTORY` and `PDF_DIRECTORY`.
3. Alias: Match `SCRIPT_NAME`, run from script directory.
4. Completion: Set `ALIAS_NAME`, source .zshrc.
5. Zshrc: Run from script directory, set `ALIAS_NAME`.

## Examples
| Command | Description |
| ------- | ----------- |
| `mypand gh file.md` | Convert to HTML |
| `mypand pdf file.md` | Convert to PDF |
| `mypand open` | Open HTML directory |
| `mypand config` | Create config file |
| `mypand edit` | Edit config file |
| `mypand css` | Download custom CSS |
| `mypand show` | Display settings |
EOF
)

  if command -v bat > /dev/null; then
    echo "$HELP_TEXT" | bat --language=markdown --theme=TwoDark
  else
    echo "$HELP_TEXT"
  fi
}