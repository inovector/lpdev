# lpdev - Laravel Package Development CLI

A powerful CLI tool for managing Laravel package development workflows. Streamline your local package development with automated symlink management, development server orchestration, and convenient shortcuts.

## Features

- 🔗 **Symlink Management**: Automatically link/unlink local packages to Laravel projects
- 🚀 **Development Server Management**: Start Laravel and npm dev servers with tmux integration
- 📦 **Project Organization**: Manage multiple Laravel projects and packages
- ⚡ **Quick Commands**: Shortcuts for common artisan and npm commands
- 🎯 **Tab Completion**: Full bash completion support for all commands
- 🔄 **Context Switching**: Easily switch between different projects

## Installation

### Via npm (Recommended)

```bash
npm install -g lpdev
```

Or with yarn:

```bash
yarn global add lpdev
```

### Manual Installation

```bash
git clone https://github.com/yourusername/lpdev.git
cd lpdev
npm install -g .
```

## Quick Start

### 1. Add a Laravel Project

```bash
lpdev add
# Follow the prompts to configure your project
```

### 2. Link Your Package for Development

```bash
lpdev link
# This creates a symlink from your Laravel app to your local package
```

### 3. Start Development Servers

```bash
lpdev start
# Starts both Laravel and npm dev servers in tmux panes
```

## Commands

### Project Management

| Command | Description |
|---------|-------------|
| `lpdev add` | Add a new Laravel project configuration |
| `lpdev list` | List all configured projects |
| `lpdev use <project>` | Switch to a different project |
| `lpdev remove <project>` | Remove a project configuration |
| `lpdev current` | Show current active project |

### Package Development

| Command | Description |
|---------|-------------|
| `lpdev link` | Create symlink to local package |
| `lpdev unlink` | Remove package symlink |
| `lpdev status` | Show link status |

### Development Servers

| Command | Description |
|---------|-------------|
| `lpdev start` | Start all development servers |
| `lpdev start laravel` | Start only Laravel server |
| `lpdev start npm` | Start only npm dev server |
| `lpdev stop` | Stop all servers |

### Shortcuts

| Command | Alias | Description |
|---------|-------|-------------|
| `lpdev artisan <command>` | `lpdev a` | Run artisan command in Laravel app |
| `lpdev app <command>` | - | Run command in app directory |
| `lpdev pkg <command>` | - | Run command in package directory |
| `lpdev composer <command>` | `lpdev c` | Run composer in app directory |

## Configuration

Configuration files are stored in `~/.lpdev/`:

- `projects.json` - Project configurations
- `current_project` - Current active project

### Project Configuration Structure

```json
{
  "my-project": {
    "app_path": "/path/to/laravel/app",
    "package_path": "/path/to/local/package",
    "vendor_name": "vendor-name",
    "package_name": "package-name",
    "app_url": "http://localhost:8000",
    "npm_dev_port": 5173
  }
}
```

## Requirements

- **Bash** 4.0+
- **Node.js** 14.0+
- **Python3** (for JSON parsing)
- **tmux** (optional, for server management)
- **Laravel** application
- **Composer** installed globally

## Platform Support

- ✅ macOS
- ✅ Linux
- ⚠️ Windows (via WSL/Git Bash - limited support)

## Examples

### Complete Workflow

```bash
# Add and configure a new project
lpdev add

# Link package for development
lpdev link

# Start development servers
lpdev start

# Run database migrations
lpdev artisan migrate

# Clear application cache
lpdev a cache:clear

# Build package assets
lpdev pkg npm run build

# Run tests in package
lpdev pkg composer test

# Stop servers and unlink when done
lpdev stop
lpdev unlink
```

### Working with Multiple Projects

```bash
# List all projects
lpdev list

# Switch to different project
lpdev use my-other-project

# Show current project
lpdev current
```

## Troubleshooting

### Completion not working?

After installation, source your shell configuration:

```bash
source ~/.bashrc  # or ~/.zshrc for zsh
```

### Permission Issues

Make sure the global npm directory is in your PATH:

```bash
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Symlink Issues

If you encounter symlink problems:

1. Check package exists: `lpdev status`
2. Unlink and relink: `lpdev unlink && lpdev link`
3. Verify composer autoload: `lpdev composer dump-autoload`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT

## Author

Dima Botezatu - [dimabotezatu.com](https://dimabotezatu.com)

## Support

For issues and questions, please use the [GitHub issue tracker](https://github.com/yourusername/lpdev/issues).