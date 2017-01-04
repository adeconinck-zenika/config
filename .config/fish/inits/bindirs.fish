for bindir in $argv[-1..1]
  set bindir (eval echo $bindir)

  # ! at the beginning of the line to create directory
  if string match '!*' $bindir >/dev/null
    set bindir (string sub -s2 $bindir) #remove '!'
    set bindir (eval echo $bindir) #reevaluate bindir : ! fuck the normal eval
    if [ ! -d $bindir ]
      mkdir -p $bindir
    end
  end

  # add in path if does not exist
  if not contains $bindir $PATH
    set PATH $bindir $PATH
  end
end
