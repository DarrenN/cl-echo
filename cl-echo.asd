(defsystem "cl-echo"
  :version "0.0.1"
  :author "DarrenN"
  :mailto "info@v25media.com"
  :license "MIT"
  :depends-on (:alexandria
               :bordeaux-threads
               :clack
               :lack
               :log4cl
               :njson/jzon
               :serapeum)
  :components ((:module "src"
                :components
                ((:file "main")
                 (:file "app" :depends-on ("main")))))
  :description "Common Lisp Echo Server"
  :build-operation "program-op" ;; leave as is
  :build-pathname "cl-echo-server"
  :entry-point "cl-echo:main"
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
