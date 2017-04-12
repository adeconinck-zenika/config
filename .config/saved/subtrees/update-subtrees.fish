function update-subtrees
  if [ (pwd) != "$HOME" ]
    echo you need to be in (pwd) >&2
    return 1
  end
  set -l relSubtreesFolder .config/saved/subtrees
  set -l subtreesFolder ~/$relSubtreesFolder
  for subtreeConf in (cat $subtreesFolder/conf)
    set subtreeConf (string split ' ' "$subtreeConf")
    if [ -d $subtreesFolder/$subtreeConf[1] ]
      echo updating $subtreeConf[1]...
      git subtree pull --prefix "$relSubtreesFolder/$subtreeConf[1]" $subtreeConf[2..-1] --squash
    else
      echo creating $subtreeConf[1]...
      git subtree add --prefix "$relSubtreesFolder/$subtreeConf[1]" $subtreeConf[2..-1] --squash
    end

  end
end
