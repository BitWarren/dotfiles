# main zsh settings


# load modules
autoload -Uz colors && colors
autoload -Uz compinit
compinit


# cmp options
zstyle ':completion:' menu select 



HISTFILE=~/.config/zsh/histfile
HISTSIZE=8000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install


# The following lines were added by compinstall
zstyle :compinstall filename '/home/vmuser/.zshrc'


# The following lines were added by compinstall
zstyle :compinstall filename '/home/vmuser/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# User additions
setopt interactivecomments


# Starship Prompt Activiation
eval "$(starship init zsh)"


# Keybinds
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word


# Set word style
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>/ '$'\n'
autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style unspecified


# Aliases
alias vim="vim -u ~/.config/vim/vimrc"
alias v="nvim"
alias ll="ls -l --color=auto"
alias ls="ls --color=auto"
