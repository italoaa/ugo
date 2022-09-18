+++
title = "Setting_up_nginx"
author = ["Italo Amaya Arlotti"]
description = "How to set up nginx on a vps for hugo"
date = 2022-07-25T00:00:00+01:00
draft = false
+++

## Nginx {#nginx}


### Install {#install}

This is the web server that will handle all http/s connections.

```sh
sudo apt install nginx
```


### Configuration {#configuration}

Decide on a name for the nginx configuration and create a new config for nginx. In case you are not familiar with nginx the configurations of the web server go inside `/etc/nginx/sites-available/`. The sites available directory is used to store the configurations. To enable the configurations you can symlink then to the `/etc/nginx/sites-enabled/` directory. Just replace the `<>` with your stuff. Remember the site-name as it will be usefull for the hugo setup

```sh
server {
        listen 80 ;
        listen [::]:80 ;
        server_name <domain> ;
        root <path to website eg. /var/www/mysite>
        index index.html index.htm index.nginx-debian.html ;
        location / {
                try_files $uri $uri/ =404 ;
        }
}
```

This config is taken from [Land Chad](https://landchad.net/nginx.html).


#### For Hugo {#for-hugo}

To use this template for hugo you are just required to pull your website to a directory and add it to the `root` key. In my case it is `/home/<username>/<Hugo-Directory>/public`.

```sh
server {
        listen 80 ;
        listen [::]:80 ;
        server_name <domain> ;
        root /home/<username>/<site-name>/public;
        index index.html index.htm index.nginx-debian.html ;
        location / {
                try_files $uri $uri/ =404 ;
        }
}
```


### Enable and Reload {#enable-and-reload}

```sh
ln -s /etc/nginx/sites-available/mywebsite /etc/nginx/sites-enabled
systemctl reload nginx
```
