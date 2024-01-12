# opm/test

## Filename conventions

The files in this directory are:

* `run.sh`: The main test launcher. Invoke with `os_FOO` arguments to run the tests only on the named operating systems, and `test_FOO` arguments to run only the named tests. If no OSs are specified, all are used (subject to compatibility with the current host); if no tests are specified, all are executed.
* `os_*`: The OS-specific test launchers. Many of these rely on docker.
* `run_tests_in_docker`: A support script, used by many of the `os_*`.
* `run_tests`: Run the tests on the current platform (launched, within a Docker image, by `run_tests_in_docker`)
* `test_*`: Test scripts, normally launched via `run.sh` rather than run individually
* `lib*`: Support scripts for the test scripts

Additionally, files are created in `./tmp` (because not every Docker image provides `/tmp`), and log files are written to `./log/OS.log`

# Env vars and test script arguments

The following environment variables are used throughout the test suite.

* `$BINDIR` - the directory where the opm scripts can be found (e.g. `$BINDIR/opm` should exist)
* `$TESTDIR` - the directory where the test scripts can be found (e.g. `$TESTDIR/run.sh` should exist)
* `$LOGDIR` - the directory where log files should be written
* `$TMPDIR` - the directory where temporary files can be written
* `$LOGFILE` - the filename (incl path) for the log file for the current test. (A single log file is used for all tests running on a single OS)
* `$LOGCOLOUR` - whether to echo log results in colour. Set to `true` or `false`. Note UK spelling.

All are initialised by `run.sh` so that they are available for
tests running on the host, and overridden by `run_tests_in_docker` for tests
running in Docker containers.
