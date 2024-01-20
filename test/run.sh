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

export ROOTDIR=$(dirname $0)/..
export BINDIR=$ROOTDIR/src
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
  elif echo "$arg" | grep -Eq '^test_'; then
    TESTS+=("$arg")
  else
    echo Unrecognised command-line argument $arg
  fi
done

if [ "${#OSS[@]}" -eq 0 ]; then
  OSS=($(ls "$TESTDIR" | grep ^os_))
fi

if [ "${#TESTS[@]}" -eq 0 ]; then
  TESTS=($(ls "$TESTDIR" | grep ^test_))
fi


# Start the tests running
#
declare -a RESULTS

for os in "${OSS[@]}"; do
  export LOGFILE=$LOGDIR/${os}.log
  echo > $LOGFILE
  RESULT_FILE=$TMPDIR/${os}.results
  echo $os > $RESULT_FILE
  "$TESTDIR/$os" "${TESTS[@]}" >> $RESULT_FILE &
  RESULTS+=($RESULT_FILE)
done

# Wait for the tests to finish and echo the results

wait

# sep=70*"="
sep="=========="
sep="${sep}${sep}${sep}${sep}${sep}${sep}${sep}"
for result in "${RESULTS[@]}"; do
  cat $result
  echo "$sep"
  echo
done
