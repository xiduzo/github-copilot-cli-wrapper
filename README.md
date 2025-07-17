# Terminal Copilot Explain Helper

This project provides shell functions and helpers to quickly explain your last terminal command using GitHub Copilot CLI, with special support for Apple Terminal.

## Features

- **`??`**: Explains your last (or Nth last) terminal command using GitHub Copilot CLI.
- **`?!`**: Suggests improvements or alternatives for a given command using Copilot CLI.
- **Automatic terminal output capture**: Grabs your recent terminal buffer for context.

## Requirements

- **macOS** (with Apple Terminal)
- [GitHub CLI (`gh`)](https://cli.github.com/)
- [GitHub Copilot CLI extension](https://docs.github.com/en/copilot/how-tos/set-up/installing-github-copilot-in-the-cli)
- Bash or Zsh shell

## Installation

1. **Clone or copy this repo to your machine.**
2. **Install the GitHub CLI and Copilot extension:**
   ```sh
   brew install gh
   gh extension install github/gh-copilot
   ```
3. **Source the script in your shell:**
   ```sh
   source /path/to/custom/explain.sh
   ```
   Or add this line to your `.bashrc` or `.zshrc` for automatic loading.

## Usage

- **Explain the last command:**
  ```sh
  ??
  ```
- **Explain the last N commands:**
  ```sh
  ?? 3
  ```
- **Explain a specific command:**
  ```sh
  ?? "ls -la /tmp"
  ```
- **Get suggestions for a command:**
  ```sh
  ?! "find . -name '*.tmp'"
  ```

## How it Works

- Captures your terminal buffer using AppleScript (for Apple Terminal).
- Cleans up the output, removing empty lines and fixing line endings.
- Extracts the last (or Nth last) command and sends it to `gh copilot explain`.
- Optionally keeps or deletes the temporary buffer file based on the `DEBUG` variable.

## Configuration

- **Debug mode:**  
  Set `DEBUG=1` at the top of `explain.sh` to keep temp files for debugging.  
  Set `DEBUG=0` to auto-delete them after use.

## Limitations

- Only supports Apple Terminal out of the box.
- Requires clipboard access for AppleScript.

## File Overview

- `explain.sh`: Main script with `??` and `?!` functions.
- `copy-apple-terminal.sh`: Helper script to copy Apple Terminal buffer to a file.

## License

MIT License
