#!/usr/bin/env bash
# Disable the Datadog Agent on run/scheduler/release dynos
if [ "$DYNOTYPE" = "run" ] || [ "$DYNOTYPE" = "scheduler" ] || [ "$DYNOTYPE" = "release" ]; then
  DISABLE_DATADOG_AGENT="true"
fi
