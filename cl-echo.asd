(defsystem "cl-echo"
  :version "0.0.1"
  :author "DarrenN"
  :mailto "info@v25media.com"
  :license "MIT"
  :depends-on ("hunchentoot")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Common Lisp Echo Server"
  :in-order-to ((test-op (test-op "cl-echo/tests"))))

(defsystem "cl-echo/tests"
  :author "DarrenN"
  :license "MIT"
  :depends-on ("cl-echo"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cl-echo"
  :perform (test-op (op c) (symbol-call :rove :run c)))
