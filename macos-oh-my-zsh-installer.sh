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

# Available themes array (using indexed array)
themes=("robbyrussell" "agnoster" "powerlevel10k/powerlevel10k" "spaceship")

# Function to display theme selection menu
select_theme() {
    print_message "\nAvailable themes:"
    echo "1) robbyrussell (Default theme)"
    echo "2) agnoster (Powerline-style theme)"
    echo "3) powerlevel10k (Feature-rich customizable theme)"
    echo "4) spaceship (Minimalistic and powerful theme)"
    echo "5) Custom theme (Enter GitHub URL)"

    while true; do
        read -p "Select theme number (1-5): " theme_choice
        case $theme_choice in
            [1-4])
                selected_theme=${themes[$theme_choice-1]}
                break
                ;;
            5)
                read -p "Enter theme GitHub URL (format: user/repo): " custom_theme_url
                selected_theme=$(basename "$custom_theme_url")
                custom_theme_url="https://github.com/$custom_theme_url"
                break
                ;;
            *)
                print_error "Invalid selection. Please choose 1-5."
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

# Function to remove existing theme if exists
remove_existing_theme() {
    local theme_dir="$1"
    if [ -d "$theme_dir" ]; then
        print_message "Removing existing theme directory: $theme_dir"
        rm -rf "$theme_dir"
    fi
}

# Install selected theme
print_message "Installing selected theme: $selected_theme"
case $selected_theme in
    "powerlevel10k/powerlevel10k")
        theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        remove_existing_theme "$theme_dir"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"
        # Install recommended font for Powerlevel10k
        print_message "Installing MesloLGS NF font..."
        brew install --cask font-meslo-nerd-font
        ;;
    "spaceship")
        theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt"
        remove_existing_theme "$theme_dir"
        git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$theme_dir" --depth=1
        ln -s "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"
        ;;
    *)
        if [ "$theme_choice" = "5" ]; then
            theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/$selected_theme"
            remove_existing_theme "$theme_dir"
            # Attempt to clone the custom theme
            git clone "$custom_theme_url" "$theme_dir"
            # Check if the clone was successful
            if [ $? -ne 0 ]; then
                print_error "Failed to clone the repository. Please check the GitHub URL."
                exit 1
            fi
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

# Set correct directory for plugin installation
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Check and install plugins if they are not already installed
install_plugin() {
    plugin_name=$1
    plugin_url=$2
    plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"

    if [ ! -d "$plugin_dir" ]; then
        print_message "Installing $plugin_name plugin..."
        git clone "$plugin_url" "$plugin_dir"
    else
        print_message "$plugin_name plugin already installed."
    fi
}

# Install necessary plugins
install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

print_message "Installation complete! Restarting your terminal..."
