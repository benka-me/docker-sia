#!/bin/sh

socat tcp-listen:9980,reuseaddr,fork tcp:localhost:8000 &

# Use the `cat` utility in order assign a multi-line string to a variable.
SIAD_CMD=$(cat <<-END
./siad \
  --modules $SIA_MODULES \
  --sia-directory $SIA_DATA_DIR \
  --api-addr localhost:8000
END
)

# We are using `exec` to start `siad` in order to ensure that it will be run as
# PID 1. We need that in order to have `siad` receive OS signals (e.g. SIGTERM)
# on container shutdown, so it can exit gracefully and no data corruption can
# occur.
exec $SIAD_CMD "$@"
