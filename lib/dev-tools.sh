#!/bin/bash

installDevTools () {
    installTelescope
    installHorizonWatcher
}


installTelescope () {
    cd "$LPDEV_APP_PATH"

    if php artisan list | grep -q "telescope:install"; then
        if ! composer show laravel/telescope >/dev/null 2>&1; then
            print_info "Installing laravel/telescope..."
            composer require laravel/telescope
            php artisan telescope:install
            php artisan migrate
            print_info "Laravel Telescope detected - using telescope (use 'lpdev telescope' for dashboard)"
        else
            print_info "Laravel Telescope detected - using telescope (use 'lpdev telescope' for dashboard)"
        fi
    fi
}

installHorizonWatcher () {
    cd "$LPDEV_APP_PATH"
    
    if php artisan list | grep -q "horizon:work\|horizon$"; then
        if ! composer show spatie/laravel-horizon-watcher >/dev/null 2>&1; then
            print_info "Installing spatie/laravel-horizon-watcher..."
            composer require --dev spatie/laravel-horizon-watcher
            npm install chokidar --save-dev
            print_info "Laravel Horizon detected - using horizon (use 'lpdev horizon-watch' for file watching)"
        else
            print_info "Laravel Horizon detected - using horizon (use 'lpdev horizon-watch' for file watching)"
        fi
    fi
}