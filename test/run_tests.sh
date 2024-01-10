#! /bin/sh

echo $(date) Tests started > $LOGFILE

for t in $TESTDIR/test*; do
  $t $BINDIR $LOGFILE && result=Pass || result=FAIL
  printf "  %-30s  %s\n"  $t  $result
done

echo $(date) Tests finished >> $LOGFILE
