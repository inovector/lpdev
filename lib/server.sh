#!/bin/bash

check_server_status() {
    local service_name="$1"
    local process_pattern="$2"
    local port="$3"
    local project_specific="$4"
    
    local pid=""
    local status=""
    local details=""
    
    # Check for project-specific processes if requested
    if [ "$project_specific" = "true" ] && [ -n "$LPDEV_PROJECT" ]; then
        pid=$(pgrep -f "$process_pattern.*$LPDEV_PROJECT" 2>/dev/null | head -1)
    fi
    
    # Fallback to general process pattern
    if [ -z "$pid" ]; then
        pid=$(pgrep -f "$process_pattern" 2>/dev/null | head -1)
    fi
    
    if [ -n "$pid" ]; then
        status="${GREEN}✓${NC}"
        details="(PID: $pid"
        
        # Add port information if available
        if [ -n "$port" ]; then
            if netstat -an 2>/dev/null | grep -q ":$port.*LISTEN" || ss -ln 2>/dev/null | grep -q ":$port "; then
                details="$details, Port: $port"
            fi
        fi
        details="$details)"
    else
        status="${RED}✗${NC}"
        details=""
    fi
    
    echo -e "  $status $service_name $details"
}

show_running_servers() {
    echo -e "${BOLD}Running Servers:${NC}"
    
    # Laravel server
    check_server_status "Laravel server" "artisan serve" "8000" "false"
    
    # Laravel Horizon
    local horizon_running=""
    if pgrep -f "artisan horizon" > /dev/null 2>&1; then
        check_server_status "Laravel Horizon" "artisan horizon" "" "false"
        horizon_running="true"
    fi
    
    # Laravel Queue Worker (only show if Horizon is not running)
    if [ "$horizon_running" != "true" ]; then
        check_server_status "Laravel Queue" "artisan queue:listen\|artisan queue:work" "" "false"
    fi
    
    # Laravel Pail (logs)
    check_server_status "Laravel Pail" "artisan pail" "" "false"
    
    # Package Vite dev server
    if [ -d "$LPDEV_PACKAGE_PATH/node_modules" ]; then
        check_server_status "Package Vite dev" "npm run dev.*$LPDEV_PACKAGE_PATH\|vite.*$LPDEV_PACKAGE_PATH" "" "false"
    fi
}

is_excluded() {
    local service="$1"
    local excluded_services="$2"
    
    if [ -z "$excluded_services" ]; then
        return 1  # Not excluded
    fi
    
    # Check if service is in comma-separated list
    case ",$excluded_services," in
        *,"$service",*) return 0 ;;  # Excluded
        *) return 1 ;;               # Not excluded
    esac
}