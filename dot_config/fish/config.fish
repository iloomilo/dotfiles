# Added by Antigravity CLI installer
set -gx PATH "/home/ilomilo/.local/bin" $PATH

set -g fish_greeting

# Auto-start niri on tty1 login
if status is-login; and status is-interactive
    if test -z "$WAYLAND_DISPLAY" -a (tty) = "/dev/tty1"
        rm -f "$XDG_RUNTIME_DIR/quickshell-session-unlocked"
        exec niri-session
    end
end

if status is-interactive
    fastfetch
end
