+++
title = "Learning OpenGl"
author = ["Italo Amaya Arlotti"]
description = "OpenGl is a graphics library that is used to render graphics. This is my journey of learning OpenGl."
date = 2022-09-20T00:00:00+01:00
draft = false
+++

## What resources I am using {#what-resources-i-am-using}

At the moment I am starting with [Learn_OpenGl_rust](https://github.com/bwasty/learn-opengl-rs) and am planing on using this resource for this entire learning process.


## Introduction {#introduction}

As I understand the opengl library started out with the `immediate mode`. This mode was easy to use and made the idea of drawing graphics way easier. But it was `inefficient`, which resulted in opengl developing the `core-profile mode` which is what is being used now.

This made opengl a hard subject to learn as the modern mode used is the core-profile which requires the developer to actually understand how opengl works.


### OpenGl state/context {#opengl-state-context}

The state or context is a collection of variables that define how opengl should operate.


#### Objects {#objects}

Objects are like `structs` that we define. We then bind this object to a `context` and add some options.

```c
// create object
unsigned int objectId = 0;
glGenObject(1, &objectId);
// bind/assign object to context
glBindObject(GL_WINDOW_TARGET, objectId);
// set options of object currently bound to GL_WINDOW_TARGET
glSetObjectOption(GL_WINDOW_TARGET, GL_OPTION_WINDOW_WIDTH,  800);
glSetObjectOption(GL_WINDOW_TARGET, GL_OPTION_WINDOW_HEIGHT, 600);
// set context target back to default
glBindObject(GL_WINDOW_TARGET, 0);
```

This is only a representation of how it works and not actual code. Plus its c code not `rust`.
