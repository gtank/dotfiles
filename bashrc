# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

export GOPATH=$HOME/go
export GOROOT_BOOTSTRAP=/usr/lib/golang
export PATH=$PATH:$HOME/.local/bin:$HOME/bin:$GOPATH/bin

# function launch_agent {
#     # make sure we haven't just lost one
#     ps -u$(whoami) | grep ssh-agent | grep -v grep > /dev/null
#     if [ $? != 0 ]; then
#         eval "$(ssh-agent -s)" 2>/dev/null
#     fi
# }

# # new shell, not in tmux
# if [ -z "$TMUX" ]; then
#     # ssh-agent configured. is it the gnome-keyring?
#     if [[ -n "$SSH_AGENT_PID" && -n "$SSH_AUTH_SOCK" ]]; then
#         # the gnome keyring is awful
#         if [[ "$SSH_AUTH_SOCK" =~ keyring/ssh$ ]]; then
#             gnome-keyring-daemon --replace -c secrets 2>&1 > /dev/null
#             launch_agent
#         fi
#     else
#         launch_agent
#     fi
# fi

# Fix colors in tmux
if [[ $TERM == xterm ]]; then TERM=xterm-256color; fi

# Quickly clean up docker things
alias docker-rm="docker ps -a -q | xargs docker rm"
alias docker-rmi="docker images -q | xargs docker rmi"

# You know what? I'm done. Timezones don't exist.
alias commit="git commit --date=\"$(date +'%a %b %d 00:00:00 %Y +0000')\""

# Utility
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

# Source machine-specific settings
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
