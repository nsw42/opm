#! /bin/sh

# Default value for whether to use colour depends on whether stdout is a tty;
# can be overridden with command-line arguments
if [ -t 1 ]; then
  export LOGCOLOUR=true
else
  export LOGCOLOUR=false
fi

case $1 in
  -c | -C | --no-color | --no-colour)
    export LOGCOLOUR=false
    shift
    ;;
esac

export BINDIR=$(dirname $0)/../src
export TESTDIR=$(dirname $0)
export LOGDIR=$TESTDIR/log
export TMPDIR=$TESTDIR/tmp

mkdir -p $LOGDIR
mkdir -p $TMPDIR

declare -a OSS TESTS

for arg in "$@"; do
  arg=$(echo "$arg" | sed 's/^.*\///')  # strip out any directory
  if echo "$arg" | grep -Eq '^os_'; then
    OSS+=("$arg")
  elif echo "$arg" | grep -Eq '^test'; then
    TESTS+=("$arg")
  else
    echo Unrecognised command-line argument $arg
  fi
done

if [ "${#OSS[@]}" -eq 0 ]; then
  OSS=($(ls "$TESTDIR" | grep ^os_))
fi

if [ "${#TESTS[@]}" -eq 0 ]; then
  TESTS=($(ls "$TESTDIR" | grep ^test))
fi

# sep=70*"="
sep="=========="
sep="${sep}${sep}${sep}${sep}${sep}${sep}${sep}"

for os in "${OSS[@]}"; do
  echo $os
  LOGLEAF=$(echo $os | sed 's/.sh$/.log/')
  export LOGFILE=$LOGDIR/$LOGLEAF
  echo > $LOGFILE
  "$TESTDIR/$os" "${TESTS[@]}"
  echo "$sep"
  echo
done
