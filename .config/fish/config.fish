begin
  for f in (cat .config/fish/init-sources)
    source .config/fish/inits/$f.fish (cat .config/fish/inits/conf/$f 2>/dev/null)
  end
end
