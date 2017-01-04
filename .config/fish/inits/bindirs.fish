for bindir in $argv[-1..1]
  set bindir (eval echo $bindir)
  #if [ ! -d $bindir ]
  #  mkdir -p $bindir
  #end
  if not contains $bindir $PATH
    set PATH $bindir $PATH
  end
end
