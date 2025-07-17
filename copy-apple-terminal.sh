#!/bin/bash
# Copies the visible buffer of Terminal.app to the clipboard and saves it to a specified file
OUTFILE=${1:-/tmp/terminal_export.txt}
osascript <<EOF
tell application "Terminal"
    activate
    tell application "System Events"
        keystroke "a" using {command down}
        keystroke "c" using {command down}
    end tell
end tell
delay 0.2
set theText to the clipboard
set fileRef to (open for access POSIX file "$OUTFILE" with write permission)
write theText to fileRef
close access fileRef
tell application "System Events"
    keystroke (ASCII character 27) -- Escape key to deselect
end tell
EOF
