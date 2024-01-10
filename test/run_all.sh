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

# sep=70*"="
sep="=========="
sep="${sep}${sep}${sep}${sep}${sep}${sep}${sep}"

for f in $TESTDIR/os_*.sh; do
  echo $f
  LOGLEAF=$(basename $f)
  LOGLEAF=$(echo $LOGLEAF | sed 's/.sh$/.log/')
  export LOGFILE=$LOGDIR/$LOGLEAF
  echo > $LOGFILE
  "$f"
  echo "$sep"
  echo
done
