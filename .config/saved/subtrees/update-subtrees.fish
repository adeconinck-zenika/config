function update-subtrees
  if [ (pwd) != "$HOME" ]
    echo you need to be in $HOME >&2
    return 1
  end
  set -l relSubtreesFolder .config/saved/subtrees
  set -l subtreesFolder ~/$relSubtreesFolder

  rm ~/.config/fish/subtreesFunctions/*
  
  for subtreeConf in (cat $subtreesFolder/conf)
    set subtreeConf (string split ' ' "$subtreeConf")
    set -l currSubtreeFolder $subtreesFolder/$subtreeConf[1]
    echo \# working on $subtreeConf[1]

    if [ -d $subtreesFolder/$subtreeConf[1] ]
      echo updating...
      git subtree pull --prefix "$relSubtreesFolder/$subtreeConf[1]" $subtreeConf[2..-1] --squash
    else
      echo creating...
      git subtree add --prefix "$relSubtreesFolder/$subtreeConf[1]" $subtreeConf[2..-1] --squash
    end

    for fscript in $currSubtreeFolder/*.fish
      if [ (string match 'fish_*' (basename $fscript)) ]
        echo ignore linking of $fscript
      else
        ln -sf $fscript ~/.config/fish/subtreesFunctions/
      end
    end

    for fscript in $currSubtreeFolder/functions/*.fish
      if [ (string match 'fish_*' (basename $fscript)) ]
        echo ignore linking of $fscript
      else
        ln -sf $fscript ~/.config/fish/subtreesFunctions/
      end
    end

    for fscript in $currSubtreeFolder/completions/*.fish
      if [ (string match 'fish_*' (basename $fscript)) ]
        echo ignore linking of $fscript
      else
        ln -sf $fscript ~/.config/fish/subtreesCompletions/
      end
    end
  end
end
