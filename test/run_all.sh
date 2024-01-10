#! /bin/sh

export BINDIR=$(dirname $0)/../src
export TESTDIR=$(dirname $0)
export LOGDIR=$TESTDIR/log
export TMPDIR=$TESTDIR/tmp

mkdir -p $LOGDIR
mkdir -p $TMPDIR

for f in $TESTDIR/os_*.sh; do
  echo $f
  export LOGFILE=$LOGDIR/$(basename ${f/.sh/.log})
  "$f"
  echo ====================================================
  echo
done
