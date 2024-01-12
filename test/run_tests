#! /bin/sh

if $LOGCOLOUR; then
  PASS="$(printf "\033[1;32m")Pass$(printf "\033[0m")"
  FAIL="$(printf "\033[1;31m")FAIL$(printf "\033[0m")"
else
  PASS=Pass
  FAIL=FAIL
fi

LOGDATEFMT="+%Y-%m-%d %H:%M:%S"

echo $(date "$LOGDATEFMT") Tests started >> $LOGFILE

for t in "$@"; do
  echo "$(date "$LOGDATEFMT") Running $t"  >> $LOGFILE
  $TESTDIR/$t && result=$PASS || result=$FAIL
  printf "  %-60s  %s\n"  $t  $result
  echo >> $LOGFILE
  echo >> $LOGFILE
done

echo $(date "$LOGDATEFMT") Tests finished >> $LOGFILE
