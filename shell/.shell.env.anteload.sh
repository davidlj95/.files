# Configures the shell environment. Launched before (ante) shell framework is loaded.
# *chose 'ante' so file appears before 'post' one :P https://english.stackexchange.com/a/541758
#
# Aimed to be shell independent
#
# Tested in zsh (though this was started using bash)

# Constants
export USER_APPS_DIR="$HOME/app"
export USER_LIBS_DIR="$HOME/lib"

# Home bins
prepend_to_path "$HOME/bin"
prepend_to_path "$HOME/.local/bin"

## 0. Shell customizations
export EDITOR=vim

# zsh theme
export POWERLINE_PROMPT="battery user_info scm python_venv ruby cwd"

## 1. Package managers
# Homebrew
get_homebrew_dir() {
  # Logic based on install script
  # https://github.com/Homebrew/install/blob/5e7f30635a945f475a557240f006973c81c71324/install.sh#L147
  if is_mac_os; then
    # https://github.com/Homebrew/install/blob/5e7f30635a945f475a557240f006973c81c71324/install.sh#L154-L155
    homebrew_mac_os_arm64_dir="/opt/homebrew"
    # https://github.com/Homebrew/install/blob/5e7f30635a945f475a557240f006973c81c71324/install.sh#L158-L159
    homebrew_mac_os_intel_dir="/usr/local/Homebrew"
    for homebrew_dir in "$homebrew_mac_os_arm64_dir" "$homebrew_mac_os_intel_dir"; do
      if directory_exists_and_is_readable "$homebrew_dir"; then
        echo "$homebrew_dir"
        break
      fi
    done
  else
    # https://github.com/Homebrew/install/blob/5e7f30635a945f475a557240f006973c81c71324/install.sh#L174-L175
    homebrew_linux_dir="/home/linuxbrew/.linuxbrew"
    if directory_exists_and_is_readable "$homebrew_linux_dir"; then
      echo "$homebrew_linux_dir"
    fi
  fi
}
if ! command_exists brew; then
  homebrew_dir="$(get_homebrew_dir)"
  [ -n "$homebrew_dir" ] && eval "$("$homebrew_dir/bin/brew" shellenv)"
fi

## 2. Runtime version managers
# Flutter: Flutter Version Manager (fvm)
fvm_home_dir="$fvm_home_default_dir"
# https://github.com/fluttertools/fvm/blob/2.4.1/lib/constants.dart#L41-L49 (omitting Windows)
fvm_home_default_dir="$HOME/fvm"
if directory_exists_and_is_readable "$fvm_home_dir"; then
  # To use fvm global
  # https://github.com/fluttertools/fvm/blob/2.4.1/lib/src/commands/global_command.dart#L54-L57
  # https://github.com/fluttertools/fvm/blob/2.4.1/lib/src/services/cache_service.dart#L146-L163
  # https://github.com/fluttertools/fvm/blob/2.4.1/lib/src/services/context.dart#L75-L82
  fvm_default_dir="$fvm_home_dir/default"
  prepend_to_path_if_exists_and_is_readable "$fvm_default_dir/bin"
  # 👇 To use dart from CLI using global fvm version. Not strictly needed, but is nice to have.
  prepend_to_path_if_exists_and_is_readable "$fvm_default_dir/cache/dart-sdk/bin"
fi

# Java: SDKMAN!
sdkman_dir="$sdkman_default_dir"
sdkman_default_dir="$HOME/.sdkman" # https://sdkman.io/install
if [ -d "$sdkman_dir" ]; then
  # Init
  source "$sdkman_dir/bin/sdkman-init.sh"

  # Set current as JAVA_HOME
  sdkman_current_dir="$sdkman_dir/candidates/java/current"
  if [ -d "$sdkman_current_dir" ]; then
    export JAVA_HOME="$sdkman_current_dir"
    prepend_to_path "$JAVA_HOME/bin"
  fi
fi

# N
# Prefix is set to `$HOME/.n` instead of brew's formulae default: `$HOME/n`
# https://github.com/tj/n/blob/v9.1.0/README.md?plain=1#L81
# Which is better than default installation: `/usr/local`.
# https://github.com/tj/n/blob/v9.1.0/README.md?plain=1#L40
if command_exists n; then
  export N_PREFIX="$HOME/.n"
  prepend_to_path "$N_PREFIX/bin"
fi

# Python: pyenv
if command_exists pyenv; then
  eval "$(pyenv init -)"
  # pyenv-virtualenv
  if pyenv virtualenv --version >/dev/null 2>&1; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# Ruby: Ruby Version Manager (rvm)
# Just to be sure. Usually this is already configured by the installer (file .zprofile/.zlogin/.profile, ...)
# https://github.com/rvm/rvm/blob/1.29.12/scripts/functions/installer#L809-L919
if ! command_exists rvm; then
  # https://github.com/rvm/rvm/blob/1.29.12/binscripts/rvm-installer#L542-L543
  # https://github.com/rvm/rvm/blob/1.29.12/binscripts/rvm-installer#L546-L547
  rvm_dir_home="$HOME/.rvm"
  rvm_dir_usr_local="/usr/local/rvm"
  for rvm_dir in "$rvm_dir_home" "$rvm_dir_usr_local"; do
    if directory_exists_and_is_readable "$rvm_dir"; then
      [[ -s "$rvm_dir/scripts/rvm" ]] && source "$rvm_dir/scripts/rvm"
      break
    fi
  done
