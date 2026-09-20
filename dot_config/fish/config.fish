# Added by Antigravity CLI installer
set -gx PATH "/home/ilomilo/.local/bin" $PATH

set -g fish_greeting

if status is-interactive
    fastfetch
end
