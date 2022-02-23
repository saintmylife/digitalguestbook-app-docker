#!/bin/sh
set -e

#Check if gems are installed
bundle check || bundle install

#Remove pre-existing server-pid for Rails
rm -f /app/tmp/pids/server.pid

#Run the command
exec "$@"