# ct - Clipboard Tool

A powerful command-line tool to copy file contents to clipboard with line number selection support.

[![Go Version](https://img.shields.io/badge/Go-1.23+-00ADD8?style=flat&logo=go)](https://go.dev/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey)](https://github.com/cumulus13/ct-go)

## Features

✨ **Key Features:**
- 📋 Copy entire file or specific lines to clipboard
- 🔢 Support single or multiple line selection
- 📢 Desktop notifications for operation status
- 🚀 Cross-platform support (Windows, Linux, macOS)
- ⚡ Fast and lightweight
- 🎯 Simple and intuitive CLI interface

## Installation

### Using Go Install (Recommended)

```bash
go install github.com/cumulus13/ct-go/ct@latest
```

Make sure `$GOPATH/bin` or `$HOME/go/bin` is in your `PATH`.

### Build from Source

```bash
# Clone repository
git clone https://github.com/cumulus13/ct-go.git
cd ct-go

# Build
go build -ldflags="-s -w" -o ct ./ct

# Or use build script
# Windows:
build.bat

# Linux/macOS:
chmod +x build.sh
./build.sh
```

### Download Pre-built Binaries

Download the latest release from [Releases](https://github.com/cumulus13/ct-go/releases) page.

## Usage

### Basic Usage

```bash
# Copy entire file to clipboard
ct file.txt

# Copy specific line
ct -l 5 file.txt

# Copy multiple lines
ct -line 1,3,5,10 file.txt

# Copy lines without line numbers
ct -w -line 2,4,6 file.txt

# Silent mode (no notifications)
ct -s file.txt

# Multiple files
ct file1.txt file2.txt file3.txt
```

### Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `-l <number>` | Copy specific line number | `ct -l 5 file.txt` |
| `-line <numbers>` | Copy multiple lines (comma-separated) | `ct -line 1,3,5 file.txt` |
| `-w` | Copy without line numbers | `ct -w -line 2,4 file.txt` |
| `-s` | Silent mode (disable notifications) | `ct -s file.txt` |
| `-h` | Show help message | `ct -h` |

### Examples

#### Example 1: Copy Entire File
```bash
ct README.md
```
Output: All content copied to clipboard with desktop notification.

#### Example 2: Copy Specific Lines with Numbers
```bash
ct -line 10,20,30 code.go
```
Output:
```
10. func main() {
20.     fmt.Println("Hello")
30. }
```

#### Example 3: Copy Lines Without Numbers
```bash
ct -w -line 5,10,15 script.py
```
Output:
```
import os
def hello():
    return "world"
```

#### Example 4: Copy Multiple Files
```bash
ct file1.txt file2.txt file3.txt
```
Output: All files content combined and copied to clipboard.

#### Example 5: Silent Mode (No Notifications)
```bash
ct -s large-file.log
```
Useful for scripting or when you don't need notifications.

## Requirements

### Runtime Dependencies

- **Windows**: No additional dependencies
- **Linux**: `libnotify` for notifications
  ```bash
  # Ubuntu/Debian
  sudo apt-get install libnotify-bin
  
  # Fedora/RHEL
  sudo dnf install libnotify
  
  # Arch Linux
  sudo pacman -S libnotify
  ```
- **macOS**: No additional dependencies

### Build Dependencies

- Go 1.23 or higher
- Internet connection (for downloading dependencies)

## Building

### Quick Build

```bash
# Build for current platform
go build -ldflags="-s -w" -o ct ./ct
```

### Multi-Platform Build

```bash
# Windows
GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o ct.exe ./ct

# Linux
GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o ct ./ct

# macOS Intel
GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -o ct ./ct

# macOS Apple Silicon (M1/M2)
GOOS=darwin GOARCH=arm64 go build -ldflags="-s -w" -o ct ./ct
```

### Using Make

```bash
# Build for current platform
make build

# Build for all platforms
make build-all

# Clean build artifacts
make clean

# Install to $GOPATH/bin
make install
```

## Project Structure

```
ct-go/
├── README.md           # This file
├── LICENSE             # License file
├── go.mod              # Go module file
├── go.sum              # Go dependencies checksum
├── Makefile            # Build automation
├── build.sh            # Linux/macOS build script
├── build.bat           # Windows build script
└── ct/
    └── main.go         # Main application code
```

## Dependencies

- [atotto/clipboard](https://github.com/atotto/clipboard) - Cross-platform clipboard access
- [gen2brain/beeep](https://github.com/gen2brain/beeep) - Cross-platform desktop notifications

## Troubleshooting

### Notifications Not Working

**Windows:**
- Ensure Windows notifications are enabled in Settings
- Check Windows Defender isn't blocking notifications

**Linux:**
- Install `libnotify`: `sudo apt-get install libnotify-bin`
- Check notification daemon is running: `ps aux | grep notification`

**macOS:**
- Grant notification permissions in System Preferences > Notifications

### Clipboard Not Working

- Make sure you have necessary clipboard utilities:
  - **Linux**: `xclip` or `xsel`
    ```bash
    sudo apt-get install xclip
    # or
    sudo apt-get install xsel
    ```
  - **Windows/macOS**: Built-in support

### Binary Not Found After Install

Make sure Go bin directory is in your PATH:

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH=$PATH:$(go env GOPATH)/bin

# Or
export PATH=$PATH:$HOME/go/bin
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## author
[Hadi Cahyadi](mailto:cumulus13@gmail.com)
    

[![Buy Me a Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/cumulus13)

[![Donate via Ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/cumulus13)
 
[Support me on Patreon](https://www.patreon.com/cumulus13)

## Acknowledgments

- Thanks to all contributors
- Inspired by various clipboard management tools
- Built with ❤️ using Go

## Support

If you find this tool useful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs
- 💡 Suggesting new features
- 📖 Improving documentation

---

**Made with 🚀 by [cumulus13](https://github.com/cumulus13)**

