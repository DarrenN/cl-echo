(asdf:load-asd #p"~/quicklisp/local-projects/cl-echo/cl-echo.asd")
(ql:quickload "cl-echo")

(setf uiop:*image-entry-point* #'cl-echo:main)

(uiop:dump-image "cl-echo-server" :executable t)
