#!/bin/bash

helmDepUp () {
  path=$1
  (
    cd $path
    echo "Updating dependencies in $path ..."
    helm dep up
    echo "... done."
    if [ -d charts ]; then
      cd charts
      for path in $(find . -mindepth 1 -maxdepth 1 -name "*.tgz")
      do
        tar -xvf $path
        rm $path
      done
      for path in $(find . -mindepth 1 -maxdepth 1 -type d)
      do
        helmDepUp $(pwd)"/"$path
      done
    fi
  )
}

helmDepUp $1
