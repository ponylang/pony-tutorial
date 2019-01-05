---
title: "Hello World: Your First Pony Program"
section: "Getting Started"
menu:
  toc:
    parent: "getting-started"
    weight: 10
toc: true
---
Now that you've successfully installed the Pony compiler, let's start programming! Our first program will be a very traditional one. We're going to print "Hello, world!". First, create a directory called `helloworld`:

```bash
$ mkdir helloworld
$ cd helloworld
```

__Does the name of the directory matter?__ Yes, it does. It's the name of your program! By default when your program is compiled, the resulting executable binary will have the same name as the directory your program lives in. You can also set the name using the --bin-name or -b options on the command line.

## The code

Then, create a file in that directory called `main.pony`.

__Does the name of the file matter?__ Not to the compiler, no. Pony doesn't care about filenames other than that they end in `.pony`. But it might matter to you! By giving files good names, it can be easier to find the code you're looking for later.

In your file, put the following code:

```pony
actor Main
  new create(env: Env) =>
    env.out.print("Hello, world!")
```

## Compiling the program

Now compile it:

```bash
$ ponyc
Building .
Building builtin
Generating
Optimising
Writing ./helloworld.o
Linking ./helloworld
```

(If you're using Docker, you'd write something like `$ docker run -v Some_Absolute_Path/helloworld:/src/main ponylang/ponyc`, depending of course on what the absolute path to your `helloworld` directory is.)

Look at that! It built the current directory, `.`, plus the stuff that is built into Pony, `builtin`, it generated some code, optimised it, created an object file (don't worry if you don't know what that is), and linked it into an executable with whatever libraries were needed. If you're a C/C++ programmer, that will all make sense to you, otherwise, it probably won't, but that's ok, you can ignore it.

__Wait, it linked too?__ Yes. You won't need a build system (like `make`) for Pony. It handles that for you (including handling the order of dependencies when you link to C libraries, but we'll get to that later).

## Running the program

Now we can run the program:

```bash
$ ./helloworld
Hello, world!
```

Congratulations, you've written your first Pony program! Next, we'll explain what some of that code does.
