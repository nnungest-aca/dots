# dots

a few basic config files for others to use.

## usage

requires [gnu stow](https://www.gnu.org/software/stow/).

```bash
# clone into your home directory
cd ~
git clone <repo-url> .dotfiles
cd .dotfiles

# stow individual packages
stow nvim
stow fish
stow tmux
stow wezterm
stow starship

# or stow everything
stow */
```

this creates symlinks from each package into `~/.config/`.

## packages

- `nvim` — neovim config
- `fish` — fish shell config
- `tmux` — tmux config
- `wezterm` — wezterm terminal config
- `starship` — starship prompt config

## faq

### did you know this is public?

yes.
