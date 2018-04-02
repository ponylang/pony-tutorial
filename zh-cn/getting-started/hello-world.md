# Hello World：第一个 Pony 程序

现在您已经成功安装了 Pony 编译器，让我们开始编程吧！我们的第一个项目将是一个非常传统的项目。我们要打印“你好，世界!”。首先，创建一个名为“helloworld”的目录:

```bash
$ mkdir helloworld
$ cd helloworld
```

**目录的名字有特别意义么？** 是的，有。这是程序的名字！默认情况下，当编译时，生成的可执行二进制文件将与代码所在的目录同名。此外您还可以在命令行上使用-bin-name 或-b 选项设置名称。

## 代码

接下来，在目录里创建文件 `main.pony` 。

**文件的名字有特别意义上么？** 不，编译器不关心文件名字。Pony 并不关心文件的名字，唯一要求的是文件的后缀名是 `.pony`。但是文件名字对你应该是有意义的！文件命名时选取一些有意义的名字，有助于以后查找相关代码。

在文件中输入一下代码：

```pony
actor Main
  new create(env: Env) =>
    env.out.print("Hello, world!")
```

## 编译程序

开始编译：

```bash
$ ponyc
Building .
Building builtin
Generating
Optimising
Writing ./helloworld.o
Linking ./helloworld
```

（如果你使用 Docker， 你需要运行诸如 `$ docker run -v Some_Absolute_Path/helloworld:/src/main ponylang/ponyc` 此类命令，当然，具体要取决于你的 `helloworld` 目录的绝对路径。）

看！Pony 编译器构建了当前目录以及内置在 Pony 中的 `builtin` 。此外，它还生成了一些代码，并进行了优化，创建了一个对象文件(如果你不知道什么是对象文件，那也没有关系)，并将它与任何需要的库链接到一个可执行文件中。如果你是一个 C/C++ 程序员，你应该很容易理解，否则你会觉得有些不好理解，但是没关系，你可以忽略这些细节。

**等一下，代码也已经链接过了？** 是的。Pony 不需要额外的构建系统（比如 make ）。Pony 自己会处理这个问题（包括链接到 C 库时处理依赖项的顺序，这些稍后我们会讲到)。

## 运行程序

现在，你可以执行程序了：

```bash
$ ./helloworld
Hello, world!
```

恭喜你，你已经完成了第一个 Pony 程序！接下来，就解释一下代码是如何工作的。