fi
if command_exists rvm; then
  # shellcheck disable=SC2154
  prepend_to_path_if_exists_and_is_readable "$rvm_path/bin"

  # Completions may be there already. For instance, rvm OhMyZsh plugin loads them
  # https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/rvm/rvm.plugin.zsh
  if ! completions_exist_for rvm; then
    [[ -r $rvm_path/scripts/completion ]] && . "$rvm_path"/scripts/completion
  fi
fi

## 3. Runtimes
# Golang
export GOPATH="$HOME/.go"

## 4. Package managers & build tools
# Java: gradle
export GRADLE_COMMAND="gradle"
export GRADLE_HOME="$USER_APPS_DIR/gradle/default"
[ -d "$GRADLE_HOME" ] && prepend_to_path "$GRADLE_HOME/bin"

# Rust: cargo
cargo_dir="$HOME/.cargo"
prepend_to_path_if_exists_and_is_readable "$cargo_dir/bin"
[ -r "$cargo_dir/env" ] && source "$cargo_dir/env"

## 5. Apps
# Android
if is_mac_os; then
  export ANDROID_HOME=$HOME/Library/Android/Sdk
else
  export ANDROID_HOME=$HOME/Android/Sdk
fi
if [ -d "$ANDROID_HOME" ]; then
  prepend_to_path "${ANDROID_HOME}/emulator"
  prepend_to_path "${ANDROID_HOME}/platform-tools"
fi

# CUDA: NVIDIA GPU API
export CUDA_COMMAND="cuda"
export CUDA_HOME="/usr/local/cuda"
if [ -d "$CUDA_HOME" ]; then
  prepend_to_path "$CUDA_HOME/bin"
  export LD_LIBRARY_PATH="$CUDA_HOME/lib64:$LD_LIBRARY_PATH"
fi

# Direnv
DIRENV_COMMAND="direnv"
if command_exists "$DIRENV_COMMAND"; then
  eval "$("$DIRENV_COMMAND" hook "$SHELL")"
fi

# Fuck
command_exists fuck && eval "$(thefuck --alias)"

# Hub: GitHub CLI tool
export HUB_COMMAND="hub"
if command_exists "$HUB_COMMAND"; then
  eval "$("$HUB_COMMAND" alias -s "$SHELL")"
fi

# Jetbrains Toolbox
# https://blog.jetbrains.com/blog/2022/07/07/toolbox-app-1-25-is-here/
get_jetbrains_toolbox_dir() {
  macos_dir="$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  linux_dir="$HOME/.local/share/JetBrains/Toolbox/scripts"
  windows_dir="%LOCALAPPDATA%\JetBrains\Toolbox\scripts"
  if is_mac_os && directory_exists_and_is_readable "$macos_dir"; then
    echo "$macos_dir"
  elif is_linux_os && directory_exists_and_is_readable "$linux_dir"; then
    echo "$linux_dir"
  else directory_exists_and_is_readable "$windows_dir"
    echo "$windows_dir"
  fi
}
jetbrains_dir="$(get_jetbrains_toolbox_dir)"
[ -n "$jetbrains_dir" ] && prepend_to_path "$jetbrains_dir"

# JMeter
export JMETER_COMMAND="jmeter"
export JMETER_HOME="$USER_APPS_DIR/apache-jmeter/default"
[ -d "$JMETER_HOME" ] && prepend_to_path "$JMETER_HOME/bin"

# Maven
export MAVEN_COMMAND="maven"
export MAVEN_HOME="$USER_APPS_DIR/apache-maven/default"
[ -d "$MAVEN_HOME" ] && prepend_to_path "$MAVEN_HOME/bin"

# NirCmd
export NIRCMD_COMMAND="nircmd.exe"
export NIRCMD_HOME="$USER_APPS_DIR/nircmd/default"
if [ -d "$NIRCMD_HOME" ]; then
  prepend_to_path "$NIRCMD_HOME"
fi

# Spring CLI
export SPRING_COMMAND="spring"
export SPRING_HOME="$sdkman_dir/candidates/springboot/current"
if [ -d "$SPRING_HOME" ]; then
  prepend_to_path "$SPRING_HOME/bin"
fi

# Spring Roo
export ROO_COMMAND="roo"
export ROO_HOME="$USER_APPS_DIR/spring-roo/default"
if [ -d "$ROO_HOME" ]; then
  prepend_to_path "$ROO_HOME/bin"
  alias roo="roo.sh"
fi

# Terraform
TERRAFORM_HOME="/usr/local/opt/terraform@0.11"
if [ -d "$TERRAFORM_HOME" ]; then
  prepend_to_path "$TERRAFORM_HOME/bin"
fi

## X. Overrides specific to this machine
if [ -r "$HOME/.shell.overrides" ]; then
  source "$HOME/.shell.overrides"
fi
