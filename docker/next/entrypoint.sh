#!/bin/sh

echo "Contener runner"

if [ "$DOCKER_ENV" = "dev" ]; then
    npm install
fi

exec "$@"