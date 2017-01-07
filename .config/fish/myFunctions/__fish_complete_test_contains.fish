function __fish_complete_test_contains
  set -l debugging foreach ''
  #set -l debugging "![^-].*"
  if [ "$debugging" = "$argv" ]
    echo "* debugging: $debugging" >&2
    function __fish_current_command_contains_debug
      echo "* $argv" >&2
    end
  else
    function __fish_current_command_contains_debug
    end
  end

  set -l cmd (commandline -opc)
  set -e cmd[1]
  set -l searchedElements $argv
  set -l searchedIndex 1
  set -l allSearchedConsumed false
  set -l excludedElements

  for cmdToken in $cmd
    __fish_current_command_contains_debug "working on $cmdToken"
    set -l currentSearched
    if [ $allSearchedConsumed = false ]
      set currentSearched $searchedElements[$searchedIndex]
    end

    # if start with '!', add or remove from excludedElements
    # and search next search until it is not a '!'
    while string match -q -- '!*' $currentSearched
      set -l excluded (string sub -s2 $currentSearched)
      if set -l excludedIndexToRemove (contains -i -- $excluded $excludedElements)
        set -e $excludedElements[$excludedIndexToRemoves]
      else
        set excludedElements $excluded $excludedElements
      end
      __fish_current_command_contains_debug "ignored elements: $excludedElements"
      set searchedIndex (math $searchedIndex + 1)
      if [ (count $searchedElements) -ge $searchedIndex ]
        set currentSearched $searchedElements[$searchedIndex]
      else
        if [ (count $excludedElements) -eq 0 ]
          __fish_current_command_contains_debug "no more searched/excluded elements => ok!"
          return 0
        else
          set allSearchedConsumed true
          set currentSearched "allSearchedConsumed!"
        end
      end
    end

    # if match any excluded, return 2
    __fish_current_command_contains_debug " searching excluded elements"
    for excluded in $excludedElements
      if string match -qr -- $excluded $cmdToken
      __fish_current_command_contains_debug "  /!\\ \ '$cmdToken' excluded by '$excluded'"
        return 2
      end
    end

    # you can specify -f to match an option
    #if string match -r -- '^-\w$' $cmdToken
    #  set -l letter (string sub -s2 -- $cmdToken)
    #  set cmdToken "-*$letter*"
    #end

    # if match go to next search or return 0
    __fish_current_command_contains_debug " searching $currentSearched"
    if begin
          [ $allSearchedConsumed = false ]
          and string match -qr -- $currentSearched $cmdToken
       end
      __fish_current_command_contains_debug "  found !"
      set searchedIndex (math $searchedIndex + 1)
      if [ (count $searchedElements) -lt $searchedIndex ]
        if [ (count $excludedElements) -eq 0 ]
          __fish_current_command_contains_debug "  no more searched/excluded elements => ok!"
          return 0
        else
          set allSearchedConsumed true
          set currentSearched "allSearchedConsumed!"
        end
      end
    end
  end

  # return 1 if any of these is not an exlusion
  if [ (count $searchedElements) -ge $searchedIndex ]
    for searchedElement in $searchedElements[$searchedIndex..-1]
      if not string match -q -- '!*' $searchedElement
        __fish_current_command_contains_debug "/!\\ $searchedElement not found !"
        return 1
      else
        __fish_current_command_contains_debug "$searchedElement ignored (end of command)"
      end
    end
  end

  functions -e __fish_current_command_contains_debug
end
