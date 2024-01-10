# opm - OS Package Manager abstraction

## Purpose

`opm` provides an abstraction layer over common OS package managers. This is useful when you spend your time moving between different operating systems: rather than having to remember whether to type `apk`, `apt`, `brew`, `dnf`, ..., just type `opm`. It also facilitates a common vocabulary, for instance resolving confusion between `update` and `upgrade`.

It does _not_ install package managers, or configure package managers, or attempt to provide a consistent output format for invoked commands; nor does it attempt to cover all functionality of every possible package manager. If you're doing anything complicated, you will still need to get to know the package manager on your platform. 

## Supported package managers

* Alpine [apk](https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html)
* Debian/Ubuntu [apt](https://en.wikipedia.org/wiki/APT_(software))
* macOS (or Linux) [Homebrew](https://brew.sh) 

... more to come

## Installation

`opm` is written in pure sh, so there are no dependencies other than a basic shell.

TODO...

## Usage

```
opm [OPTIONS] subcommand
```

### Listing available commands

`opm help`

### Listing installed packages

`opm list`

### Installing packages

`opm install PACKAGE...`

One or more packages may be specified as arguments to the `install` command.

### Uninstalling packages

`opm uninstall PACKAGE...`

One or more packages may be specified on the command line.
