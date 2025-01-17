#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print colored output
print_message() {
    echo -e "\033[1;34m$1\033[0m"
}

# Function to print error message
print_error() {
    echo -e "\033[1;31m$1\033[0m"
}

# Available themes array
declare -A themes
themes=(
    ["1"]="robbyrussell"
    ["2"]="agnoster"
    ["3"]="powerlevel10k/powerlevel10k"
    ["4"]="spaceship"
    ["5"]="pure"
)

# Function to display theme selection menu
select_theme() {
    print_message "\nAvailable themes:"
    echo "1) robbyrussell (Default theme)"
    echo "2) agnoster (Powerline-style theme)"
    echo "3) powerlevel10k (Feature-rich customizable theme)"
    echo "4) spaceship (Minimalistic and powerful theme)"
    echo "5) pure (Minimal and fast theme)"
    echo "6) Custom theme (Enter GitHub URL)"

    while true; do
        read -p "Select theme number (1-6): " theme_choice
        case $theme_choice in
            [1-5])
                selected_theme=${themes[$theme_choice]}
                break
                ;;
            6)
                read -p "Enter theme GitHub URL (format: user/repo): " custom_theme_url
                selected_theme=$(basename "$custom_theme_url")
                custom_theme_url="https://github.com/$custom_theme_url"
                break
                ;;
            *)
                print_error "Invalid selection. Please choose 1-6."
                ;;
        esac
    done
}

# Check if Homebrew is installed
if ! command_exists brew; then
    print_message "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Zsh if not already installed
if ! command_exists zsh; then
    print_message "Installing Zsh..."
    brew install zsh
fi

# Set Zsh as default shell if it isn't already
if [[ $SHELL != "/bin/zsh" ]]; then
    print_message "Setting Zsh as default shell..."
    chsh -s $(which zsh)
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_message "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Theme selection
select_theme

# Install selected theme
print_message "Installing selected theme: $selected_theme"
case $selected_theme in
    "powerlevel10k/powerlevel10k")
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        # Install recommended font for Powerlevel10k
        print_message "Installing MesloLGS NF font..."
        brew tap homebrew/cask-fonts
        brew install --cask font-meslo-lg-nerd-font
        ;;
    "spaceship")
        git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
        ln -s "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
        ;;
    "pure")
        brew install pure
        mkdir -p "$HOME/.zsh"
        git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
        ;;
    *)
        if [ "$theme_choice" = "6" ]; then
            git clone "$custom_theme_url" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/$selected_theme"
        fi
        ;;
esac

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    print_message "Backing up existing .zshrc..."
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Configure .zshrc with selected theme and common plugins
cat > "$HOME/.zshrc" << EOL
# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="$selected_theme"

# Set plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Source Oh My Zsh
source \$ZSH/oh-my-zsh.sh

# User configuration
export PATH=\$HOME/bin:/usr/local/bin:\$PATH
EOL

# Configure pure theme if selected
if [ "$selected_theme" = "pure" ]; then
    cat >> "$HOME/.zshrc" << EOL

# Pure theme setup
fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
EOL
fi

# Install additional plugins
print_message "Installing additional plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

print_message "Installation complete! Please restart your terminal."