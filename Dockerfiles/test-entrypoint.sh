#!/usr/bin/env bash

DATABASE_URL_PATH=$(echo $DATABASE_URL | sed 's#^\([^:]\+\)://\(\([^:]\+\)\(:\([^@]\+\)\?\)\?@\)\?\([^:/]\+\)\(:\([1-9][0-9]*\)\)\?\(/.*\)\?#\9#')
DB_NAME=${DB_NAME:-${DATABASE_URL_PATH##*/}}

log () {
  echo "[docker-entrypoint.sh] ===> $1"
}

bundle_install () {
  log "running bundle install"

  export RAILS_ENV=test
  export PATTERN="spec/swagger/**/**/*_spec.rb"
  bundle install --path /app_dependencies/bundle
}

# Create a new database, if necessary
setup_db () {
  log "checking for existing database"
  bundle exec rake db:version >/dev/null 2>&1

  if [ $? -ne 0 ]; then
    log "!!! creating new database: $DB_NAME"
    bundle exec rake db:create
  fi
}

# Migrates and seeds our database, if necessary
prepare_db () {
  log "checking current migrations"
  MIGRATIONS=$(bundle exec rake db:migrate:status)

  # If we have not run any migrations, then exit code will be non-zero
  # In this case, migrate and seed.
  if [ $? -ne 0 ]; then
    log "!!! performing initial migration"
    bundle exec rake db:migrate db:seed
  else
    echo "$MIGRATIONS"
    echo "$MIGRATIONS" | awk '{print $1}' | grep 'down' >/dev/null 2>&1

    # If we have "down" migrations, then we'll need to backup the database
    # and run rake db:migrate
    if [ $? -eq 0 ]; then
      log "!!! performing required migrations"
      bundle exec rake db:migrate
    fi
  fi
}

run_tests () {
  log "running tests"
  bundle exec rake rswag:specs:swaggerize

  export COVERAGE=true
  bundle exec rake test:all
}

#
# Run everything
#
bundle_install && \
setup_db && \
prepare_db && \
run_tests




