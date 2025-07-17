# ~/custom/explain.sh

# 1 = enabled, 0 = disabled
DEBUG=0

OUTFILE_TEMPLATE="/tmp/shell/terminal_export_%s.txt"

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Please source this script: 'source explain.sh' or '. explain.sh'"
  return 1 2>/dev/null || exit 1
fi

debug() {
  if [[ "$DEBUG" == "1" ]]; then
    echo "DEBUG: $*"
  fi
}

info() {
  echo "INFO: $*"
}

verifyGithubCopilotIsInstalled() {
  if ! command -v gh &>/dev/null; then
    info "GitHub CLI (gh) is not installed. Please install it from https://cli.github.com/."
    return 1
  fi
  if ! gh extension list | grep -q 'copilot'; then
    info "GitHub Copilot CLI extension is not installed. Install it from https://docs.github.com/en/copilot/how-tos/set-up/installing-github-copilot-in-the-cli"
    return 1
  fi
}

saveTerminalOutput() {
  local session_id="$(tty | sed 's#/dev/##;s#/#_#g')_$$"
  local outfile
  printf -v outfile "$OUTFILE_TEMPLATE" "$session_id"
  TERMINAL_EXPORT_FILE="$outfile"

  if [[ -n "$ITERM_PROFILE" ]]; then
    info "iTerm2 not supported"
    return 1
  elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    bash ~/custom/copy-apple-terminal.sh "$outfile"
  elif [[ -n "$KITTY_WINDOW_ID" ]]; then
    info "Kitty not supported"
    return 1
  else
    info "Unknown or unsupported terminal."
    return 1
  fi
}

# Define the ?? function with telemetry disabled
explain() {
  export GH_COPILOT_NO_TELEMETRY=1
  verifyGithubCopilotIsInstalled || return 1
  if [[ $# -eq 0 ]]; then
    saveTerminalOutput
    cmd=$(LC_CTYPE=C tr '\r' '\n' < "$TERMINAL_EXPORT_FILE" | grep -v '^[[:space:]]*$' | sed '$d' | tail -n 1)
    gh copilot explain "$cmd"
    debug "asked about $cmd"
  elif [[ $1 =~ ^[0-9]+$ ]]; then
    saveTerminalOutput
    cmd=$(LC_CTYPE=C tr '\r' '\n' < "$TERMINAL_EXPORT_FILE" | grep -v '^[[:space:]]*$' | sed '$d' | tail -n "$1")
    gh copilot explain "$cmd"
    debug "asked about $cmd"
  else
    gh copilot explain "$*"
  fi

  if [[ "$DEBUG" != "1" ]]; then
    rm -f "$TERMINAL_EXPORT_FILE"
  fi
}

suggest() {
  gh copilot suggest "$*"
}


alias '??'=explain
alias '?!'=suggest