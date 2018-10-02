alias dc=docker-compose
alias dce='docker-compose exec'
alias dcr='docker-compose run --rm --label traefik.enable=False'
alias dcb='docker-compose build --pull'
alias dcb='docker-compose build --pull'

alias dcds='docker-compose run --rm --label traefik.enable=False django shell_plus'
alias dcm='docker-compose run --rm --label traefik.enable=False django migrate'
alias dcmm='docker-compose run --rm --label traefik.enable=False django makemigrations'
alias dci='docker-compose run --rm --label traefik.enable=False django i18n'
alias dcrs='docker-compose run --rm django runserver 0:8000'