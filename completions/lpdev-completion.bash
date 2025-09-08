#!/bin/bash

# Detect shell and set up completion accordingly
if [[ -n ${ZSH_VERSION-} ]]; then
    # ZSH completion
    _lpdev_completions() {
        local -a commands artisan_commands env_vars common_commands projects
        
        commands=(
            "add:Add a new project"
            "list:List all projects" "ls:List all projects"
            "switch:Switch to project" "sw:Switch to project"
            "remove:Remove project" "rm:Remove project"
            "status:Show project status" "st:Show project status"
            "link:Link local package"
            "unlink:Unlink package"
            "branch:Switch branch" "br:Switch branch"
            "install:Install dependencies" "i:Install dependencies"
            "start:Start servers (deprecated)" "up:Start servers (deprecated)"
            "dev:Start development environment"
            "horizon-watch:Start Horizon with file watching"
            "stop:Stop servers" "down:Stop servers"
            "restart:Restart servers"
            "artisan:Run artisan command" "a:Run artisan command"
            "clear:Clear cache" "cache:Clear cache"
            "fresh:Fresh install"
            "migrate:Run migrations" "m:Run migrations"
            "tinker:Start tinker" "t:Start tinker"
            "test:Run tests"
            "build:Build package"
            "publish:Publish assets" "pub:Publish assets"
            "env:Set environment variable"
            "app:Run command in app directory"
            "pkg:Run command in package directory"
            "share:Share app via ngrok"
            "share-stop:Stop ngrok tunnel"
            "logs:Tail logs" "log:Tail logs"
            "help:Show help" "h:Show help"
        )
        
        artisan_commands=(
            "migrate" "migrate:fresh" "migrate:rollback"
            "make:controller" "make:model" "make:migration" "make:seeder"
            "db:seed" "cache:clear" "config:clear" "route:list"
            "queue:work" "schedule:run" "tinker" "serve"
        )
        
        case $words[CURRENT-1] in
            lpdev)
                _describe 'commands' commands
                ;;
            artisan|a)
                _describe 'artisan commands' artisan_commands
                ;;
            switch|sw|remove|rm)
                if [[ -f "$HOME/.lpdev/projects.json" ]]; then
                    projects=(${(f)"$(python3 -c "import json; f=open('$HOME/.lpdev/projects.json'); [print(p['name']) for p in json.load(f)]" 2>/dev/null)"})
                    _describe 'projects' projects
                fi
                ;;
            env)
                env_vars=(
                    "APP_NAME" "APP_ENV" "APP_DEBUG" "APP_URL"
                    "DB_CONNECTION" "DB_HOST" "DB_PORT" "DB_DATABASE" "DB_USERNAME" "DB_PASSWORD"
                    "CACHE_DRIVER" "SESSION_DRIVER" "QUEUE_CONNECTION"
                    "REDIS_HOST" "REDIS_PORT"
                    "MAIL_MAILER" "MAIL_HOST" "MAIL_PORT"
                    "LPDEV_QUEUE_NAME" "LPDEV_EXCLUDE"
                )
                _describe 'env variables' env_vars
                ;;
            app|pkg)
                common_commands=("composer" "npm" "php" "artisan" "ls" "pwd")
                _describe 'common commands' common_commands
                ;;
        esac
    }
    
    compdef _lpdev_completions lpdev
    
else
    # BASH completion
    _lpdev_completions() {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        
        # Main commands (bash string format)
        local commands="add list ls switch sw remove rm status st link unlink branch br install i start up start-full dev horizon-watch stop down restart artisan a clear cache fresh migrate m tinker t test build publish pub env app pkg share share-stop logs log help h"
        
        # Artisan commands (common ones)
        local artisan_commands="migrate migrate:fresh migrate:rollback make:controller make:model make:migration make:seeder db:seed cache:clear config:clear route:list queue:work schedule:run tinker serve"
        
        case "${prev}" in
            lpdev)
                COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
                return 0
                ;;
            artisan|a)
                COMPREPLY=( $(compgen -W "${artisan_commands}" -- ${cur}) )
                return 0
                ;;
            switch|sw|remove|rm)
                # Get project names from config
                if [ -f "$HOME/.lpdev/projects.json" ]; then
                    local projects=$(python3 -c "import json; f=open('$HOME/.lpdev/projects.json'); print(' '.join([p['name'] for p in json.load(f)]))" 2>/dev/null)
                    COMPREPLY=( $(compgen -W "${projects}" -- ${cur}) )
                fi
                return 0
                ;;
            env)
                # Common Laravel env variables including lpdev-specific ones
                local env_vars="APP_NAME APP_ENV APP_DEBUG APP_URL DB_CONNECTION DB_HOST DB_PORT DB_DATABASE DB_USERNAME DB_PASSWORD CACHE_DRIVER SESSION_DRIVER QUEUE_CONNECTION REDIS_HOST REDIS_PORT MAIL_MAILER MAIL_HOST MAIL_PORT LPDEV_QUEUE_NAME LPDEV_EXCLUDE"
                COMPREPLY=( $(compgen -W "${env_vars}" -- ${cur}) )
                return 0
                ;;
            app|pkg)
                # Suggest common commands
                local common_commands="composer npm php artisan ls pwd"
                COMPREPLY=( $(compgen -W "${common_commands}" -- ${cur}) )
                return 0
                ;;
        esac
        
        # Default to commands if nothing else matches
        if [[ ${cur} == -* ]] ; then
            COMPREPLY=( $(compgen -W "--help --exclude" -- ${cur}) )
        else
            COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
        fi
    }
    
    complete -F _lpdev_completions lpdev
fi