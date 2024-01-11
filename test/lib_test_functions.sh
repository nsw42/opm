# lib_test_functions.sh
# Incorporate into test scripts with  . $TESTDIR/lib_test_functions.sh

check_exit_code() {
  ACTUAL=$1
  EXPECTED=$2
  if [ "$EXPECTED" -ne "$ACTUAL" ]; then
    echo Expected exit code $EXPECTED, got $ACTUAL >> $LOGFILE
    exit 1
  fi
  return 0
}


check_file_is_empty() {
  FILENAME=$1  # the file that should be empty
  TEXT_SOURCE=$2  # a human-readable description of where the file content came from (e.g. "stdout" or "stderr")
  if [ -n "$(cat $FILENAME)" ]; then
    echo "Got unexpected output on $TEXT_SOURCE" >> $LOGFILE
    copy_file_to_log "$FILENAME" "$TEXT_SOURCE"
    exit 1
  fi
}


check_file_is_not_empty() {
  FILENAME=$1  # the file that should contain something
  TEXT_SOURCE=$2  # a human-readable description of where the file content came from (e.g. "stdout" or "stderr")
  if [ -z "$(cat $FILENAME)" ]; then
    echo "Expected output on $TEXT_SOURCE but got nothing" >> $LOGFILE
    exit 1
  fi
}


copy_file_to_log() {
  FILENAME=$1  # the file to copy
  TEXT_SOURCE=$2  # a human-readable description of where the file content came from (e.g. "stdout" or "stderr")
  echo "--- begin $TEXT_SOURCE ---" >> $LOGFILE
  cat "$FILENAME" >> $LOGFILE
  echo "--- end $TEXT_SOURCE ---" >> $LOGFILE
}
