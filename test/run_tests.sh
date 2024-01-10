#! /bin/sh

if $LOGCOLOUR; then
  PASS="$(printf "\033[1;32m")Pass$(printf "\033[0m")"
  FAIL="$(printf "\033[1;31m")FAIL$(printf "\033[0m")"
else
  PASS=Pass
  FAIL=FAIL
fi


echo $(date) Tests started > $LOGFILE

for t in $TESTDIR/test*; do
  $t && result=$PASS || result=$FAIL
  printf "  %-60s  %s\n"  $t  $result
done

echo $(date) Tests finished >> $LOGFILE
