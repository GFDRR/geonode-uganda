#!/bin/bash

WORKDIR=$(dirname $0)
pushd $WORKDIR
git pull; docker-compose build django; docker-compose up -d 
