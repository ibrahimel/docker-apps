#!/bin/sh

#Build Container
docker build --pull -t tor-router . && echo 'Done' 
