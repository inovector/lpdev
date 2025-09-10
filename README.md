# lpdev - Laravel Package Development CLI

A powerful CLI tool for managing Laravel package development workflows. Streamline your local package development with automated symlink management, development server orchestration, and convenient shortcuts.

## Features

- 🔗 **Symlink Management**: Automatically link/unlink local packages to Laravel projects
- 🚀 **Development Server Management**: Start Laravel and npm dev servers with tmux integration
- 📦 **Project Organization**: Manage multiple Laravel projects and packages
- ⚡ **Quick Commands**: Shortcuts for common artisan and npm commands
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
| `lpdev dev` | Start full development environment (server, queue, logs, vite) |
| `lpdev dev --exclude=service1,service2` | Start dev environment excluding specified services |
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

### Environment Variables

LPDEV supports project-specific environment variables stored in your project configuration:

#### LPDEV Project Environment Variables

Manage lpdev project configuration with these commands:

- `lpdev env-set <key> <value>` - Set project environment variable
- `lpdev env-remove <key>` - Remove project environment variable  
- `lpdev env-list` - List all project environment variables

| Variable | Description | Default |
|----------|-------------|---------|
| `QUEUE_NAME` | Specific queue name to listen to (only for queue:listen) | Uses default queue |
| `EXCLUDE` | Default services to exclude from `lpdev dev` | None excluded |

#### Setting Default Exclusions

```bash
# Exclude specific services by default for this project
lpdev env-set EXCLUDE "logs,vite"

# Set custom queue name
lpdev env-set QUEUE_NAME "high-priority"

# List current project environment variables
lpdev env-list

# Remove environment variable
lpdev env-remove EXCLUDE
```

#### Service Exclusion

The `lpdev dev` command supports excluding specific services with the `--exclude` flag:

**Available Services:**
- `server` - Laravel development server (`php artisan serve`)
- `queue` - Queue worker (Horizon or queue:listen)
- `logs` - Log tailing (`php artisan pail`) - Laravel 11+ only
- `reverb` - Laravel Reverb WebSocket server (`php artisan reverb:start`)
- `vite` - Vite dev server from package (`npm run dev`)  

**Command Line Examples:**
```bash
lpdev dev --exclude=queue          # Skip queue worker
lpdev dev --exclude=queue,logs     # Skip queue and logs
```

**Setting Default Exclusions:**
You can set default exclusions via lpdev project configuration:
```bash
# Set via lpdev project configuration
lpdev env-set EXCLUDE "queue,logs"   # Always exclude queue and logs by default
```

With `EXCLUDE` set, running `lpdev dev` will automatically exclude those services. You can still override with the `--exclude` flag:
```bash
lpdev dev                        # Uses EXCLUDE from project config
lpdev dev --exclude=queue        # Overrides config, excludes only queue
```

**Use Cases:**
- Set `EXCLUDE=queue` if you prefer running `lpdev horizon-watch` separately
- Set `EXCLUDE=logs` if you prefer using external log viewers

#### Queue Management

The `lpdev dev` command automatically detects and uses the best queue management tool available:

1. **Laravel Horizon with Watcher** (if available): Runs `lpdev horizon-watch`. When using Horizon Watcher, make sure to exclude the horizon service from `lpdev dev` using `--exclude=queue` or setting `EXCLUDE=queue` in project config.
2. **Laravel Horizon** Runs `php artisan horizon`
3. **Standard Queue**: Falls back to `php artisan queue:listen --tries=1`


**Horizon Watcher Benefits:**
- Automatically restarts Horizon when configuration files change
- Perfect for development when tweaking queue settings
- No manual restarts needed when modifying `config/horizon.php`

If using standard queue:listen, you can specify a custom queue name:
```bash
# Set via lpdev project configuration
lpdev env-set QUEUE_NAME high-priority  # Will run: php artisan queue:listen --queue=high-priority --tries=1
```

Note: QUEUE_NAME is ignored when Horizon is detected, as Horizon manages its own queue configuration.

## Plugin System

lpdev supports a powerful plugin system for extending functionality. Plugins can hook into various lpdev operations and add custom commands.

📚 **[Plugin Documentation](docs/PLUGINS.md)** - Complete guide to creating and using plugins

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

# Start full development environment (server, queue, logs, vite)
lpdev dev

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

LPDEV is licensed under the [MIT License](LICENSE.md), sponsored and supported by [Inovector](https://inovector.com).