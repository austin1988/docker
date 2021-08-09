#!/bin/sh
#
# Simple script that will display docker repository tags.
#
# Usage:
#   $ docker-search.sh centos
args="`echo $* | sed 's#/#\\\/#g'`"
echo $*
echo $args
for Repo in $args ; do
  echo $Repo
  curl -s -S "https://registry.hub.docker.com/v2/repositories/library/$Repo/tags/" | \
    sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
    grep '"name"' | \
    awk -F\" '{print $4;}' | \
    sort -fu | \
    sed -e "s/^/${Repo}:/"
done

