#!/bin/bash

get_current_project() {
    if [ ! -s "$CURRENT_PROJECT_FILE" ]; then
        print_error "No project selected. Use 'lpdev switch' to select a project."
        return 1
    fi
    
    current=$(cat "$CURRENT_PROJECT_FILE")
    
    python3 << EOF
import json
import sys

with open("$CONFIG_FILE", 'r') as f:
    projects = json.load(f)

for p in projects:
    if p['name'] == "$current":
        print(f"export LPDEV_PROJECT='{p['name']}'")
        print(f"export LPDEV_APP_PATH='{p['app_path']}'")
        print(f"export LPDEV_PACKAGE_PATH='{p['package_path']}'")
        print(f"export LPDEV_PACKAGE_VENDOR='{p['package_vendor']}'")
        print(f"export LPDEV_PACKAGE_VENDOR_PATH='{p['package_vendor_path']}'")
        sys.exit(0)

sys.exit(1)
EOF
}

get_current_project_name() {
    if [ ! -s "$CURRENT_PROJECT_FILE" ]; then
        return 1
    fi
    
    cat "$CURRENT_PROJECT_FILE"
}