#!/usr/bin/env bash

DATABASE_URL_PATH=$(echo $DATABASE_URL | sed 's#^\([^:]\+\)://\(\([^:]\+\)\(:\([^@]\+\)\?\)\?@\)\?\([^:/]\+\)\(:\([1-9][0-9]*\)\)\?\(/.*\)\?#\9#')
DB_NAME=${DB_NAME:-${DATABASE_URL_PATH##*/}}

log () {
  echo "[docker-entrypoint.sh] ===> $1"
}

# Bundle install for development convenience. This will ensure any changes to
# the Gemfile are picked up, even if the image hasn't been rebuilt yet. Also set
# the path to /balance_dependencies/bundle for this and all future runs.
bundle_install () {
  log "running bundle install"

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
#
# If there's a pre-existing database, then a db snapshot is taken before running
# any migrations.
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

# Start the rails server
start_server () {
  # Common issue in local development: pid must be removed before starting a new
  # server, otherwise server startup will fail
  rm -f tmp/pids/server.pid

  log "starting rails server"
  exec bundle exec rails s -p 3003 -b '0.0.0.0'
}

#
# Run everything
#
bundle_install && \
setup_db && \
prepare_db && \
start_server
