(defpackage cl-echo/tests/main
  (:use :cl
        :cl-echo
        :rove))
(in-package :cl-echo/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-echo)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
