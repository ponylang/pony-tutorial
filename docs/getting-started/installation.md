# Mac OSX
First, install [homebrew](http://brew.sh/) if you haven't already.

```ponyc``` can be installed with a published homebrew formula from [ponylang.org](http://www.ponylang.org/releases/ponyc.rb):

```bash
$ brew install http://www.ponylang.org/releases/ponyc.rb
$ ponyc --version
0.1.2
```

A [pull request](https://github.com/Homebrew/homebrew/pull/39192) for the ponyc formula to be part of homebrew-core has been submitted and it should be merged soon.

# Linux

Installers for various distributions to supply precompiled binaries are available. All linux installers are signed with the public key published [here](http://ponylang.org/releases/buildbot@lists.ponylang.org.gpg.key).

## Available packages

* ```ponyc```: This package is the recommended one and should work on most modern ```x86_64``` platforms.
* ```ponyc-noavx```: Ponyc for platforms without AVX support (for example virtual machines) 
* ```ponyc-numa```: A numa-aware version of ```ponyc```.

## Apt-get and Aptitude

First, to avoid warnings about an untrusted repository, you can trust ```ponylang.org```:

```bash
$ wget -O - http://www.ponylang.org/releases/buildbot@lists.ponylang.org.gpg.key | sudo apt-key add -
```

**Option 1:** Install ```python-software-properties``` (Debian Wheezy and earlier, Ubuntu) or ```software-properties-common``` (Debian Jessy and later) for ```add-apt-repository```. Then, add the ponylang.org repository:

```bash
$ sudo add-apt-repository http://www.ponylang.org/releases/apt
```

**Option 2**: Manually add the following three lines to your ```sources.list``` (```/etc/apt/sources.list``` on Ubuntu, and ```/etc/apt-get/sources.list``` on Debian):

```bash
deb http://ponylang.org/releases/apt ponyc main
deb http://ponylang.org/releases/apt ponyc-numa main
deb http://ponylang.org/releases/apt ponyc-noavx main
```

If you know and won't be needing ```ponyc-numa``` or ```ponyc-noavx```, you can omit the respective repositories.

Then, update your repository cache:

```bash
$ sudo apt-get update
```

Install ```ponyc```, ```ponyc-noavx``` or ```ponyc-numa```

```bash
$ sudo apt-get install <package name>
```

Running the following command should now display the installed version of ```ponyc```:

```bash
$ ponyc --version
0.1.2
```

## YUM and Zypper

# Windows

64-Bit installers for Windows 7, 8, 8.1 and 10 will be available soon.

# Downloads
All installers can also be downloaded from ponylang.org's servers:

* [Ubuntu/Debian](http://ponylang.org/releases/debian)
* [RPM](http://ponylang.org/releases/yum)
* [Windows](http://ponylang.org/releases/windows)
