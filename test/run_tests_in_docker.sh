#! /bin/sh

IMAGE=$1

docker pull "$IMAGE" > $LOGFILE 2>&1

cd $TESTDIR/.. 
docker run \
  -v ./src:/opm \
  -v ./test:/test \
  -w /test \
  -e BINDIR=/opm \
  -e TESTDIR=/test \
  -e LOGDIR=/test/log \
  -e TMPDIR=/test/tmp \
  -e LOGFILE=/test/log/$(basename $LOGFILE) \
  -e LOGCOLOUR=${LOGCOLOUR:-$DEFAULT_LOGCOLOUR} \
  --entrypoint /test/run_tests.sh \
  "$IMAGE"
