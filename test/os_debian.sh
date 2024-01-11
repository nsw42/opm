#! /bin/sh
#
# Run the test suite in a Debian Linux docker image

# TODO: Multiple OS versions?

$TESTDIR/run_tests_in_docker.sh debian:latest "$@"
