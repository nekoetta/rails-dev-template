#!/bin/bash
rm -f tmp/pids/server.pid

exec $@
