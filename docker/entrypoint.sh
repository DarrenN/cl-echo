#!/bin/bash

exec start_server --port 5001 --signal-on-hup=QUIT --kill-old-delay=20 -- \
  .qlot/bin/clackup app.lisp --address 0.0.0.0 --server woo --debug nil
