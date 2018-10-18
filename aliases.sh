# common docker-compose aliases
alias dc=docker-compose
alias dce='docker-compose exec'
alias dcr='docker-compose run --rm --label traefik.enable=False'
alias dcb='docker-compose build'


# django aliases
alias djs='dcr django shell_plus'
alias djm='dcr django migrate'
alias djmm='dcr django makemigrations'
alias dji='dcr django i18n'
alias djt='dcr -e DJANGO_CONFIGURATION=Test django test --no-input --parallel=$(python -c "import multiprocessing; print(multiprocessing.cpu_count())")'
alias djrc='dcr --entrypoint=celery django worker -A $(basename $(pwd))'
alias djpip='dcr --entrypoint "bash -c \"which pipenv && pipenv lock || pip-compile\"" django && dcb'
# unlike the aliases above, this will make the running process accessible via the proxy, so this
# can be used for interactive debugging if you stop the "django" service with `dc stop django`
# beforehand
alias djrs='docker-compose run --rm --use-aliases django runserver 0:8000'


# postgres aliases
alias dcdb='dce db psql -Uapp app'


# angular aliases
alias ng='dcr angular run-script ng'
alias ngg='dcr angular run-script ng g -- --spec=false'
alias ngl='dcr angular run-script ng lint --'
alias ngi='dcr angular run-script i18n'