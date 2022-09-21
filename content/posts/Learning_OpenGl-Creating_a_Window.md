+++
title = "Learning OpenGl - Creating a Window"
author = ["Italo Amaya Arlotti"]
description = "Second Post on opengl now that the introduction is done I will try to create a window"
date = 2022-09-21T00:00:00+01:00
draft = false
+++

## GLFW {#glfw}

This is a library that allows us to facilitate the process of creating a window defining the context to of opengl and handle the user input.


## Gl instead of GLAD {#gl-instead-of-glad}

This is a library that's has the purpose of being the opengl function pointer loader.


## Initialize glfw {#initialize-glfw}

This is how we are initializing glfw to create the opengl context.

```rust
    // glfw: initialize and configure
    // ------------------------------
    let mut glfw = glfw::init(glfw::FAIL_ON_ERRORS).unwrap();
    glfw.window_hint(glfw::WindowHint::ContextVersion(3, 3));
    glfw.window_hint(glfw::WindowHint::OpenGlProfile(
        glfw::OpenGlProfileHint::Core,
    ));
    #[cfg(target_os = "macos")]
    glfw.window_hint(glfw::WindowHint::OpenGlForwardCompat(true));
```

> This is all from the learn opengl rust repo


## Creating the window {#creating-the-window}

We create the window with the `create_window` function from glfw. This function returns a window object and a events variable. These are both used promtly.

```rust
    // glfw window creation
    // --------------------
    let (mut window, events) = glfw
        .create_window(
            SCR_WIDTH,
            SCR_HEIGHT,
            "LearnOpenGL",
            glfw::WindowMode::Windowed,
        )
        .expect("Failed to create GLFW window");

    window.make_current();
    window.set_key_polling(true);
    window.set_framebuffer_size_polling(true);

```


## Loading the OpenGl function pointers {#loading-the-opengl-function-pointers}

In this snippet we are using the closure inside the `load_with` method from `gl`. To this closure we are using the `window object` that was returned from `glfw.create_window` and we are getting the process address of the symbol/function. This setup is so that later on we can call things like `gl::Viewport(etc)` and gl knows from where to get the function addresses.

```rust
    // gl: load all OpenGL function pointers
    // ---------------------------------------
    gl::load_with(|symbol| window.get_proc_address(symbol) as *const _);
```


## Render loop {#render-loop}

This is the main loop of the application. This is constantly run until the `window.should_close()` returns `true`. In this loop we are processing the events with our custom function that uses the event variable returned when creating the window. Then `glfw.poll_events` is used to check weather any keyboard presses where executed. The `window.swap_buffers` is used to swap the color buffer (which is the buffer that holds the color values of each pixel in the screen).

```rust
    // render loop
    // -----------
    while !window.should_close() {
        // events
        // -----
        process_events(&mut window, &events);

        // glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
        // -------------------------------------------------------------------------------
        window.swap_buffers();
        glfw.poll_events();
    }
```


## Custom process events functions {#custom-process-events-functions}

Here `flush_messages` returns a que of messages and events that can be processed. On the match event we are trying to match on a `window rezise` which means that we need to adjust our OpenGl window to render on that window size. We are also matching in the `Escape key` to exit the application by setting the `window.set_should_close` to `true`.

```rust
// NOTE: not the same version as in common.rs!
fn process_events(window: &mut glfw::Window, events: &Receiver<(f64, glfw::WindowEvent)>) {
    for (_, event) in glfw::flush_messages(events) {
        match event {
            glfw::WindowEvent::FramebufferSize(width, height) => {
                // make sure the viewport matches the new window dimensions; note that width and
                // height will be significantly larger than specified on retina displays.
                unsafe { gl::Viewport(0, 0, width, height) }
            }
            glfw::WindowEvent::Key(Key::Escape, _, Action::Press, _) => {
                window.set_should_close(true)
            }
            _ => {}
        }
    }
}
```

{{< figure src="/ox-hugo/20220921-203349_screenshot.png" >}}
