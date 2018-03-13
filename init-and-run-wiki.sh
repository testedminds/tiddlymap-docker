#!/bin/sh
set -e

tiddlywiki_script=$(readlink -f $(which tiddlywiki))

if [ -n "$NODE_MEM" ]; then
    # Based on rule of thumb from:
    # http://fiznool.com/blog/2016/10/01/running-a-node-dot-js-app-in-a-low-memory-environment/
    mem_node_old_space=$((($NODE_MEM*4)/5))
    NODEJS_V8_ARGS="--max_old_space_size=$mem_node_old_space $NODEJS_V8_ARGS"
fi

if [ ! -f /var/lib/tiddlywiki/wiki/tiddlywiki.info ]; then
  # Handle the case where a volume is mounted without an initialized wiki.
  # Note that plugins will NOT be configured by default.
  echo "Initializing new wiki in server mode..."
  /usr/bin/env node $NODEJS_V8_ARGS $tiddlywiki_script wiki --init server
fi

exec /usr/bin/env node $NODEJS_V8_ARGS $tiddlywiki_script wiki --server 8080 $:/core/save/all text/plain text/html "" "" 0.0.0.0
