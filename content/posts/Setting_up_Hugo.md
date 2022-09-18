+++
title = "Setting_up_hugo"
author = ["Italo Amaya Arlotti"]
description = "This is how I set up Hugo"
date = 2022-06-14T00:00:00-05:00
draft = false
+++

## Hugo {#hugo}

Now that I have a server I started to play around with the site generation of hugo. It can be a bit complicated If you are using emacs and org mode like me so I will divide this explanation in to three parts: `Ox-Hugo` (You can skip this if you are using only md), `Content Organization` and `Configurations`.


### Set up hugo {#set-up-hugo}


#### Download hugo {#download-hugo}

You are going to want to install hugo in your personal machine apart from your server. This is going to make testing the site much easier.

```sh
# Macos
brew install hugo
```


#### Create a new site {#create-a-new-site}

You can choose any place to set up this site just run. The name of the site must be the same name as chosen in the `nginx` configuration.

```sh
sudo hugo new site <NAME>
```


### Ox-Hugo {#ox-hugo}

To have a exporting workflow working I recommend to read the [ox-hugo website](https://ox-hugo.scripter.co/). Then understand how the exporting works.


#### Config {#config}

First Set up the `org-hugo-base-dir`

```elisp
(use-package! ox-hugo
  :init
  (setq org-hugo-base-dir (concat org-directory "/Hugo/"))
  )
```


#### Workflow {#workflow}

Now I recommend to think about a structure for your website mine is like this:

```sh
-content|
        | About.md
        | posts
                   | post 1
                   | post 2
        | recipes
                   | recipe 1
```

So in here im showing that I have the main content directory with the About.md in the top level directory. This is because this page does not belong in recipes or posts. Then I have to directories where My blog will go (posts) and some of my recipes.

<!--list-separator-->

-  Setting up the Org file

    To set up the org file I use a little snippet but it can also be written. These are the most important headings:

    ```org
    #+TITLE: <tittle>
    #+DATE: <date>
    #+hugo_section: <section - (posts or recipes)>
    #+hugo_draft: true or false
    ```

    Most are self explanatory but `hugo_section` is an important one as it lets us choose to what directory is the file going to be exported.

<!--list-separator-->

-  Exporting

    Now do a `M-x org-export-dispatch` and select hugo. If ox-hugo is correctly set up then you are going to have content in your content/ directory.


### Content Organization {#content-organization}

So basically hugo content directory is a direct representation of how pages are going to be linked. In the case of a /posts directory if the url goes to posts then a list of all the content inside /posts is shown. I recommend having a about.md page in root of content directory. Plus some directories to store in my case `recipes or blog`.


### Configuration {#configuration}

This is an important aspect the `config.toml`. This config depends also on the theme you are using but most work somewhat similar.

```toml
baseURL = 'https://<domain>/'
languageCode = 'en-us'
title = '<name>'
theme = "hugoCoder"

[markup.goldmark.renderer] # This is important for ox-hugo users
  unsafe = true

disableFastRender = true

[[menu.main]]
  name = "Recipes"
  weight = 4
  url  = "recipes/"

[[menu.main]]
  name = "Home"
  weight = 1
  url = ""
[[menu.main]]
  name = "About Me"
  weight = 2
  url = "about"
[[menu.main]]
  name = "Blog"
  weight = 3
  url = "posts"

[params]
  math = true
  since = 2022
  colorScheme = "dark"
```

This is a basic config file but it was all I needed.


### Building {#building}

This is the last part. First build the site and serve it on your local machine.

```sh
# This builds
hugo
# This serves the site for preview
hugo server
```

Once everything looks good then move the entire Hugo folder to your server through your preferred choice. In my case I use `ssh-deploy` in emacs to do so. Once on your server place the hugo folder in the root directory of your user like this `/home/<user>/<site-name>` the site name is your hugo directory. Then if your `nginx` is running plus pointing to `/<site-name>/public` then your site should work. Congrats!
