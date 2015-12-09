;;;; ======================================================================
;;;; File:       generics.lisp
;;;; Author:     Marcus Pearce <marcus.pearce@qmul.ac.uk>
;;;; Created:    <2004-10-28 11:56:59 marcusp>
;;;; Time-stamp: <2014-06-04 16:04:23 marcusp>
;;;; ======================================================================

(cl:in-package #:prediction-sets)

(defgeneric average-codelengths (prediction))
(defgeneric average-codelength (prediction))
(defgeneric codelengths (prediction))
(defgeneric shannon-entropies (prediction))
(defgeneric event-prediction (event-prediction))
(defgeneric event-predictions (prediction))
(defgeneric sequence-probability (sequence-prediction))

(cl:in-package #:multiple-viewpoint-system)

(defgeneric count-viewpoints (mvs))
(defgeneric get-event-array (mvs sequence &key &allow-other-keys))
(defgeneric operate-on-models (mvs operation &key models ltm-args stm-args))
(defgeneric set-model-alphabets (mvs event events viewpoint ltm stm 
                                     unconstrained texture &key interpretation))
(defgeneric get-basic-viewpoint (mvs derived-viewpoint))
(defgeneric sequence-prediction-sets (mvs events event-prediction-sets))
(defgeneric dataset-prediction-sets (mvs sequence-prediction-sets))
(defgeneric set-mvs-parameters (mvs &key ltm-order-bound ltm-mixtures
                                ltm-update-exclusion ltm-escape stm-order-bound
                                stm-mixtures stm-update-exclusion stm-escape))

(defgeneric model-dataset (model dataset texture &key construct? predict? 
                         &allow-other-keys))
(defgeneric model-sequence (model sequence texture &key construct? predict? 
                         &allow-other-keys))
(defgeneric model-event (model event events texture &key construct? predict? 
                         &allow-other-keys))
