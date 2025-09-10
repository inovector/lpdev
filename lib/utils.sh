#!/bin/bash

# Color output functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_header() {
    echo -e "\n${BOLD}${BLUE}$1${NC}"
    echo -e "${BLUE}$(printf '%.0s=' {1..50})${NC}"
}

# Project display helpers
show_command_start() {
    local current_project=$(get_current_project_name 2>/dev/null)
    if [ -n "$current_project" ]; then
        echo -e "${BOLD}${CYAN}📂 Project: ${current_project}${NC} | Command: ${GREEN}$1${NC}"
        echo -e "${CYAN}$(printf '%.0s─' {1..60})${NC}"
    fi
}

show_command_end() {
    local current_project=$(get_current_project_name 2>/dev/null)
    if [ -n "$current_project" ]; then
        echo -e "${CYAN}$(printf '%.0s─' {1..60})${NC}"
        echo -e "${BOLD}${GREEN}✓ Completed${NC} | Project: ${CYAN}${current_project}${NC} | Command: ${GREEN}$1${NC}"
    fi
}

get_current_git_branch() {
    local path="$1"
    local default_branch="${2:-main}"
    
    if [ -d "$path/.git" ]; then
        cd "$path"
        local git_branch=$(git branch --show-current 2>/dev/null)
        if [ -n "$git_branch" ]; then
            echo "dev-$git_branch"
            return 0
        fi
    fi
    
    # Fallback to default branch
    print_warning "Could not detect git branch, using default: $default_branch"

    echo "dev-$default_branch"
}

set_env_var() {
    local env_file=$1
    local env_key=$2
    local env_value=$3
    
    if [ -f "$env_file" ]; then
        if grep -q "^$env_key=" "$env_file"; then
            sed -i.bak "s|^$env_key=.*|$env_key=\"$env_value\"|" "$env_file"
        else
            echo "$env_key=\"$env_value\"" >> "$env_file"
        fi
        rm -f "${env_file}.bak"
    fi
}

get_env_var_value() {
    local env_file=$1
    local env_key=$2
    
    if [ -f "$env_file" ]; then
        local value=$(grep "^$env_key=" "$env_file" | cut -d'=' -f2- | tr -d '"')
        echo "$value"
    fi
}

get_package_name() {
    local package_path="$1"
    
    if [ ! -f "$package_path/composer.json" ]; then
        return 1
    fi
    
    python3 << EOF
import json
try:
    with open("$package_path/composer.json", 'r') as f:
        package_data = json.load(f)
    print(package_data.get('name', ''))
except:
    pass
EOF
}

getAppUrl() {
    get_env_var_value "$LPDEV_APP_PATH/.env" "APP_URL"
}