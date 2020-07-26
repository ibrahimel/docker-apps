#!/bin/sh

rm -rf did-git-impl/

cp -r ~/workspace/git/patch/did-git-impl ./did-git-impl

docker build --pull -t git-signing . && echo 'Done'

