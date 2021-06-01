###################################
# Set up Paths and Linkers for $HOME/.local program install
###################################
export PATH=$HOME/.local/bin:$PATH
export C_INCLUDE_PATH=$HOME/.local/include
export CPLUS_INCLUDE_PATH=$HOME/.local/include
export LIBRARY_PATH=$HOME/.local/lib:$HOME/.local/lib64
export PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig
export LD_LIBRARY_PATH=$HOME/.local/lib:
export MANPATH=$HOME/.local/share/man
export PATH=$HOME/.local/python/Python3.9:$PATH
export PATH=$HOME/.local/bin/:$PATH
alias python=$HOME/.local/python/bin/python3
alias python3=$HOME/.local/python/bin/python3
alias pip3=$HOME/.local/python/bin/pip3
alias pip=$HOME/.local/python/bin/pip3
###################################
# Configurations for zsh
###################################
setopt AUTO_CD
setopt NO_CASE_GLOB
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt EXTENDED_HISTORY
SAVEHIST=5000
HISTSIZE=2000
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
setopt CORRECT
setopt CORRECT_ALL
autoload -Uz compinit && compinit
# case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
# Left Prompt
PROMPT='%n@%B%F{yellow}%d%f%b %# '
# Right Prompt set to tell me where I am within any Github Projects
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{magenta}(%b)%f%F{yellow}%r%f'
zstyle ':vcs_info:*' enable git