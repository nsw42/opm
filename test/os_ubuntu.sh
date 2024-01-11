#! /bin/sh
#
# Run the test suite in a Ubuntu Linux docker image

# TODO: Multiple OS versions?

$TESTDIR/run_tests_in_docker.sh ubuntu:latest "$@"
