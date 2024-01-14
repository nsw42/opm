#! /bin/sh
# OPM install script

show_usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -f       Force overwriting existing files"
  echo "  -i       Install curl if not found on path"
  echo "  -p  DIR  Install to DIR. Default /usr/local/bin"
  echo "  -v       Verbose mode"
}

# This list needs to be kept up-to-date
# It's done manually to avoid dependencies on unzip
command_files="opm opm_help opm_install opm_list opm_uninstall"
other_files="opm.aliases"
all_files="$command_files $other_files"

install_curl_if_necessary=false
overwrite_existing_files=false
prefix=/usr/local/bin
verbose=false

while getopts :fhip:v OPT; do
  case $OPT in
    f)
      overwrite_existing_files=true
      ;;
    h)
      show_usage
      exit 0
      ;;
    i)
      install_curl_if_necessary=true
      ;;
    p)
      prefix=$OPTARG
      ;;
    v)
      verbose=true
      ;;
    *)
      echo Error: Unrecognised argument
      show_usage
      exit 1
      ;;
  esac
done

# Pre-flight check #1: is there anything already existing that we wouldn't want to overwrite?

if ! $overwrite_existing_files; then
  existing_files=
  for f in $all_files; do
    f=$(basename $f)
    if [ -f /usr/local/bin/$f ]; then
      existing_files="$existing_files $f"
    fi
  done
  if [ -n "$existing_files" ]; then
    echo "Installation failed"
    echo "The following files are already present in /usr/local/bin: $existing_files"
    echo "Delete them or re-run  $0 -f  to force overwriting existing files."
    exit 1
  fi
fi

# Pre-flight check #2: do we have curl or wget?

have_curl() {
  if [ -x "$(command -v curl)" ]; then
    return 0
  fi
  return 1
}

have_wget() {
  if [ -x "$(command -v wget)" ]; then
    return 0
  fi
  return 1
}

try_apk_install_curl() {
  if [ -x "$(command -v apk)" ]; then
    apk add --no-interactive curl
    return 0
  fi
  return 1
}

try_aptget_install_curl() {
  if [ -x "$(command -v apt-get)" ]; then
    if $verbose; then
      apt-get update
      apt-get install --yes curl
    else
      apt-get update > /dev/null 2> /dev/null
      apt-get install --yes curl > /dev/null 2> /dev/null
    fi
    return $?
  fi
  return 1
}

try_brew_install_curl() {
  if [ -x "$(command -v brew)" ]; then
    brew install curl
    return 0
  fi
  return 1
}

try_install_curl() {
  # Install curl, and return 0 if successful
  # Return 1 on failure.
  # Sigh. What we need is some kind of tool that will install packages for us,
  # without us needing to worry about which package manager is in use.
  if [ $(uname) = Darwin ]; then
    try_brew_install_curl && return 0
  else
    try_apk_install_curl && return 0
    try_aptget_install_curl && return 0
    try_brew_install_curl && return 0
  fi
  return 1
}

if have_curl; then
  downloader=download_with_curl
elif have_wget; then
  downloader=download_with_wget
elif $install_curl_if_necessary; then
  if try_install_curl; then
    downloader=download_with_curl
  else
    echo Installation failed.
    echo Could not install curl
    exit 1
  fi
else
  echo Installation failed.
  echo Neither curl nor wget found. Cannot proceed.
  echo Manually install curl or weget, or re-run with the -i argument
  exit 1
fi

# Create a temporary directory

if [ $(uname) = Darwin ]; then
  tmpdir=$(mktemp -d $TMPDIR/opm_install.XXXX)
else
  tmpdir=$(mktemp -d)
fi

# Downloaders

download_with_curl() {
  local curl_opts
  url=$1
  output_path=$2
  if $verbose; then
    curl_opts=
  else
    curl_opts=-s
  fi

  curl -o "$output_path" $curl_opts "$url"
  return $?
}

download_with_wget() {
  local wget_opts
  url=$1
  output_path=$2
  if $verbose; then
    wget_opts=
  else
    wget_opts=-q
  fi

  wget -O "$output_path" $wget_opts "$url"
  return $?
}

for file in $all_files; do
  URL=https://raw.githubusercontent.com/nsw42/opm/main/src/$file
  if ! $downloader "$URL" "$tmpdir/$file"; then
    echo "Failed to fetch $file (from $URL)"
    exit 1
  fi
done

cd $tmpdir

# Firstly, try installing without root:
do_install_as_current_user() {
  install -m755 $command_files $prefix
  exit_code=$?
  if [ $exit_code -ne 0 ]; then return $exit_code; fi
  install -m644 $other_files $prefix
  return $?
}


try_install_as_current_user() {
  if $verbose; then
    do_install_as_current_user
    return $?
  else
    do_install_as_current_user 2> /dev/null
    return $?
  fi
}

try_install_with_sudo() {
  sudo install -m755 $command_files $prefix
  exit_code=$?
  if [ $exit_code -ne 0 ]; then return $exit_code; fi
  sudo install -m644 $other_files $prefix
  return $?
}

if ! try_install_as_current_user; then
  echo Installation requires root privileges. Invoking sudo: may prompt for password.
  if try_install_with_sudo; then
    echo Installation successful
  else
    echo Installation failed
    exit 1
  fi
fi

# Delete temporary directory
cd
rm -rf $tmpdir
