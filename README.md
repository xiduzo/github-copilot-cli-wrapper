# Terminal Copilot Explain Helper

*A dumb experimental github copilot cli wrapper*

Ever wish you could ask GitHub Copilot to explain what you just did in your terminal, but with as little sophistication as possible? Meet `github-copilot-cli-wrapper`: a gloriously simple, slightly hacky, and very experimental set of shell functions that let you throw your last terminal line (or a few) at Copilot CLI and see what it thinks. 

It grabs your terminal buffer, cleans it up (sort of), and asks Copilot to explain or suggest improvements—because sometimes you just want answers, and you want them now, even if the method is a bit... dumb. Apple Terminal only, clipboard shenanigans included. Use at your own risk (and amusement)!

## Features

- **`??`**: Explains your last (or Nth last) terminal line(s) using GitHub Copilot CLI.
- **`?!`**: Suggests improvements or alternatives for a given line or lines using Copilot CLI.

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
   source /path/to/custom/github-copilot-cli-wrapper.sh
   ```
   Or add this line to your `.bashrc` or `.zshrc` for automatic loading.

## Usage

| Command                        | Description                                      |
|--------------------------------|--------------------------------------------------|
| `??`                           | Explain the most recent terminal line             |
| `?? 3`                         | Explain the last 3 terminal lines                 |
| `?? "ls -la /tmp"`             | Explain the given command or text                 |
| `?!`                           | Suggest for the most recent terminal line         |
| `?! 3`                         | Suggest for the last 3 terminal lines             |
| `?! "find . -name '*.tmp'"`    | Suggest for a given command or text               |

**Note:** The number argument to `??` or `?!` refers to lines, not necessarily full shell commands. This means multi-line commands or outputs are treated as separate lines.

## How it Works

- Captures your terminal buffer using AppleScript (for Apple Terminal).
- Cleans up the output, removing empty lines and fixing line endings.
- Extracts the last (or Nth last) line(s) and sends them to `gh copilot explain` or `gh copilot suggest`.

## Configuration

- **Debug mode:**  
  Set `DEBUG=1` at the top of `github-copilot-cli-wrapper.sh` to keep temp files for debugging.  
  Set `DEBUG=0` to auto-delete them after use.

## Limitations

- Only supports Apple Terminal out of the box.
- Requires clipboard access for AppleScript.

## File Overview

- `github-copilot-cli-wrapper.sh`: Main script with `??` and `?!` functions.
- `copy-apple-terminal.sh`: Helper script to copy Apple Terminal buffer to a file.

## License

MIT License
