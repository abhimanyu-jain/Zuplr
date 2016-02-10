#!/bin/sh
git stash
git pull
git stash pop
sudo service nginx restart
