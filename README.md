# Dotfiles

My personal computers' dotfiles.

## Dependencies

In order to be able to manage the dotfiles, you need:

- [Git](https://git-scm.org) for managing this repo
- [Stow][stow] for managing the dotfiles

[stow]: https://www.gnu.org/software/stow/

## Usage

### 1. Clone the repository

Clone the repo **in a subdirectory just below your `$HOME` folder**:

```sh
cd $HOME
git clone https://github.com/davidlj95/.files
```

### 2. Initialize submodules

Init the git submodules:

```sh
cd .files
git submodule update --init --recursive
```

### 3. Manage dotfiles

Each folder represents a collection of dotfiles for a given application.

[Stow][stow] manages the dotfiles by creating symlinks for every file or directory inside the folder whose dotfiles are
being activated into the parent directory (that's why we cloned inside `$HOME`).

#### Install a group dotfiles

To install a group dotfiles (a directory inside this repo), use the following command

```sh
stow directory
```

Where `directory` is the directory whose dotfiles you want to install. 🎉 Now files inside that directory are symlinked
in your `$HOME` directory (ie: if you stow `foo`, and there's `.bar` inside of `foo` directory, now `$HOME/.bar` is a
symlink to `foo/bar`).

#### Uninstall

Same procedure to uninstall but with the `-D` flag.

```sh
stow -D directory
```

## TODO:

- [ ] VIM configs based on https://github.com/amix/vimrc
- [ ] SSH configs import
- [ ] Custom VIM configs
- [ ] Auto-enable `bash_it` aliases and plugins
- [ ] Script to automatically install basic dotfiles (`basic.sh`)
- [ ] Use [`dotdrop`](https://github.com/deadc0de6/dotdrop) for more configurations
