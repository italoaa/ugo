+++
title = "Adding_cowsay_to_ssh"
author = ["Italo Amaya Arlotti"]
description = "Cowsay is a funny script that allows to add a funny cow saying a punchline when you loggin to ssh"
date = 2022-09-18T00:00:00+01:00
draft = false
+++

## Install Packages {#install-packages}

```sh
sudo apt update && sudo apt upgrade
sudo apt install cowsay fortune
```


## Create the RC {#create-the-rc}

The following Bash commands will be run everytime you log in to ssh. The commands need to be added to `~/.ssh/rc`.

```sh
#!/bin/bash
clear
echo ""
fortune | cowsay -cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n 1)
echo "$(uptime)"
echo ""
```

Source : [original post](https://vorkbaard.nl/cowsay-when-logging-on-via-ssh/)
