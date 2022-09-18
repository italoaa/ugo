+++
title = "Setting_up_ssl_nginx"
author = ["Italo Amaya Arlotti"]
description = "How to properly set up ssl on a vps for nginx set up"
date = 2022-07-25T00:00:00+01:00
draft = false
+++

## What is ssl? {#what-is-ssl}

This step enables the visitor to come to the website on a secure connection.


### Install certbot {#install-certbot}

```sh
apt install python3-certbot-nginx
```


### Run the cerbot installation {#run-the-cerbot-installation}

It will ask for which domain to enable the https. `Domain is required` Go throug the installation and check for the https in your browser

```sh
certbot --nginx
```


### Automatic certificate renewal {#automatic-certificate-renewal}

```sh
crontab -e
```

and add this to the end

```sh
0 0 1 * * certbot --nginx renew
```
