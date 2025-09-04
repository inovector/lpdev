#!/bin/bash
# Bash completion script for lpdev
# Install this file:
# 1. Save as: lpdev-completion.bash
# 2. Add to your .bashrc or .bash_profile:
#    source /path/to/lpdev-completion.bash
# Or for system-wide:
# 3. sudo cp lpdev-completion.bash /etc/bash_completion.d/lpdev

_lpdev_completions() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Main commands
    commands="add list ls switch sw remove rm status st link unlink branch br install i start up stop down restart artisan a clear cache fresh migrate m tinker t test build publish pub env app pkg logs log help h"
    
    # Artisan commands (common ones)
    artisan_commands="migrate migrate:fresh migrate:rollback make:controller make:model make:migration make:seeder db:seed cache:clear config:clear route:list queue:work schedule:run tinker serve"
    
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
                projects=$(python3 -c "import json; f=open('$HOME/.lpdev/projects.json'); print(' '.join([p['name'] for p in json.load(f)]))" 2>/dev/null)
                COMPREPLY=( $(compgen -W "${projects}" -- ${cur}) )
            fi
            return 0
            ;;
        env)
            # Common Laravel env variables
            env_vars="APP_NAME APP_ENV APP_DEBUG APP_URL DB_CONNECTION DB_HOST DB_PORT DB_DATABASE DB_USERNAME DB_PASSWORD CACHE_DRIVER SESSION_DRIVER QUEUE_CONNECTION REDIS_HOST REDIS_PORT MAIL_MAILER MAIL_HOST MAIL_PORT"
            COMPREPLY=( $(compgen -W "${env_vars}" -- ${cur}) )
            return 0
            ;;
        app|pkg)
            # Suggest common commands
            common_commands="composer npm php artisan ls pwd"
            COMPREPLY=( $(compgen -W "${common_commands}" -- ${cur}) )
            return 0
            ;;
    esac
    
    # Default to commands if nothing else matches
    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(compgen -W "--help" -- ${cur}) )
    else
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) )
    fi
}

complete -F _lpdev_completions lpdev