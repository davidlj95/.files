# Dotfiles
My personal computers' dotfiles.

## Dependencies
In order to be able to manage the dotfiles, you need:

- [Git](https://git-scm.org) for managing this repo
- [Stow](https://www.gnu.org/software/stow/) for managing the dotfiles

## Usage

### 1. Clone the repository
Clone the repo **in a subfolder just below your `$HOME` folder**:

```sh
cd $HOME
git clone https://github.com/davidlj95/.dotfiles
```

### 2. Initialize submodules
Init the git submodules:

```sh
cd .dotfiles
git submodule update --init --recursive
```

### 3. Manage dotfiles
Each folder represents a collection of dotfiles for a given application. 

[Stow](https://www.gnu.org/software/stow) manages the dotfiles by creating
symlinks for every file or directory inside the folder whose dotfiles are being
activated into the parent directory (that's why we cloned inside `$HOME`).

#### Install dotfiles for an application
To install the dotfiles for an application (a folder inside this repo), use
the following command

```sh
stow <app>
```

Where `<app>` is the folder whose application dotfiles you want to install.

#### Uninstall
Same procedure to uninstall but with the `-D` flag.

```sh
stow -D <app>
```

## TODO:
- [ ] VIM configs based on https://github.com/amix/vimrc
- [ ] SSH configs import
- [ ] Custom VIM configs
- [ ] Autoenable `bash_it` aliases and plugins
- [ ] Script to automatically install basic dotfiles (`basic.sh`)
- [ ] Use [dotdrop](https://github.com/deadc0de6/dotdrop) for more configurations
