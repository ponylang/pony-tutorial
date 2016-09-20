# Mac OSX
First, install [homebrew](http://brew.sh/) if you haven't already.

Make sure to have the newest ```brew``` formulas from ```homebrew:master```:

```bash
$ brew update
```

Then, install ponyc:

```bash
$ brew install ponyc
```
# Linux

Installers for various distributions to supply precompiled binaries are available. All linux installers are signed with the public key published [here](http://releases.ponylang.org/buildbot@lists.ponylang.org.gpg.key).

## Available packages

* ```ponyc```: Recommended. Should work on most modern ```x86_64``` platforms.
* ```ponyc-avx2```: For platforms with AVX2 support.

## Apt-get and Aptitude

First, to avoid warnings about an untrusted repository, you can trust ```ponylang.org```:

```bash
$ wget -O - http://releases.ponylang.org/buildbot@lists.ponylang.org.gpg.key | sudo apt-key add -
```

**Option 1:** Install ```python-software-properties``` (Debian Wheezy and earlier, Ubuntu) or ```software-properties-common``` (Debian Jessy and later) for ```add-apt-repository```. Then, add the ponylang.org repository:

```bash
$ sudo add-apt-repository "deb http://releases.ponylang.org/apt ponyc main"
$ sudo add-apt-repository "deb http://releases.ponylang.org/apt ponyc-avx2 main"
```

**Option 2**: Manually add the following three lines to your ```sources.list``` (```/etc/apt/sources.list``` on Ubuntu, and ```/etc/apt-get/sources.list``` on Debian):

```bash
deb http://releases.ponylang.org/apt ponyc main
deb http://releases.ponylang.org/apt ponyc-avx2 main
```
Then, update your repository cache:

```bash
$ sudo apt-get update
```

Install ```ponyc``` or ```ponyc-avx2```

```bash
$ sudo apt-get install <package name>
```

## Zypper

First, add the ponylang.org repository:

```bash
$ sudo zypper ar -f http://releases.ponylang.org/yum/ponyc.repo
```

Install ```ponyc``` or ```ponyc-avx2```:

```bash
$ sudo zypper install <package-name>
```

## YUM

First, add the ponylang.org repository:

```bash
$ sudo yum-config-manager --add-repo=http://releases.ponylang.org/yum/ponyc.repo
```

**Alternatively**, if ```yum-config-manager``` is not available on your system, you can add the repository manually:

```bash
$  sudo wget -O /etc/yum.repos.d/ponyc.repo http://releases.ponylang.org/yum/ponyc.repo
```

Install ```ponyc``` or ```ponyc-avx2```:

```bash
$ sudo yum install <package-name>
```

## Gentoo

```bash
layman -a stefantalpalaru
emerge dev-lang/pony
```

# Windows

For 64-Bit Windows, the `master` and `release` branches are packaged and availabe Windows only on Bintray ([pony-language/ponyc-win](https://bintray.com/pony-language/ponyc-win)):

```powershell
Invoke-WebRequest -Uri https://dl.bintray.com/pony-language/ponyc-win/ponyc-VERSION.zip -UseBasicParsing -OutFile ponyc-VERSION.zip
7z x .\ponyc-VERSION.zip
.\ponyc-VERSION\ponyc\bin\ponyc.exe --version
```

You will also need [LLVM for Windows](http://releases.ponylang.org/llvm/).

Windows 10 users will need to install the Windows 10 SDK in order to build programs with ponyc. It can be downloaded [from Microsoft](https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk).

## Did it work?

Running the following command should now display the installed version of ```ponyc```:

```bash
$ ponyc --version
0.1.7
```

# Downloads
All installers can also be downloaded from ponylang.org's servers:

* [Ubuntu/Debian](http://releases.ponylang.org/apt/)
* [RPM](http://releases.ponylang.org/yum/)
* [LLVM for Windows](http://releases.ponylang.org/llvm/)
