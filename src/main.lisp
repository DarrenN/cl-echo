(defpackage cl-echo
  (:use #:cl)
  (:import-from :alexandria
                :remove-from-plist
                :plist-alist)
  (:import-from :serapeum :dict)
  (:import-from :clack)
  (:import-from :log4cl)
  (:import-from :njson)
  (:import-from :uiop)
  (:export #:start-app
           #:stop-app
           #:main
           #:*app*))

(in-package #:cl-echo)

(defvar *http-server* nil
  "The application's HTTP server.")

(defun env->json (env)
  "Encode the env to a JSON string"
  (njson:encode-to-string
   (dict
    :content-length (getf env :content-length)
    :content-type (getf env :content-type)
    :header (getf env :headers)
    :path-info (getf env :path-info)
    :query-string (getf env :query-string)
    :remote-addr (getf env :remote-addr)
    :request-method (getf env :request-method)
    :remote-port (getf env :remote-port)
    :request-uri (getf env :request-uri)
    :script-name (getf env :script-name)
    :server-name (getf env :server-name)
    :server-port (getf env :server-port)
    :server-protocol (getf env :server-protocol)
    :url-scheme (getf env :url-scheme)
    :env (dict
          :app_env (uiop:getenv "APP_ENV")
          :app_port (uiop:getenv "APP_PORT")
          :app_server (uiop:getenv "APP_SERVER")))))

(defvar *app*
  (lambda (env)
    `(200 (:content-type "application/json") (,(env->json env)))))

(defun stop-http-server ()
  (when *http-server*
    (clack:stop *http-server*)
    (log:info "Successfully shut down server")
    (setf *http-server* nil)))

(defun start-http-server (handler &key host port debug server)
  (let ((port (or port 8080)))
    (stop-http-server)
    (setf *http-server*
          (clack:clackup handler :address host :port port :debug debug
                                 :server server))
    (log:info "Successfully initialized server: ~a on port ~a" host port)))

(defun start-app (&key (host "127.0.0.1") (port 5000) (debug t) (server :hunchentoot))
  "Starts the server, sets up logging"
  (if debug
      (log:config :debug)
      (log:config :info))
  (log:debug "log-level set to debug")
  (start-http-server *app*
   :host host :port port :debug debug :server server)
  t)

(defun stop-app ()
  "Shutdown the server (Hunchentoot) and close any DB connections."
  (stop-http-server))

(defun main ()
  (handler-case
      (progn
        (start-app
         :port (ignore-errors
                (parse-integer (uiop:getenv "APP_PORT")))
         :server (read-from-string (ignore-errors (uiop:getenv "APP_SERVER")))
         :debug (equal "production" (ignore-errors (uiop:getenv "APP_ENV"))))
        ;; let the webserver run,
        ;; keep the server thread in the foreground:
        ;; sleep for ± a hundred billion years.
        (sleep most-positive-fixnum))

    ;; Catch a user's C-c
    (#+sbcl sb-sys:interactive-interrupt
      #+ccl  ccl:interrupt-signal-condition
      #+clisp system::simple-interrupt-condition
      #+ecl ext:interactive-interrupt
      #+allegro excl:interrupt-signal
      () (progn
           (format *error-output* "Aborting.~&")
           (stop-http-server)
           (uiop:quit)))
    (error (c) (format t "Woops, an unknown error occured:~&~a~&" c))))

