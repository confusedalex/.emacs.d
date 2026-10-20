;;; -*- lexical-binding: t; -*-

(setq gc-cons-threshold 10000000) ;; 10MB
(setq read-process-output-max (* 1024 1024 4))
(setq native-comp-jit-compilation t)
;; libgccjit maps Darwin 27 to macOS "18.0", which clang rejects.
(when (eq system-type 'darwin)
  (setq native-comp-driver-options '("-mmacosx-version-min=27.0")))

;; Always assume left-to-right
(setq-default bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)
