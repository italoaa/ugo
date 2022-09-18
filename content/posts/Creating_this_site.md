+++
title = "Creating this site"
author = ["Italo Amaya Arlotti"]
description = "This is the complete process I went through to create this website incuding links and resources."
date = 2022-06-14T00:00:00+01:00
draft = false
+++

## Disclaimer {#disclaimer}

Most of the information here is taken from the tutorial in `Land Chad` check them out!


## Introduction and process. {#introduction-and-process-dot}

This is the process I went through while making this same website. At first I tried to make a basic `html` and css website but my design skills where not enough. I also considered using `Hugo` because I use `org mode` almost daily and there is a package called [ox-hugo](https://ox-hugo.scripter.co/), which makes transformation of the `org-mode` syntax into the `markdown` for `hugo` simple. On previous attempts I failed at organizing a easy to manage stream for the server. Most was tedious and repetitive function calling. For this attempt I first set up ssh-keys which turned out to be amazing and really convenient. Then I set up `hugo` locally. I found a nice and minimal theme, and then proceded to spend many hours trying to understand hugo. The problem was that I expected hugo to be simple, which it is. But it is like an onion that has many layers that I had to peel of, and with each layer more complexity came by. I understood how `content organization` works and how `ox-hugo` handles this. I had a nice website plus a easy way to make webpages from the comfort of `org-mode`. To end this process I had to connect the server and this local `hugo` site, and to do this I used [ssh-deploy](https://github.com/cjohansson/emacs-ssh-deploy) which was hard to set up but in the end it worked. Now the process is I write the org mode file, export, run ssh-deploy, ssh-deploy automatic script executes in the server which creates the html content.


## Steps {#steps}


### Renting a server {#renting-a-server}

This step involves renting a server from any type of hosting provider. I went with vultur as their plans are cheap and straight forward. But this step can be done on `ANY` hosting provider.


### Getting a domain {#getting-a-domain}

Now that you have a server its time to get a domain name. Again anywhere is fine just get one. Also you may want to skip this step until your server is running like you want it to avoid over paying for a long term project.


### Setting up the server {#setting-up-the-server}

This step is different for everyone. Sometime in the future I will include a link to a blog post on how to do this step by step, but    for now this is the overview of how I set up a new server. `First of all ssh into your server`


#### [Setting_up_ssh]({{< relref "Setting_up_SHH" >}}) {#setting-up-ssh--setting-up-shh-dot-md}


#### Create a new user {#create-a-new-user}

This will create a new user that has root privileges. `This is done in debian`.

> You have to be root to do this

```sh
adduser <username>              # create user
usermod -aG sudo <username>     # Add user to sudo group
getent group sudo               # verify that the user is in sudo group
```


#### [Setting_up_nginx]({{< relref "Setting_up_nginx" >}}) {#setting-up-nginx--dot-setting-up-nginx-dot-md}


#### [SSL for nginx]({{< relref "Setting_up_ssl__nginx" >}}) {#ssl-for-nginx--setting-up-ssl-nginx-dot-md}


### [Hugo Set up]({{< relref "Setting_up_Hugo" >}}) {#hugo-set-up--dot-setting-up-hugo-dot-md}


## Resources {#resources}


### For setting up a server with `nginx` and `https`: {#for-setting-up-a-server-with-nginx-and-https}

-   [Landchad](https://landchad.net/)
-   [nginx](https://www.nginx.com/)


### For org-mode to hugo export: {#for-org-mode-to-hugo-export}

-   [ox-hugo](https://ox-hugo.scripter.co/)


### Hugo: {#hugo}

-   [Hugo](https://gohugo.io/)


### Theme for hugo: {#theme-for-hugo}

-   [Coder Theme](https://themes.gohugo.io/themes/hugo-coder/)
