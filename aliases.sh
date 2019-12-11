# common docker-compose aliases
alias dc=docker-compose
alias dce='docker-compose exec'
alias dcr='docker-compose run --rm --label traefik.enable=False'
alias dcb='docker-compose build --pull'


# django aliases
alias djs='dcr django shell_plus'
alias djm='dcr django migrate'
alias djmm='dcr django makemigrations'
alias dji='dcr django i18n'
alias djp='dcr django update_permissions && dcr django permissions'
alias djt='dcr -e DJANGO_CONFIGURATION=Test django test --no-input --parallel=$(expr $(nproc) / 2)'
alias djrc='dcr --entrypoint=celery django worker -A $(basename $(pwd))'
alias djpip='dcr --entrypoint "bash -c \"which pipenv && pipenv lock || pip-compile\"" django && dcb'
alias djdocs='docker-compose run --rm --entrypoint "bash -c" django "cd docs && make html -s"'
alias djl='dcr --entrypoint="pylint --rcfile=pylintrc -j`nproc`" django --'
# unlike the aliases above, this will make the running process accessible via the proxy, so this
# can be used for interactive debugging if you stop the "django" service with `dc stop django`
# beforehand
alias djrs='dc stop django; docker-compose run --rm --use-aliases django runserver 0:8000'


# postgres aliases
alias dcdb='dce db psql -Uapp app'


# angular aliases
function _ngg () {
    dcr angular run-script -- ng g "$@" --spec=false
}
alias ng='dcr angular run-script ng'
alias ngg='_ngg'
alias ngl='dcr angular run-script ng lint --'
alias ngi='dcr angular run-script i18n'
