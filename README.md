# Dotfiles

My personal computers' dotfiles.

# Dependencies

In order to be able to manage the dotfiles, you just need:

- [Git](https://git-scm.org) for cloning this repo (that usually comes built-in)
- [Stow][stow] for managing the dotfiles

[stow]: https://www.gnu.org/software/stow/

# Usage

## 1. Clone the repository in your home directory

Clone the repository in your `$HOME` directory, so it exists **as a subdirectory of your `$HOME` directory**:

```shell
cd $HOME
git clone https://github.com/davidlj95/.files # repo will be in `$HOME/.files`
```

> ⚠️ **It's important you clone it in your `$HOME` directory**
> 
> Otherwise, you won't be able to easily [symlink] files into `$HOME` directory

[symlink]: https://en.wikipedia.org/wiki/Symbolic_link

## 2. Initialize submodules

Init the git submodules:

```shell
cd .files
git submodule update --init --recursive
```

## 3. Manage dotfiles

Each folder represents a collection of dotfiles for a given application.

[Stow][stow] manages the dotfiles by creating [symlink]s for every file or directory inside the folder whose dotfiles are
being activated into the parent directory (that's why we cloned inside `$HOME`).

### Install a group of dotfiles

To install a group dotfiles (a directory inside this repo), use the following command when you're inside the repository:

```sh
cd $HOME/.files # ensure you're in the repository
stow directory
```

Where `directory` is the directory whose dotfiles you want to install.

🎉 Now files inside that directory are symlinked
in your `$HOME` directory. For instance: if you stow `foo`, and there's a dotfile `.bar` inside of `foo` directory, now `$HOME/.bar` is a
[symbolic link](https://en.wikipedia.org/wiki/Symbolic_link) to `foo/bar`.

### Uninstall a group of dotfiles

Same procedure to uninstall but with the `-D` flag.

```sh
cd $HOME/.files # ensure you're in the repository
stow -D directory
```

# Docs
## Bash
[A function exists](https://github.com/davidlj95/.files/blob/f553e2a4251c9e80be4dc4cae145933cc769c027/bash/.bash_profile#L102) to enable a selection of `bash-it` aliases and plugins

For fonts in `powerline` theme to work, [install Powerline fonts][powerline-fonts]

[powerline-fonts]: https://github.com/powerline/fonts

## Shell
The `shell` directory contains configurations that are shell-agnostic. Should work with `zsh` and `bash`. In order to load them, `bash` and `zsh` configs try to source those files if present.

You may define your custom aliases just for that machine by creating a  `.shell.custom.aliases.sh` file in your home directory. Aliases will be defined after the shell framework is loaded.

## Zsh
Comes with [Oh My Zsh](https://ohmyz.sh) configured, several plugins enabled & some custom plugins and themes (in [`zsh/.zsh-custom`](zsh/.zsh-custom)).

To see fonts properly when using `powerlevel10k` (the configured theme), check [the guide on how to install them](https://github.com/romkatv/powerlevel10k#fonts). You can also use the [Powerline fonts][powerline-fonts] if you prefer something else than `Meslo` font. I've used it and works too.

# Developing
A Jetbrains IDE is used to manage the repository. 

## Shell files
[Several built-in tools](https://www.jetbrains.com/help/idea/shell-scripts.html) are provided to manage shell script files. However, some require enabling them and some require some tweaks (that can't be shared as project settings).

## Formatting with `shfmt`
It uses the built-in settings for formatting shell files. But to do so, `shfmt` tool must be installed. Go to `Editor -> Code Style -> Shell Script` and look for the `Shfmt formatter` section to install it.

# TODO

- [ ] VIM configs based on https://github.com/amix/vimrc
- [ ] SSH configs import
- [ ] Custom VIM configs
- [ ] Script to automatically install basic dotfiles (`basic.sh`)
- [ ] Use [`dotdrop`](https://github.com/deadc0de6/dotdrop) for more configurations
