#!/bin/bash

ros -e '(ql:quickload :cl-echo)'

exec start_server --port $PORT --signal-on-hup=QUIT --kill-old-delay=20 -- \
  .qlot/bin/clackup -s cl-echo src/app.lisp --address 0.0.0.0 --server woo --debug nil
