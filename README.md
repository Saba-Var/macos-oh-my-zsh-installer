# macOS Oh My Zsh Installer

This script automates the installation and configuration of **Oh My Zsh** on macOS, providing options for popular themes and plugins.

---

## Features

- **Installs and configures**:
  - Homebrew (if not installed)
  - Zsh (sets it as the default shell)
  - Oh My Zsh
- **Theme selection**:
  - `robbyrussell` (Default)
  - `agnoster`
  - `powerlevel10k` (includes font installation)
  - `spaceship`
  - `pure`
  - Custom theme (from a GitHub repository)
- Configures `.zshrc` with:
  - The selected theme
  - Essential plugins: `git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
- **Backs up** existing `.zshrc` to `.zshrc.backup`.
- Installs additional fonts for themes like **Powerlevel10k**.
- Installs and configures useful Zsh plugins.

---

## Prerequisites

Ensure you meet the following requirements before running the script:

1. macOS system with administrator privileges.
2. An active internet connection.

---

## Installation

1. Download the script:

   ```bash
   curl -O https://github.com/Saba-Var/macos-oh-my-zsh-installer
   ```

2. Make the script executable:

   ```bash
   chmod +x macos-oh-my-zsh-installer.sh
   ```

3. Run the script:

   ```bash
   ./macos-oh-my-zsh-installer.sh
   ```

4. Follow the on-screen instructions to select a theme and complete the installation.

---

## Theme Options

When prompted, select one of the following themes:

1. **robbyrussell**: Default theme.
2. **agnoster**: Powerline-style theme.
3. **powerlevel10k**: Feature-rich customizable theme. The script installs the recommended font (MesloLGS NF).
4. **spaceship**: Minimalistic and powerful theme.
5. **pure**: Minimal and fast theme.
6. **Custom theme**: Specify a GitHub repository URL in the format `user/repo`.

---

## Installed Plugins

The script installs the following plugins to enhance your Zsh experience:

- **zsh-autosuggestions**: Suggests commands as you type based on history and completions.
- **zsh-syntax-highlighting**: Highlights command syntax for better readability.

---

## Backup

- Any existing `.zshrc` file is automatically backed up as `.zshrc.backup` in your home directory.

---

## Font Installation

If you select the **Powerlevel10k** theme, the **MesloLGS NF** font will be installed. 

### Configuring the Font:
1. Open your terminal preferences.
2. Set the font to **MesloLGS NF** in the terminal profile settings.

---

## Troubleshooting

### Common Issues:
- **Homebrew not installed**: Ensure you have admin rights to install Homebrew.
- **Zsh not set as default shell**: Restart your terminal after the script runs.

### Restart Terminal:
After installation, restart your terminal to apply all changes.

---

## Uninstallation

To revert the changes made by the script:

1. Remove the `.oh-my-zsh` directory:

   ```bash
   rm -rf ~/.oh-my-zsh
   ```

2. Restore the backed-up `.zshrc` file:

   ```bash
   mv ~/.zshrc.backup ~/.zshrc
   ```

3. Restart your terminal.

---

## License

This script is distributed under the **MIT License**. Use it at your own risk.

---

Enjoy your enhanced Zsh experience! 🎉
