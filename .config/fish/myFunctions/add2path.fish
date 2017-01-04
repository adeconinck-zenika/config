function add2path
  for path in $argv[-1..1]
    set path (eval echo $path)

    # ! at the beginning of the line to create directory
    if string match '!*' $path >/dev/null
      set path (string sub -s2 $path) #remove '!'
      set path (eval echo $path) #reevaluate path : ! fuck the normal eval
      if [ ! -d $path ]
        mkdir -p $path
      end
    end

    # add in path if does not exist
    while set -l index (contains -i $path $PATH)
      set -e PATH[$index]
    end
    set PATH $path $PATH
  end
end
