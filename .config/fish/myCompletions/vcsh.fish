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
#vcsh [options] command
#  -c     Source file prior to other configuration files
#  -d     Enable debug mode
#  -v     Enable verbose mode
complete -c vcsh -n'__fish_vcsh_no_command' -rs c -d'Source file prior to other configuration files'
complete -c vcsh -n'__fish_vcsh_no_command' -s d -d'Enable debug mode'
complete -c vcsh -n'__fish_vcsh_no_command' -s v -d'Enable verbose mode'

#vcsh clone [-b branch] url [repo]
#  clone  Clone an existing repository.
complete -c vcsh -n'__fish_vcsh_no_command' -fa clone -d 'Clone an existing repository'
complete -c vcsh -n'__fish_current_command_contains clone' -frs b
complete -c vcsh -n'__fish_current_command_contains clone' -fa '(vcsh list)'
#
#commit Commit in all repositories
#
#vcsh delete repo
#  delete Delete an existing repository.
#
#       vcsh enter repo
#
#       vcsh foreach [-g] git command
#
#       vcsh help
#
#       vcsh init repo
#
#       vcsh list
#
#       vcsh list-tracked [repo]
#
#       vcsh list-untracked [-a] [-r] [repo]
#
#       vcsh pull
#
#       vcsh push
#
#       vcsh rename repo newname
#
#       vcsh run repo shell command
#
#       vcsh status [repo]
#
#       vcsh upgrade repo
#
#       vcsh version
#
#       vcsh which substring
#
#       vcsh write-gitignore repo
#
#       vcsh repo git command
#
#       vcsh repo
#              repo   Shortcut to run vcsh enter <repo>.
#
#
#
#COMMANDS
#
#              If you need to clone a bundle of repositories, look into the post-clone-retired hook.
#
#              You can also use a single git repository with several branches. Use the -b option to specify a branch at clone time, the default is master.
#
#
#
#       enter  Enter repository; spawn new $SHELL.
#
#       foreach
#              Execute git command for every vcsh repository.
#
#              -g: Execute in general context.
#
#       help   Display help.
#
#       init   Initialize an empty repository.
#
#       list   List all local vcsh repositories.
#
#       list-tracked
#              List all files tracked by vcsh.
#
#              If you want to list files tracked by a specific repository, simply append the repository´s name last.
#
#       list-tracked-by
#              List files tracked by a repository.
#
#              This is a legacy command; you should use list-tracked <repo> instead.
#
#       list-untracked
#              List all files NOT tracked by vcsh.
#
#              -a: Show all files. By default, the git ls-files --exclude-standard is called.
#
#              -r: Recursive mode. By default, the file list is shallow and stops at directory levels where possible.
#
#              $repo: List files not tracked by this specific repository.
#
#       pull   Pull from all vcsh remotes.
#
#       push   Push to all vcsh remotes.
#
#       rename Rename a repository.
#
#       run    Run command with $GIT_DIR and $GIT_WORK_TREE set. Allows you to run any and all commands without any restrictions. Use with care.
#
#              Please note that there is a somewhat magic feature for run. Instead of repo it accepts path, as well. Anything that has a slash in it will be assumed to be  a  path.  vcsh
#              run will then operate on this directory instead of the one normally generated from the repository´s name. This is needed to support mr and other scripts properly and of no
#              concern to an interactive user.
#
#       status Show statuses of all/one vcsh repositories.
#
#       upgrade
#              Upgrade repository to currently recommended settings.
#
#       version
#              Print version information.
#
#       which substring
#              Find substring in name of any tracked file.
#
#       write-gitignore
#              Write .gitignore.d/repo via git ls-files.
#
#       repo gitcommand
#              Shortcut to run vcsh on a repo. Will prepend git to command.
#
#
