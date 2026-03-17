# main zsh settings


# load modules
autoload -Uz colors && colors
autoload -Uz compinit
compinit


# cmp options
zstyle ':completion:' menu select 



# History settings
HISTFILE=~/.config/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
bindkey -e


# The following lines were added by compinstall
zstyle :compinstall filename '/home/vmuser/.zshrc'


# The following lines were added by compinstall
zstyle :compinstall filename '/home/vmuser/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# Comments settings
setopt interactivecomments


# Starship Prompt Activiation
eval "$(starship init zsh)"


# Keybinds
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^U" backward-kill-line
bindkey "^[[3~" delete-char


# Set word style
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>/ '$'\n'
autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style unspecified


# Aliases
alias vim="vim -u ~/.config/vim/vimrc"
alias v="nvim"
alias vs="EDITOR=nvim sudoedit"
alias ll="ls -l --color=auto"
alias ls="ls --color=auto"
alias hist="history 0"
