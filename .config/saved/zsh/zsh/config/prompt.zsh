#enable the PROMPT calulation
autoload -Uz precmd-append \
  && precmd-append -a update-prompt \
  && source ~/.config/zsh/prompts/agnoster++.zsh \
  && DEFAULT_USER=alban
unfunction precmd-append
