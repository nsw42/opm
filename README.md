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

`opm` is written in pure sh, so has no dependencies other than a POSIX shell. The installer requires `curl` or `wget`, but can install `curl` if you do not already have it.

### If you have curl

```
curl https://raw.githubusercontent.com/nsw42/opm/main/install.sh | sh -
```

### If you do not have curl

Use a web browser to save the content from <https://raw.githubusercontent.com/nsw42/opm/main/install.sh>, then run the following commands:

```
cd _the_directory_where_you_saved_the_install_script_
chmod +x ./install.sh
./install.sh -i
```

### Upgrading

The installer checks if there are any files that already exist that would get overwritten by the installer, which means upgrading opm will fail. Therefore, to upgrade an existing version of opm, it is necessary to run:

```
curl https://raw.githubusercontent.com/nsw42/opm/main/install.sh | sh -s -- -f
```

## Usage

```
opm [OPTIONS] subcommand
```

### Listing available commands

`opm help`

`h` is accepted as an alternative to `help` (i.e. `opm h`)

### Listing installed packages

`opm list`

`l` is accepted as an alternative to `list`.

### Installing packages

`opm install PACKAGE...`

One or more packages may be specified as arguments to the `install` command.

`add`, `i` and `inst` are all accepted as alternatives to `install`. (E.g. `opm i curl`).

### Uninstalling packages

`opm uninstall PACKAGE...`

One or more packages may be specified on the command line.

`del`, `remove`, `u`, `un` and `uninst` are all accepted as alternatives to `uninstall`. (E.g. `opm u curl`).
