;;; early-init.el --- Summary: -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Emacs 27 introduces early-init.el, which is run before init.el,
;; before package and UI initialization happens.
;;
;; -- 2022-05-18:
;; I took a lot of inspiration from centaur Emacs.
;; https://github.com/seagle0128/.emacs.d/
;;

;;; Code:
(setq gc-cons-threshold (* 1024 1024 2 2 2))

(setq frame-inhibit-implied-resize t)

(set-language-environment "UTF-8")

;; Faster to disable here.
(push '(menu-bar-lines . 0)   default-frame-alist)
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

(setq byte-compile-warnings '(cl-functions))

(provide 'early-init)
;;; early-init.el ends here
