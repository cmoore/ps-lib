;; -*- mode: Lisp; Syntax: COMMON-LISP; Base: 10; -*-

;; Copyright (c) 2017 Clint Moore

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.


(defpackage #:ps-lib
  (:use #:cl
        #:parenscript)
  (:export :select :with-document-ready
           :ajax :ajax-post :-> :sel))

(in-package #:ps-lib)

(defpsmacro select (selector)
  `($ ,selector))

(defpsmacro sel (selector)
  `($ ,selector))

;; From http://youmightnotneedjquery.com/

(defmacro+ps -> (&rest body)
  `(chain ,@body))

(defpsmacro with-document-ready (&rest body)
  `(-> ($ document) (ready ,@body)))

(defpsmacro ajax (&key url on-success on-error)
  (let ((request (ps:ps-gensym)))
    `(progn
       (defvar ,request (new (-x-m-l-http-request)))
       (-> ,request (open "GET" ,url 't))
       (setf (@ ,request onreadystatechange) (lambda ()
                                               (if (eql (@ this ready-state) 4)
                                                   (if (and (<= 200 (@ this status))
                                                            (> 400 (@ this status)))
                                                       (,on-success (@ this response-text))
                                                       (,on-error this)))))
       (-> ,request (send))
       (setf ,request null))))

(defpsmacro ajax-post (url data)
  (let ((request (ps:ps-gensym)))
    `(progn
       (defvar ,request (new (-x-m-l-http-request)))
       (-> ,request (open 'POST' ,url 't))
       (-> ,request (set-request-header "Content-Type" "application/x-www-form-urlencoded; charset=UTF-8"))
       (-> ,request (send ,data)))))
