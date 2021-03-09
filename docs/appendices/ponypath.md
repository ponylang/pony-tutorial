---
title: "PONYPATH"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 5
toc: true
---

When searching for Pony packages, `ponyc` checks both the installation directory (where the standard libraries reside) and any directories listed in the optional environment variable `PONYPATH`.

## Adding to `PONYPATH`

Assuming you just placed new Pony code under a directory called `pony` in your home directory here is how to inform `ponyc` that the directory contains Pony code via adding it to `PONYPATH`.

### Unix/Mac

Edit/add the "rc" file corresponding to your chosen shell (`echo $SHELL` will tell you what shell you are running). For example, if using bash, add the following to your `~/.bashrc`:

```bash
export PONYPATH=$PONYPATH:$HOME/pony
```

(Then run `source ~/.bashrc` to add this variable to a running session. New terminal session will automatically source `~/.bashrc`.)

### Windows

1. Create folder at `C:\Users\<yourusername>\pony`.
2. Right click on "Start" and click on "Control Panel". Select "System and Security", then click on "System".
3. From the menu on the left, select the "Advanced systems settings".
4. Click the "Environment Variables" button at the bottom.
5. Click "New" from the "User variables" section.
6. Type `PONYPATH` into the "Variable name" field.
7. Type `%PONYPATH%;%USERPROFILE%\pony` into the "Variable value" field.
8. Click OK.

You can also add to `PONYPATH` from the command prompt via:

```bash
setx PONYPATH %PONYPATH%;%USERPROFILE%\pony
```
