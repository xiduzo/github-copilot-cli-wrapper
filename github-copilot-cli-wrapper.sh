# ~/custom/explain.sh

# 1 = enabled, 0 = disabled
DEBUG=1

OUTFILE_TEMPLATE="/tmp/shell/terminal_export_%s.txt"
GH_COPILOT_NO_TELEMETRY=1


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  _info "Please source this script: 'source explain.sh' or '. explain.sh'"
  return 1 2>/dev/null || exit 1
fi

_debug() {
  if [[ "$DEBUG" == "1" ]]; then
    echo "DEBUG: $*"
  fi
}

_info() {
  echo "INFO: $*"
}

_verifyGithubCopilotIsInstalled() {
  if ! command -v gh &>/dev/null; then
    _info "GitHub CLI (gh) is not installed. Please install it from https://cli.github.com/."
    return 1
  fi
  if ! gh extension list | grep -q 'copilot'; then
    _info "GitHub Copilot CLI extension is not installed. Install it from https://docs.github.com/en/copilot/how-tos/set-up/installing-github-copilot-in-the-cli"
    return 1
  fi
}

_saveTerminalOutput() {
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

_getLastLinesFromFile() {
  local file="$1"
  local n="${2:-1}"
  LC_CTYPE=C tr '\r' '\n' < "$file" | grep -v '^[[:space:]]*$' | sed '$d' | tail -n "$n"
}

explain() {
  _verifyGithubCopilotIsInstalled || return 1
  if [[ $# -eq 0 ]]; then
    _saveTerminalOutput
    cmd=$(_getLastLinesFromFile "$TERMINAL_EXPORT_FILE")
    gh copilot explain "$cmd"
    _debug "EXPLAIN: $cmd"
  elif [[ $1 =~ ^[0-9]+$ ]]; then
    _saveTerminalOutput
    cmd=$(_getLastLinesFromFile "$TERMINAL_EXPORT_FILE" "$1")
    gh copilot explain "$cmd"
    _debug "EXPLAIN: $cmd"
  else
    gh copilot explain "$*"
  fi

  if [[ "$DEBUG" != "1" ]]; then
    rm -f "$TERMINAL_EXPORT_FILE"
  fi
}

suggest() {
  _verifyGithubCopilotIsInstalled || return 1
  if [[ $# -eq 0 ]]; then
    _saveTerminalOutput
    cmd=$(_getLastLinesFromFile "$TERMINAL_EXPORT_FILE")
    gh copilot suggest "$cmd"
    _debug "SUGGEST: $cmd"
  elif [[ $1 =~ ^[0-9]+$ ]]; then
    _saveTerminalOutput
    cmd=$(_getLastLinesFromFile "$TERMINAL_EXPORT_FILE" "$1")
    gh copilot suggest "$cmd"
    _debug "SUGGEST: $cmd"
  else
    gh copilot suggest "$*"
  fi

}


alias '??'=explain
alias '?!'=suggest
