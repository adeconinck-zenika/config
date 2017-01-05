function __fish_current_command_contains
  set -l cmd (commandline -opc)
  set -l searchedIndex 1
  for cmdToken in $cmd
    if string match -r -- '^-\w$' $cmdToken
      set -l letter (string sub -s2 -- $cmdToken)
      set cmdToken "-*$letter*"
    end
    if string match -- $cmdToken $argv[$searchedIndex]
      if [ (count $argv) -eq $searchedIndex ]
        return 0
      else
        set searchedIndex (math $searchedIndex + 1)
      end
    end
  end
  return 1
end
