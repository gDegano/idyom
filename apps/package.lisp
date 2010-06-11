;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-             
;;;; ======================================================================
;;;; File:       package.lisp
;;;; Author:     Marcus Pearce <m.pearce@gold.ac.uk>
;;;; Created:    <2003-04-05 18:54:17 marcusp>                           
;;;; Time-stamp: <2010-04-16 12:29:24 marcusp>                           
;;;; ======================================================================

(cl:in-package #:cl-user)

(defpackage #:apps
  (:use #:cl #:utils #:md #:mvs)
  (:export "*ROOT-DIR*" "POPULATE-DATABASE")
  (:documentation "Miscellaneous variables & utils for applications."))

(defpackage #:resampling 
  (:use #:cl #:utils #:md #:viewpoints #:ppm #:mvs #:prediction-sets)
  (:export "DATASET-PREDICTION" "OUTPUT-INFORMATION-CONTENT" "FORMAT-INFORMATION-CONTENT"
           "INFORMATION-CONTENT-PROFILES" "CACHED-DATASET-PREDICTION" 
           "BUILD-EP-CACHE" "SELECT-VIEWPOINTS-FOR-GENERATION" 
           "GET-RESAMPLING-SETS" "GET-TRAINING-SET" "GET-TEST-SET" 
           "GET-LONG-TERM-MODELS"
           "CONKLIN90" "CONKWIT95" "PEARCE05"
           "TEST-COMBINATIONS")
  (:documentation "Prediction of datasets using cross-validation."))

(defpackage #:viewpoint-selection
  (:use #:cl #:utils)
  (:export "RUN-BEST-FIRST" "RUN-HILL-CLIMBER" 
           "LOAD-VS-CACHE" "STORE-VS-CACHE" "INITIALISE-VS-CACHE")
  (:documentation "Selection of viewpoints."))

;; (defpackage #:expectancy
;;   (:use #:cl #:utils #:md #:viewpoints #:mvs #:prediction-sets #:resampling)
;;   (:export "SELECT-CUDLUN95" "CUDLUN95" "SELECT-SCHELL96" "SCHELL96"
;;            "SELECT-MANZETAL92" "SELECT-MANZETAL92-ENTROPY" "MANZETAL92")
;;   (:documentation "Modelling perceptual data with multiple viewpoint systems."))
  
;; (defpackage #:generation 
;;   (:use #:cl #:utils #:md #:viewpoints #:ppm #:mvs #:prediction-sets 
;;         #:resampling)
;;   (:export "DATASET-GENERATION" "GENERATE-CHORALES")
;;   (:documentation "Generation of melodic compositions."))

;; (defpackage #:grouping 
;;   (:use #:cl)
;;   (:export "DATASET-SEGMENTATION")
;;   (:documentation "Inductive approach to melody segmentation."))



