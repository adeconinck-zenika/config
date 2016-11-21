#!/bin/bash

bindkey -e
autoload -Uz select-word-style && select-word-style bash

bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
