;; -*- mode: Lisp; Syntax: COMMON-LISP; Base: 10; eval: (hs-hide-all) -*-

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
  (:export :get-element-by-id
           :with-document-ready))

(in-package #:ps-lib)

(defpsmacro get-element-by-id (element)
  `(chain document (get-element-by-id ,element)))

;; From http://youmightnotneedjquery.com/

(defpsmacro with-document-ready (&rest body)
  (let ((fx (ps:ps-gensym)))
    `(progn
       (defun ,fx ()
         ,@body)
       (if (not (string= (-> document readystate) "loading"))
           (,fx)
           (chain document (add-event-listener "DOMContentLoaded" ,fx))))))
(export 'with-document-ready)

