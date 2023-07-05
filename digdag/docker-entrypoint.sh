#!/bin/bash

mkdir -p /opt/etc/digdag

echo "
# server
server.bind = ${SERVER_BIND:-"0.0.0.0"}
server.port = ${SERVER_PORT:-"65432"}

# database
database.type = ${DATABASE_TYPE:-"postgresql"}
database.user = ${DATABASE_USER:-"postgres"}
database.password = ${DATABASE_PASSWORD:-"postgres"}
database.host = ${DATABASE_HOST:-"localhost"}
database.database = ${DATABASE_DATABASE:-"digdag"}
database.maximumPoolSize = ${DATABASE_MAXIMUM_POOL_SIZE:-"32"}
">/opt/etc/digdag/server.properties

java -jar /usr/local/bin/digdag server -c /opt/etc/digdag/server.properties &

while [[ "$(netstat -an | grep LISTEN | grep ":65432")" == "" ]]; do
  echo "sleep 2"
  sleep 2
done

# Import project pre-sets
cd /var/digdag/project_presets

for dir in "$(ls -p | grep "/$")" ; do
  cd "/var/digdag/project_presets/${dir}"

  echo "Project name: '$(echo "${dir}" | sed -e 's/\/$//')'"
  echo "Project files:"
  ls "${dir}"

  digdag push "$(echo "${dir}" | sed -e 's/\/$//')"
done

while :; do sleep 10; done

