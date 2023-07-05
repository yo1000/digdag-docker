#!/bin/bash

mkdir -p /var/digdag/projects
cd /var/digdag/projects

for dir in "$(ls -p | grep "/$")" ; do
  cd "/var/digdag/projects/${dir}"

  echo "Project name: '$(echo "${dir}" | sed -e 's/\/$//')'"
  echo "Project files:"
  ls "${dir}"

  digdag push "$(echo "${dir}" | sed -e 's/\/$//')"
done

