# 需要什么

开始学习之前，你需要文本编辑器和 [ponyc](https://github.com/ponylang/ponyc) 编译器。如果你使用的是 ponyc 还未支持的平台或者你并不想安装编译器，那你可以使用 [Pony's Playground](https://playground.ponylang.org/)。

## Pony  编译器

在开始之前，请先阅读 Pony 编译器的[安装指南](https://github.com/ponylang/ponyc/blob/master/README.md#installation)。

## 文本编辑器

虽然你可以使用任意的编辑器，但是如果编辑器对于语言有支持，但肯定会更好一些。下面的编辑器都提供了对语言的支持：

* [Sublime Text](http://www.sublimetext.com/)。 There's a [Pony Language](https://packagecontrol.io/packages/Pony%20Language) package.
* [Atom](https://atom.io/). There's a [language-pony](https://atom.io/packages/language-pony) package.
* [Emacs](https://www.gnu.org/software/emacs/emacs.html). There's a [ponylang-mode](https://github.com/seantallen/ponylang-mode).
* [Vim](http://www.vim.org). There's a [ pony-vim-syntax](https://github.com/dleonard0/pony-vim-syntax) plugin. Install `pony` with `vim-plug` or `pathogen`.
* [Microsoft Visual Studio](http://www.visualstudio.com/). There's a [VS-pony](https://github.com/CausalityLtd/VS-pony) plugin.
* [BBEdit](http://www.barebones.com/products/bbedit/)。语言支持包 [bbedit-pony](https://github.com/TheMue/bbedit-pony) 。

如果你喜欢的编辑器没有提供对Pony的支持，我们很乐意为你编写一个。

## 编译器

Pony 是编译型语言，而不是解释型的。事实上，它甚至更进一步：Pony 是一种提前（AOT）编译语言，而不是一种即时编译（JIT）语言。


这意味着，一旦构建了程序，就可以一次又一次地运行它，而不需要编译器、虚拟机或其他任何东西。它就是一个完整的程序。

但同时这也意味着你需要在运行程序之前构建你的程序。在解释语言或JIT编译语言中，您倾向于这样做来运行您的程序:

```bash
$ python helloworld.py
```

或者在程序开头防止一个 __shebang__ 符号，（例如 `#!/usr/bin/env python`），然后用 `chmod` 设置一下文件的可执行:

```bash
$ ./helloworld.py
```

但是使用 Pony，你不需要这样做。

## 编译程序

如果你当前在代码所在目录，可以直接运行：

```bash
$ ponyc
```

这会向 Pony 编译器指明当前的工作目录包含源代码，并开始编译它。如果源代码在其他目录中，也可以向 ponyc 指明：

```bash
$ ponyc path/to/my/code
```

我们在后边的文章中会讲解其他的选项。
