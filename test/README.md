# opm/test

## Filename conventions

The files in this directory are:

* `run_all.sh`: Runs all the tests on all of the operating systems (that it is able to, given the current host platform). This is probably the script you want to run.
* `run_one.sh`: Runs all the tests on a single operating system. Invoke as `run_one.sh os_foo.sh`, where `os_foo.sh` is the OS-specific test launcher you want to run.
* `os_*.sh`: The OS-specific test launchers. Many of these rely on docker.
* `run_tests_in_docker.sh`: A support script, used by many of the `os_*.sh`.
* `run_tests.sh`: Run the tests on the current platform (launched, within a Docker image, by `run_tests_in_docker.sh`)
* `test*`: Test scripts, normally launched via `run_tests.sh` rather than run individually
* `lib*`: Support scripts for the test scripts

Additionally, files are created in `./tmp` (because not every Docker image provides `/tmp`), and log files are written to `./log/OS.log`

# Env vars and test script arguments

The following environment variables are used throughout the test suite.

* `$BINDIR` - the directory where the opm scripts can be found (e.g. `$BINDIR/opm` should exist)
* `$TESTDIR` - the directory where the test scripts can be found (e.g. `$TESTDIR/run_all.sh` should exist)
* `$LOGDIR` - the directory where log files should be written
* `$TMPDIR` - the directory where temporary files can be written
* `$LOGFILE` - the filename (incl path) for the log file for the current test. (A single log file is used for all tests running on a single OS)
* `$LOGCOLOUR` - whether to echo log results in colour. Set to `true` or `false`. Note UK spelling.

All are initialised by `run_all.sh` so that they are available for
tests running on the host, and overridden by `run_tests_in_docker.sh` for tests
running in Docker containers.
