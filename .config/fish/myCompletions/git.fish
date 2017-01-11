if [ -f /usr/share/fish/completions/git.fish ]
  source /usr/share/fish/completions/git.fish
end

complete -f -c git -n '__fish_git_using_command fetch' -s p -l prune -d 'Before fetching, remove any remote-tracking references that no longer exist on the remote'
