#!/bin/bash

if ! which docker-compose > /dev/null; then
  echo "could not find 'docker-compose' executable; sure docker is installed?"
  exit 1
fi
docker-compose -f docker-compose.$(uname -s).yaml up -d