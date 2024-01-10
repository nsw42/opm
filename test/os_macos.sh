#! /bin/sh
#
# Run the test suite on a macOS host

if [ "$(uname)" = Darwin ]; then
  # macOS host
  ./run_tests.sh
else
  echo "  Not running on a macOS host. Skipping."
fi
