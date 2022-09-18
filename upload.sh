#!/usr/bin/env sh

sudo hugo
sudo git add .
sudo git commit -m "This is an auto-commit"
sudo git push origin main
