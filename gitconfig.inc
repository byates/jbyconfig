[core]
    editor = nvim
    autocrlf = false
    pager = diff-so-fancy | less --tabs=4 --RAW-CONTROL-CHARS
[alias]
    tree = log --all --graph
    unstage = reset HEAD --
    discard = checkout
    ll = log --pretty=format:'%Cred%h%Creset %Cgreen(%cr)%Creset%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit
    llg = log --pretty=format:'%Cred%h%Creset %Cgreen(%cr)%Creset%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit --graph
[color]
    ui = true
[color "diff-highlight"]
    oldNormal = red bold
    oldHighlight = red bold 52
    newNormal = green bold
    newHighlight = green bold 22
[color "diff"]
    meta = yellow
    frag = magenta bold
    commit = yellow bold
    old = red bold
    new = green bold
    whitespace = red reverse
[pull]
    rebase = true

