# dotfiles

My configs for macOS and Ubuntu: zsh, Neovim, yazi, kitty, git, and more, one [GNU Stow](https://www.gnu.org/software/stow/) package per directory.

Most of it is personal. The part meant for others is the setup: `starter.sh` sets up a new machine, and `pinstall` installs more tools later.

## Setup

```sh
curl https://starter.phoenix818.cloud | bash
```

The domain only serves a short loader that runs [`starter.sh`](starter.sh) from this repo. Without it:

```sh
curl -fsSL https://raw.githubusercontent.com/Fau818/dotfiles/main/starter.sh | bash
```

All its questions come first (which tools to install, then the sudo password if needed), so the rest runs unattended:

1. Clones this repo to `~/Documents/Fau/dotfiles` on macOS or `~/.config/dotfiles` on Linux, or updates the clone.
2. On Ubuntu, installs `curl`, `zsh`, `stow`, `rsync`, `kitty-terminfo` and the `en_US.UTF-8` locale when they're missing.
3. Links the zsh config: `~/.zshenv` and `~/.config/zsh`.
4. Runs the installers you chose: Homebrew, yazi, Neovim, Node.js (see [below](#more-tools-pinstall)).
5. Starts zsh once, quietly, to install its plugins and link the configs of the tools it finds, then drops you into zsh.

The tools' own output goes to log files, whose folder is printed at the end.

Options go after `bash -s --`:

```sh
curl https://starter.phoenix818.cloud | bash -s -- --help     # all options
curl https://starter.phoenix818.cloud | bash -s -- --pull     # only clone or update the dotfiles
curl https://starter.phoenix818.cloud | INSTALLER_YES=1 bash  # yes to every question, e.g. in a Docker build
```

Good to know:

- Only macOS and Ubuntu get packages and tools; other Linux systems get the dotfiles and the zsh links only.
- On macOS, it first needs the Command Line Tools: when they're missing, their installer opens, and you run the script again afterwards.
- It doesn't overwrite your files: when `~/.zshenv` or `~/.config/zsh` is already there, it stops and tells you to move it away. An existing `~/.config/nvim` is left as is.
- It doesn't run `chsh`. Where bash is the login shell, it adds a short block to the top of `~/.bashrc` that switches to zsh.
- Running it again is safe: it only does what's missing.

## More tools: `pinstall`

After setup, `pinstall` in zsh lists the installers for your platform, and runs them by name:

```sh
pinstall                    # list them
pinstall docker miniconda   # run them, in order
```

| Installer   | Platform     | Installs                                                                                                               |
| ----------- | ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| `homebrew`  | macOS, Linux | Homebrew, from the official source; offers the Aliyun mirror if that fails                                             |
| `neovim`    | macOS, Linux | Neovim and [nvim-config](https://github.com/Fau818/nvim-config), with fzf, ripgrep, fd, lazygit, git-delta, eza, zoxide |
| `yazi`      | macOS, Linux | yazi, with zoxide, bat, ripgrep, fd, eza                                                                               |
| `node`      | macOS, Linux | Node.js, for Copilot and the LSP servers installed through npm                                                         |
| `docker`    | Linux        | Docker Engine, from get.docker.com                                                                                     |
| `miniconda` | Linux        | Miniconda, into `~/.local/miniconda3`                                                                                  |

`neovim`, `yazi` and `node` install with Homebrew, on Linux too, so they need `homebrew` first. Each installer skips what's already there, then links its tools' configs from this repo.

`pinstall` is a thin wrapper around [`installers.zsh`](zsh/.config/zsh/scripts/installers.zsh), which also runs on its own:

```sh
zsh ~/.config/zsh/scripts/installers.zsh --list
zsh ~/.config/zsh/scripts/installers.zsh neovim yazi
```

## Your own fork

The setup links my own configs, including my git name and email. To set up yours instead, fork this repo, change `REPO_URL` in `starter.sh` (and the nvim-config URL in `installers.zsh`, if you have your own), and run your fork's `starter.sh`.
