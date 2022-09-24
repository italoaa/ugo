+++
title = "Learning_open Gl Triangle"
author = ["Italo Amaya Arlotti"]
description = "This is the third section on learn opengl. The main topics touched are the Graphics pipeline, shaders and rendering a triangle on the screeen."
date = 2022-09-22T00:00:00+01:00
draft = false
+++

> Most of this information comes from learn Opengl. I am not claiming this as my explanation of how opengl works but just my own rewrite for learning purposes.


## Introduction to the Graphics Pipeline {#introduction-to-the-graphics-pipeline}

The graphics pipeline has the main responsibility of `transforming your 3D data into 2D pixels on the screen`. OpenGl has everything in 3d space so the idea is that the graphics pipeline transforms that 3d space into the pixels of your screen. This pipeline has steps that all take as input the output of another. These processes that run on the GPU are called `Shaders`.


### Shaders {#shaders}

The shaders are written in OpenGl Shading Language (GLSL). Using this the developer has more control over the pipeline and also saves cpu load.


### Stages of the graphics pipeline {#stages-of-the-graphics-pipeline}

{{< figure src="/ox-hugo/20220922-105922_screenshot.png" >}}


### Vertex Shader Stage {#vertex-shader-stage}

This stage take the vertex data that we have to provide. A `Vertex` is a group of data holding a 3d coordinate. This data is called `vertex attributes` and can be anything. E.g color.

> In order for OpenGL to know what to make of your collection of coordinates and color values OpenGL requires you to hint what kind of render types you want to form with the data. Do we want the data rendered as a collection of points, a collection of triangles or perhaps just one long line? Those hints are called `primitives` and are given to OpenGL while calling any of the drawing commands. Some of these hints are `GL_POINTS, GL_TRIANGLES and GL_LINE_STRIP.`


### Fragment Shader {#fragment-shader}

This is the stage where the final pixel color is calculated. Normally where most of the complex Opengl effects happen. (Shadows, lights, colors of lights, etc.)

There are more but theses two are the most important now as `we need to provide` a shader for both.


## Vertex Input {#vertex-input}

These coordinates are not based on the pixels of your screen. These coordinates are what is called `Normalized Device Coordinates`. Due to being normalized they are in the following range \\([-1,1]\\). Anything outside this range its discarded. The z values are for depth if we say 0 its like it was 2d.

```rust
    let vertices: [f32; 9] = [
        -0.5, -0.5, 0.0, // left
        0.5, -0.5, 0.0, // right
        0.0, 0.5, 0.0, // top
    ];
```

{{< figure src="/ox-hugo/20220922-113042_screenshot.png" caption="<span class=\"figure-number\">Figure 1: </span>The origin is in the middle of the screen and the +Y is pointing upwards" >}}


### Vertex Buffer Objects (VBO) {#vertex-buffer-objects--vbo}

These are the memory we use to send the vertex data as input to the GPU. This memory is then loaded to the GPU giving it massive performance. Now on these memory areas we load data such as vertex data.


### Vertex Array Object (VAO) {#vertex-array-object--vao}

There are `Buffer Objects` and `Buffer Types`. The vertex buffer object has the buffer type of `Vertex Array Object`. We need to bind out VBO to the VAO type target


### Bringing everything together {#bringing-everything-together}

Now lets generate and bind our buffers.

```rust
    let (mut VBO, mut VAO) = (0, 0);
    gl::GenVertexArrays(1, &mut VAO);
    gl::GenBuffers(1, &mut VBO);
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    gl::BindVertexArray(VAO);

    gl::BindBuffer(gl::ARRAY_BUFFER, VBO);
```

After we setup our buffers we use the `BufferData` method to fill this buffer with the vertex information. The first argument is the `buffer type`. The second argument is the `size of the data`. To get this size we get the length of our array which is 9 and we multiply that by the `size_of::<Glfloat>`. This gives us the size of the array, with this size we cast it to a `GLsizeiptr`. Finaly the fourth argument is how to use this data:

1.  `gl::STREAM_DRAW`: the data is set only once and used by the GPU at most a few times.
2.  `gl::STATIC_DRAW`: the data is set only once and used many times.
3.  `gl::DYNAMIC_DRAW`: the data is changed a lot and used many times.

we use static draw

```rust
    gl::BufferData(
        gl::ARRAY_BUFFER,
        (vertices.len() * mem::size_of::<GLfloat>()) as GLsizeiptr,
        &vertices[0] as *const f32 as *const c_void,
        gl::STATIC_DRAW,
    );
```

Now that the data is available its time to talk shaders.


## Doing shaders {#doing-shaders}

So because we are required to provide at least a `vertex sharder` and a fragment shader we are going to do those now. Normally doing shaders requires us having to compile shaders in opengl shader language or (GLSL). But we are going to do them in rust as a string.


### Vertex shader {#vertex-shader}

As you can see we are programming the GLSL code and placing it in a const.

