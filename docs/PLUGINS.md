# LPDEV NPM Plugin System

## Overview

LPDEV now supports installing plugins directly from npm, making it easy to discover, share, and manage plugins for the Laravel Package Development CLI.

## Quick Start

### Installing Plugins

```bash
# Search for available plugins
lpdev plugin search

# Install a plugin from npm
lpdev plugin install plugin-name

# Or, install from a local directory:
lpdev plugin install /path/to/your/plugin-directory

# Enable the plugin
lpdev plugin enable plugin-name

# List all installed plugins
lpdev plugin list
```

### Using Plugins

```bash
# Execute plugin command
lpdev plugin plugin_name status

# Disable a plugin
lpdev plugin disable plugin_name

# Uninstall a plugin
lpdev plugin uninstall plugin_name
```

## Plugin Management Commands

| Command | Description |
|---------|------------|
| `lpdev plugin list` | List all installed plugins with status |
| `lpdev plugin install <name>` | Install plugin from npm registry |
| `lpdev plugin uninstall <name>` | Remove installed plugin |
| `lpdev plugin enable <name>` | Enable an installed plugin |
| `lpdev plugin disable <name>` | Disable a plugin |
| `lpdev plugin search [term]` | Search npm for plugins |
| `lpdev plugin <name> <command>` | Execute plugin command |

## Creating Plugins

### 1. Package Structure

```
lpdev-plugin-plugin_name/
├── package.json       # NPM package metadata
├── index.plugin       # Main plugin file (bash script)
├── README.md         # Documentation
└── LICENSE           # License file
```

### 2. Naming Convention

All lpdev plugins on npm must follow the naming pattern:
```
lpdev-plugin-{plugin_name}
```

For example:
- `lpdev-plugin-mixpost`
- `lpdev-plugin-docker`
- `lpdev-plugin-tools`

### 3. package.json Structure

```json
{
  "name": "lpdev-plugin-plugin_name",
  "version": "1.0.0",
  "description": "Description of your lpdev plugin",
  "main": "index.plugin",
  "keywords": [
    "lpdev-plugin",
    "lpdev",
    "laravel",
    "your-keywords"
  ],
  "author": "Your Name",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/yourusername/lpdev-plugin-plugin_name.git"
  },
  "files": [
    "index.plugin",
    "README.md"
  ],
  "scripts": {
    "test": "bash -n index.plugin"
  },
  "lpdev": {
    "hooks": ["on_env_set", "on_project_add"],
    "commands": ["status", "config", "help"]
  }
}
```

### 4. index.plugin Template

```bash
#!/bin/bash

# Plugin metadata
PLUGIN_NAME="plugin_name"
PLUGIN_VERSION="1.0.0"
PLUGIN_DESCRIPTION="Your plugin description"

# Hook functions (optional)
on_project_add() {
    local project_name="$1"
    local app_url="$2"
    local app_path="$3"
    local package_path="$4"
    
    print_info "[$PLUGIN_NAME] Setting up for project: $project_name"
}

# Plugin commands
case "$1" in
    status)
        plugin_plugin_name_status
        ;;
    config)
        plugin_plugin_name_config "$2"
        ;;
    *)
        plugin_plugin_name_help
        ;;
esac

# Command implementations
plugin_plugin_name_status() {
    eval $(get_current_project) || return 1
    
    print_header "[$PLUGIN_NAME] Status"
    # Your status logic here
}

plugin_plugin_name_config() {
    local setting="$1"
    print_info "[$PLUGIN_NAME] Configuring: $setting"
    # Your config logic here
}

plugin_plugin_name_help() {
    echo -e "${BOLD}${BLUE}Your Plugin Name${NC}

${BOLD}USAGE:${NC}
    lpdev plugin plugin_name <command> [options]

${BOLD}COMMANDS:${NC}
    ${GREEN}status${NC}        Show plugin status
    ${GREEN}config${NC}        Configure plugin
    ${GREEN}help${NC}          Show this help

${BOLD}EXAMPLES:${NC}
    lpdev plugin plugin_name status
    lpdev plugin plugin_name config setting-name"
}
```

### 5. Available Functions

Plugins have access to all lpdev functions:

- **Helpers**: `print_success()`, `print_error()`, `print_info()`, `print_warning()`, `print_header()`
- **Project**: `get_current_project()`, `set_env_var()`
- **Hooks**: `call_plugin_hook()`

### 6. Available Hooks

| Hook | Triggered When | Arguments |
|------|---------------|-----------|
| `on_env_set` | Environment variable is set | `key, value, app_path, package_path` |
| `on_project_add` | New project is added | `project_name, app_url, app_path, package_path` |

### 7. Publishing to NPM

```bash
# Login to npm
npm login

# Publish your plugin
npm publish

# Users can now install with:
lpdev plugin install plugin_name
```

## How It Works

1. **Installation**: When you run `lpdev plugin install name`, lpdev:
   - Looks for `lpdev-plugin-name` on npm
   - Installs it to `~/.lpdev/plugins/available/node_modules/`
   - Creates a symlink from the plugin's `index.plugin` file

2. **Enabling**: `lpdev plugin enable name` creates a symlink in `~/.lpdev/plugins/enabled/`

3. **Loading**: At startup, lpdev sources all enabled plugins

4. **Execution**: Plugin commands are executed in the lpdev environment with access to all functions

## Directory Structure

```
~/.lpdev/plugins/
├── available/
│   ├── node_modules/           # NPM packages
│   │   └── lpdev-plugin-*/
│   ├── package.json            # NPM manifest
│   └── *.plugin               # Symlinks to plugins
└── enabled/
    └── *.plugin               # Symlinks to enabled plugins
```

## Benefits

- **Discoverability**: Easy to find plugins via `npm search lpdev-plugin`
- **Versioning**: Semantic versioning and dependency management
- **Updates**: Simple updates with `npm update`
- **Community**: Share plugins with the Laravel community
- **Documentation**: README and package.json metadata

## Example Plugins

- `lpdev-plugin-mixpost` - Mixpost.app specific development tools

## Troubleshooting

### Plugin not found
```bash
# Check if it exists on npm
npm view lpdev-plugin-name

# Search for similar names
lpdev plugin search name
```

### Plugin won't load
```bash
# Check if enabled
lpdev plugin list

# Enable if needed
lpdev plugin enable name

# Check for errors
bash -n ~/.lpdev/plugins/enabled/name.plugin
```

### Plugin conflicts
```bash
# Disable conflicting plugin
lpdev plugin disable other-plugin

# Or uninstall
lpdev plugin uninstall other-plugin
```