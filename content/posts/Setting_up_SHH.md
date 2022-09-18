+++
title = "Setting_up_shh"
author = ["Italo Amaya Arlotti"]
description = "How to properly set up SSH on a vps"
date = 2022-07-25T00:00:00-05:00
draft = false
+++

## What is SSH {#what-is-ssh}

This is the main protocol for communicating with your server so make sure is properly set up. For me the most important aspect to add is `SSH-keys`. This are like files in your system that are used to authenticate with the server. This is used instead of a password.


## How to configure SSH {#how-to-configure-ssh}


### Config File {#config-file}

The following config are some of my definitive.

This is in `/etc/ssh/sshd_config`

```sh
PermitEmptyPasswords no    # Disable empty passwords
PermitRootLogin no         # Disable login for root
PasswordAuthentication no  # Disable password and only allow SSH-keys
```


### Register ssh-key {#register-ssh-key}

Once you have your key then copy the contents of the `.pub` file. After copying the contents create a file in the (user you want to login into as) on `~/.ssh/authorized_keys`. Then append the copied content to this file.
