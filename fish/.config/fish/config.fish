set -gx EDITOR nvim
export EDITOR=nvim
alias vim='nvim'

bind \cd yank

alias reloadfish='source ~/.config/fish/config.fish'

if status is-interactive
    alias nnvim='echo "cd" (pwd) | pbcopy && nvim'
    alias p='cd ~/projects'
    alias pa='cd ~/projects/aca'
    alias s='cd ~/scratch'
    alias n='cd ~/notes'
    alias docs='cd ~/Documents'
    alias down="cd ~/Downloads"
    # all project roots
    alias cdr="cd (fd . -t d --exclude "node_modules" --exclude "Library" --exclude "Applications" ~/projects/aca --maxdepth 1 | fzf)"
    # all dirs in current project
    alias cdp="cd (fd . -t d --exclude "node_modules" --exclude "Library" --exclude "Applications" (git rev-parse --show-toplevel) | fzf)"
    # all projects and dirs
    alias cdg="cd (fd . -t d --exclude "node_modules" --exclude "Library" --exclude "Applications" ~/projects/aca | fzf)"
    # all dirs in home
    alias cdh="cd (fd . -t d --exclude "node_modules" --exclude "Library" --exclude "Applications" ~/ | fzf)"
    # top level dirs in notes
    alias cdn="cd (fd . -t d --exclude "node_modules" --exclude "Library" --exclude "Applications" ~/notes --maxdepth 4 | fzf)"

    if type -q bat
        alias cat='bat -p'
    end
    if type -q eza
        alias ls='eza --icons'
    end
    if type -q terraform
        alias tf='terraform'
    end

    alias gsf='git switch (git branch | fzf --preview "git log --oneline --color=always --graph --decorate --abbrev-commit {1} | head -n 20" | awk "{print $1}" | sed "s/\\* //" | tr -d " ")'
    alias gs='git status'
    alias gpa="git pull -a"
    alias gbsu="git branch --set-upstream-to=origin/$(git branch --show-current) (git branch --show-current)"
    alias gpsu="git push --set-upstream origin (git branch --show-current)"

    # pass manager
    alias okta='gopass show -c misc/active-directory'
    alias apass='gopass list --flat | grep stacks | fzf | xargs gopass show -c'

    alias sshi="ssh -o 'StrictHostKeyChecking no' -o UserKnownHostsFile=/dev/null"

    zoxide init fish | source
    starship init fish | source
    fzf --fish | source
end

complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

alias ruby='/opt/homebrew/opt/ruby/bin/ruby'

fish_add_path $HOME/.local/helpers
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/.dotnet/tools

if type -q brew
    fish_add_path /opt/homebrew/bin
end

## k8s
if type -q kubectl; and type -q kubens
    kubectl completion fish | source
    abbr -a ktl kubectl
    abbr -a ktx kubectx
    abbr -a kns kubens
    abbr -a kgp 'kubectl get pods'
    abbr -a kdp 'kubectl describe pod'
    abbr -a pretty_pods 'watch -c "kubectl get pods | clog kubectl" '
    abbr -a pretty_runners 'watch -c "kubectl get runners | clog kubectl" '
    abbr -a kys 'k9s'
end

# fisher can be acquired from https://github.com/jorgebucaran/fisher. that is
# already done by being added to local share through chezmoi. if you are not
# using chezmoi then follow the directions on the git repo

# run `source ~/.local/share/fisher/fisher.fish` then:
# fisher install jorgebucaran/fisher
# fisher install patrickf1/fzf.fish
# fisher install urbainvaes/fzf-marks

# node version management use https://github.com/Schniz/fnm
# Create ~/.config/fish/conf.d/fnm.fish and add this line to it:
# fnm env --use-on-cd --shell fish | source

#helper to patch path
function remove_path
    if set -l index (contains -i "$argv" $fish_user_paths)
        set -e fish_user_paths[$index]
        echo "Removed $argv from the path"
    end
end

