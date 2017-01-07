function __fish_vcsh_no_command
  set -l cmd (commandline -opc)

  if [ (count $cmd) -le 1 ]
    return 0
  end

  for token in $cmd[2..-1]
    if not string match -q -- '-*' $token
      return 1
    end
  end
  return 0
end

# vcsh [options] command
complete -c vcsh -n'__fish_vcsh_no_command' -rs c -d'Source file prior to other configuration files'
complete -c vcsh -n'__fish_vcsh_no_command' -s d -d'Enable debug mode'
complete -c vcsh -n'__fish_vcsh_no_command' -s v -d'Enable verbose mode'

# vcsh clone [-b branch] url [repo]
complete -c vcsh -a clone -d 'Clone an existing repository' -f -n'__fish_vcsh_no_command'
complete -c vcsh -s b -d'specify branch' -n'__fish_complete_test_contains clone' -rf

# vcsh commit
complete -c vcsh -a commit -d'Commit in all repositories' -f -n'__fish_vcsh_no_command'

# vcsh delete repo
complete -c vcsh -a delete -d 'Delete an existing repository' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains delete' -f

#       vcsh enter repo
complete -c vcsh -a enter -d 'Enter repository' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains enter' -f

# vcsh foreach [-g] git command
#       foreach
#              Execute git command for every vcsh repository.
complete -c vcsh -a foreach -d'Execute git command for every vcsh repository' -f -n'__fish_vcsh_no_command'
complete -c vcsh -s g -d'Execute in general context' -n'__fish_complete_test_contains foreach \'!*\''

#       vcsh help
#       help   Display help.
complete -c vcsh -a help -d 'Display help' -f -n'__fish_vcsh_no_command'

#       vcsh init repo
#       init   Initialize an empty repository.
complete -c vcsh -a init -d 'Initialize an empty repository' -f -n'__fish_vcsh_no_command'

#       vcsh list
#       list   List all local vcsh repositories.
complete -c vcsh -a list -d 'List all local vcsh repositories' -f -n'__fish_vcsh_no_command'

#       vcsh list-tracked [repo]
#       list-tracked
#              List all files tracked by vcsh.
complete -c vcsh -a list-tracked -d 'List all files tracked by vcsh' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains list-tracked' -f

#       vcsh list-untracked [-a] [-r] [repo]
#       list-untracked
#              List all files NOT tracked by vcsh.
#              -a: Show all files. By default, the git ls-files --exclude-standard is called.
#              -r: Recursive mode. By default, the file list is shallow and stops at directory levels where possible.
#              $repo: List files not tracked by this specific repository.
complete -c vcsh -a list-untracked -d 'List all files NOT tracked by vcsh' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains list-untracked' -f

#       vcsh pull
#       pull   Pull from all vcsh remotes.
complete -c vcsh -a pull -d 'Pull from all vcsh remotes' -f -n'__fish_vcsh_no_command'

#       vcsh push
#       push   Push to all vcsh remotes.
complete -c vcsh -a push -d 'Push to all vcsh remotes' -f -n'__fish_vcsh_no_command'

#       vcsh rename repo newname
#       rename Rename a repository.
complete -c vcsh -a rename -d 'Rename a repository' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains rename' -f

#       vcsh run repo shell command
#       run    Run command with $GIT_DIR and $GIT_WORK_TREE set. Allows you to run any and all commands without any restrictions. Use with care.
complete -c vcsh -a run -d 'Run command with $GIT_DIR and $GIT_WORK_TREE set' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains run' -f

#       vcsh status [repo]
#       status Show statuses of all/one vcsh repositories.
complete -c vcsh -a status -d 'Show statuses of all/one vcsh repositories' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains status' -f

#       vcsh upgrade repo
#       upgrade Upgrade repository to currently recommended settings.
complete -c vcsh -a upgrade -d 'Upgrade repository to currently recommended settings.' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains upgrade' -f

#       vcsh version
#       version Print version information.
complete -c vcsh -a version -d 'Print version information' -f -n'__fish_vcsh_no_command'

#       vcsh which substring
#       which  Find substring in name of any tracked file.
complete -c vcsh -a which -d'Find <substring> in name of any tracked file' -f -n'__fish_vcsh_no_command'

#       vcsh write-gitignore repo
#       write-gitignore Write .gitignore.d/repo via git ls-files.
complete -c vcsh -a write-gitignore -d 'Write .gitignore.d/repo via git ls-files' -f -n'__fish_vcsh_no_command'
complete -c vcsh -a '(vcsh list)' -n '__fish_complete_test_contains write-gitignore' -f

#       vcsh repo git command
#       repo gitcommand
#              Shortcut to run vcsh on a repo. Will prepend git to command.

#       vcsh repo
#              repo   Shortcut to run vcsh enter <repo>.
complete -c vcsh -a '(vcsh list)' -f -n'__fish_vcsh_no_command'