```rust
    const vertexShaderSource: &str = r#"
        #version 330 core
        layout (location = 0) in vec3 aPos;
        void main() {
        gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
        }
    "#;
```

Now that we have our GLSL code we need to create a `shader object`. Which I think the idea is close to how we created a `buffer object` that is represented with an id.

```rust
    // vertex shader
    let vertexShader = gl::CreateShader(gl::VERTEX_SHADER);
    let c_str_vert = CString::new(vertexShaderSource.as_bytes()).unwrap();
    gl::ShaderSource(vertexShader, 1, &c_str_vert.as_ptr(), ptr::null());
    gl::CompileShader(vertexShader);
```

First we use `CreateShader` to make a shader with the `VERTEX_SHADER` constant that let the compiler know that the shader we are trying to compile is a vertex shader. Then we use the struct `CString` which turns rust strings into `c-like` strings that have no null byte in the middle and are null byte terminated. We initialize the shader Source and we compile it. The arguments to `ShaderSource` are first the id of the shader object. Then the second argument is the number of strings that are going to be passed in. Third is the actual shader source and finally the last can be just null.
Now that we have compiled the code we check for errors

```rust
  // check for shader compile errors
        let mut success = gl::FALSE as GLint;
        let mut infoLog = Vec::with_capacity(512);
        infoLog.set_len(512 - 1); // subtract 1 to skip the trailing null character
        gl::GetShaderiv(vertexShader, gl::COMPILE_STATUS, &mut success);
        if success != gl::TRUE as GLint {
            gl::GetShaderInfoLog(vertexShader, 512, ptr::null_mut(), infoLog.as_mut_ptr() as *mut GLchar);
            println!("ERROR::SHADER::VERTEX::COMPILATION_FAILED\n{}", str::from_utf8(&infoLog).unwrap());
        }
```

For checking for compile errors we have to first use `GetShaderiv` to request the compile status. Then do a if `success` does not equal to the `gl::TRUE` then we get the logs with =GetShaderInfoLog passing the id object, the size of our buffer, a null and a pointer to our buffer. Then we just output it to the screen.


### Fragment Shader {#fragment-shader}

For the fragment shader is almost the same process.

```rust
    const fragmentShaderSource: &str = r#"
        #version 330 core
        out vec4 FragColor;
        void main() {
        FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
        }
    "#;
```

```rust
    // fragment shader
    let fragmentShader = gl::CreateShader(gl::FRAGMENT_SHADER);
    let c_str_frag = CString::new(fragmentShaderSource.as_bytes()).unwrap();
    gl::ShaderSource(fragmentShader, 1, &c_str_frag.as_ptr(), ptr::null());
    gl::CompileShader(fragmentShader);
    // check for shader compile errors
    gl::GetShaderiv(fragmentShader, gl::COMPILE_STATUS, &mut success);
    if success != gl::TRUE as GLint {
        gl::GetShaderInfoLog(
            fragmentShader,
            512,
            ptr::null_mut(),
            infoLog.as_mut_ptr() as *mut GLchar,
        );
        println!(
            "ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n{}",
            str::from_utf8(&infoLog).unwrap()
        );
    }
```


## Linking our Shaders {#linking-our-shaders}

Now we need to link all our shaders into a `Shader Program`.

```rust
        // link shaders
        let shaderProgram = gl::CreateProgram();
        gl::AttachShader(shaderProgram, vertexShader);
        gl::AttachShader(shaderProgram, fragmentShader);
        gl::LinkProgram(shaderProgram);
        // check for linking errors
        gl::GetProgramiv(shaderProgram, gl::LINK_STATUS, &mut success);
        if success != gl::TRUE as GLint {
            gl::GetProgramInfoLog(
                shaderProgram,
                512,
                ptr::null_mut(),
                infoLog.as_mut_ptr() as *mut GLchar,
            );
            println!(
                "ERROR::SHADER::PROGRAM::COMPILATION_FAILED\n{}",
                str::from_utf8(&infoLog).unwrap()
            );
        }
        gl::DeleteShader(vertexShader);
        gl::DeleteShader(fragmentShader);
```

In here we are doing much of the same. First we create the shader program and we attach both out shaders. Then we link them and finally we check for errors. In the end the shaders are deleted.


## Render loop {#render-loop}

First we use the shader program we linked before. Then we bind the vertex Array object, and finally we draw the arrays by passing the opengl primitive `TRIANGLES` and then the index to start in and in the end the amount of vertices we want to draw.

```rust
while true {
    ...

    gl::UseProgram(shaderProgram);
    gl::BindVertexArray(VAO); // seeing as we only have a single VAO there's no need to bind it every time, but we'll do so to keep things a bit more organized
    gl::DrawArrays(gl::TRIANGLES, 0, 3);
    // glBindVertexArray(0); // no need to unbind it every time

    ...
}
```

{{< figure src="/ox-hugo/20220924-154241_screenshot.png" >}}
