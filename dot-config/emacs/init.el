;;; init.el --- summary -*- lexical-binding: t -*-

;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(with-eval-after-load 'package
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)


;;; ----------------------------------------------------------------------------
;;; BETTER DEFAULTS

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Remember the previously used mini-buffer commands between Emacs session.
(savehist-mode 1)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell t
      load-prefer-newer t
      backup-by-copying t
      frame-inhibit-implied-resize t
      use-short-answers t
      ediff-window-setup-function 'ediff-setup-windows-plain)

(setq ring-bell-function (lambda ()))

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      custom-file (concat user-emacs-directory "custom.el"))

;; macOS specifics.
(if (eq system-type 'darwin)
    (progn
      (setq mac-right-command-modifier 'none)
      (setq mac-right-option-modifier  'none)))

;; Stop the cursor from blinking.
(blink-cursor-mode -1)

;; Make the title bar transparent & dark.
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq-default indent-tabs-mode nil)
(add-hook 'prog-mode-hook (lambda ()
                            (hl-line-mode)
                            (display-fill-column-indicator-mode)
                            (hs-minor-mode)
                            (setq-local show-trailing-whitespace t)))

;; Scrolling.
(setq scroll-step 1
      scroll-margin 0
      scroll-conservatively 100000
      auto-window-vscroll nil
      scroll-preserve-screen-position t)
(pixel-scroll-precision-mode)

;; It bears repeating.
(repeat-mode 1)

(setq-default display-line-numbers-width 4
              fill-column 80)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(column-number-mode)

;; Increase all the fonts by an increment.
(require 'face-remap)
(keymap-global-set "s--" 'global-text-scale-adjust)
(keymap-global-set "s-+" 'global-text-scale-adjust)

;; Tabs.
(setq tab-bar-close-button-show nil)
(setq tab-bar-new-button-show nil)

;; Hide the tab bar when only one tab. Looks better especially when editing a
;; file with `emacsclient'.
(setq tab-bar-show 1)
(tab-bar-mode +1)

(setq auth-sources '("~/.authinfo"))

(setq dired-kill-when-opening-new-dired-buffer t)

;; Make sure that we get the shell variables as well.
(use-package exec-path-from-shell
  :ensure t
  :init
  (setq exec-path-from-shell-arguments nil)
  (exec-path-from-shell-initialize))

(use-package crux
  :ensure t
  :bind (:map dired-mode-map
              ("C-c o" . crux-open-with)))


;;; ----------------------------------------------------------------------------
;;; UI TWEAKS

;; FONTS
(set-face-attribute 'default nil
                    ;; :family "Roboto Mono"
                    ;; :family "JetBrains Mono"
                    ;; :family "CommitMono"
                    ;; :family "Monaspace Argon"
                    ;; :family "Fira Mono"
                    ;; :family "Iosevka Comfy"
                    ;; :family "Oxygen Mono"
                    :family "Iosevka"
                    :weight 'regular
                    :height 160)

(when (eq system-type 'gnu/linux)
  (set-fontset-font
   t 'symbol
   (font-spec
    :family "Noto Color Emoji"
    :weight 'normal
    :width 'normal)))

;; THEMES
;; Treat all themes as safe.
(setq custom-safe-themes t)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-visual-bell-config t))

(use-package ef-themes
  :ensure t)

(setq light-highlight-color "#d8dee9")
(setq dark-highlight-color "#4c566a")
(setq my/dark-theme 'doom-one)
(setq my/light-theme 'ef-light)

(defun my/switch-to-light-theme ()
  "Disable the `my/dark-theme' theme and load `my/light-theme'"
  (interactive)
  (disable-theme my/dark-theme)
  (load-theme my/light-theme)
  (custom-theme-set-faces
   my/light-theme
   `(eglot-highlight-symbol-face ((t :background ,light-highlight-color)))
   `(fill-column-indicator ((t (:background ,light-highlight-color
                                :foreground ,light-highlight-color
                                :height 0.1
                                :inherit 'nil)))))
  (enable-theme my/light-theme))

(defun my/switch-to-dark-theme ()
  "Disable the `my/light-theme' theme and load `my/dark-theme'"
  (interactive)
  (disable-theme my/light-theme)
  (load-theme my/dark-theme)
  (custom-theme-set-faces
   my/dark-theme
   `(eglot-highlight-symbol-face ((t :background ,dark-highlight-color)))
   `(fill-column-indicator ((t (:background ,dark-highlight-color
                                :foreground ,dark-highlight-color
                                :height 0.1
                                :inherit 'nil))))
   '(default ((t :foreground "#D4D4D4")))
   '(font-lock-doc-face ((t :foreground "#6A9955")))
   '(font-lock-comment-face ((t :foreground "#6A9955")))
   '(font-lock-string-face ((t :foreground "#ce9178")))
   '(tree-sitter-hl-face:string.special ((t :foreground "#d16969"))))
  (enable-theme my/dark-theme))

(my/switch-to-dark-theme)

;; ICONS
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

;; MODELINE
;; `minions' disables the modeline minor modes.
(use-package minions
  :ensure t
  :hook (after-init . minions-mode)
  :config
  (setq minions-prominent-modes '(flymake-mode)))

;; `moody' is a small, fast and good looking modeline.
(use-package moody
  :ensure t
  :config
  (setq moody-mode-line-height 32)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-mode-line-front-space)
  (moody-replace-vc-mode))


;;; ----------------------------------------------------------------------------
;;; WINDOW MANAGEMENT

(defun my/focus-window (window)
  "Focus the provided WINDOW."
  (select-window window))

(setq display-buffer-alist
      `(;; flymake list project diagnostics
        ((or . ((derived-mode . flymake-project-diagnostics-mode)
                (derived-mode . flycheck-error-list-mode)))
         (display-buffer-in-side-window)
         (dedicated     . t)
         (side          . bottom)
         (window-height . 0.2)
         (window-parameters . ((mode-line-format . none)))
         (body-function . my/focus-window))

        ((or . ("\\*eldoc\\*"
                "\\*persistent-doc-at-point*"))
         (display-buffer-reuse-mode-window display-buffer-at-bottom)
         (dedicated     . t)
         (side          . bottom)
         (window-height . 0.3)
         (body-function . my/focus-window))

        ((derived-mode . help-mode)
         (display-buffer-reuse-mode-window display-buffer-at-bottom)
         (dedicated     . t)
         (side          . bottom)
         (window-height . 0.3))))


;;; ----------------------------------------------------------------------------
;;; TERMINALS
(use-package vterm
  :ensure t
  :defer t
  :init
  (defun new-vterm ()
    (interactive)
    (let ((current-prefix-arg '-))
      (call-interactively 'vterm)))

  (general-def normal
    "SPC v" 'new-vterm)
  (general-def
    "C-c v" 'new-vterm)

  :config
  (setq vterm-timer-delay 0.01)
  (add-hook 'vterm-mode-hook (lambda ()
                               (auto-fill-mode -1))))


;;; ----------------------------------------------------------------------------
;;; KEYBINDINGS & EVIL (MODAL EDITING)

;;
;; A `general' is a good leader…!
;;
(use-package general
  :ensure t)

(keymap-global-set "M-«" "M-<")
(keymap-global-set "M-»" "M->")

(keymap-global-set "M-(" "M-{")
(keymap-global-set "M-)" "M-}")

(keymap-global-set "C-c b k" 'kill-this-buffer)
(keymap-global-set "C-c b g" 'revert-buffer-quick)
(keymap-global-set "C-x C-b" 'ibuffer)

(keymap-global-set "C-=" 'indent-region)

;; Because my dotfiles are under version control, if I want not to type "yes"
;; every time I open my `init.el'.
(setq vc-follow-symlinks t)

(defun my/open-emacs-init ()
  "Open .emacs/init.el configuration file."
  (interactive)
  (find-file (f-join user-emacs-directory "init.el")))

(general-def
  "C-<next>"  'tab-next
  "C-<prior>" 'tab-previous
  "C-x t RET" 'tab-new-to
  "C-x t t"   'tab-switch
  "C-x t d"   'tab-close
  "C-x t D"   'tab-close-other

  "C-c e"     '(:ignore t :which-key "[e]macs")
  "C-c e l"   'list-packages
  "C-c e g"   'garbage-collect
  "C-c e p"   'list-processes
  "C-c e i"   'my/open-emacs-init)

(general-def (special-mode-map help-mode-map)
  "b" 'backward-char
  "n" 'next-line
  "p" 'previous-line
  "f" 'forward-char)

;; `which-key': keybindings discovery.
(use-package which-key
  :ensure t
  :config
  (which-key-mode))


;; `evil' just because I cannot live without modal editing.
(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t
	evil-disable-insert-state-bindings t
        evil-want-keybinding nil
	evil-default-state 'emacs
	evil-motion-state-modes nil
        ;; evil-undo-system 'undo-tree
        ;; The cursor is allowed to go one character after the end of the line
        ;; just like in Emacs.
        evil-move-beyond-eol t)
  :config
  (evil-mode)

  (general-def '(normal motion visual insert)
    "C-e" 'move-end-of-line
    "C-a" 'move-beginning-of-line
    "C-b" 'backward-char
    "C-f" 'forward-char
    "C-r" 'undo-redo
    "s-u" 'universal-argument
    "s-s" 'save-buffer
    "C-n" 'next-line
    "C-p" 'previous-line
    "M-«" 'beginning-of-buffer
    "M-»" 'end-of-buffer)

  (general-def 'normal
    "SPC SPC" 'execute-extended-command

    ;; Lookup utilities.
    "g r"  'xref-find-references
    "g d"  'xref-find-definitions

    ;; Emacs utilities.
    "SPC e" '(:ignore t :which-key "[e]macs")
    "SPC e l" 'list-packages
    "SPC e p" 'list-processes
    "SPC e g" 'garbage-collect
    "SPC e i" 'my/open-emacs-init

    ;; Buffer management.
    "SPC b k" 'kill-this-buffer
    "SPC b g" 'revert-buffer-quick
    "SPC b r" 'rename-buffer

    ;; Tab management.
    "SPC t t" 'tab-switch
    "SPC t n" 'tab-new
    "SPC t p" 'project-other-tab-command
    "SPC t <return>" 'other-tab-prefix
    "SPC t r" 'tab-rename
    "SPC t d" 'tab-close
    "SPC t D" 'tab-close-other)

  (general-def 'visual
    "C-c r" '(:ignore t :which-key "[r]egion")
    :prefix "C-c r"
    "s" 'sort-lines
    "a" 'align-regexp
    "c" 'count-words)

  (general-def 'insert
    "C-w" 'evil-delete-backward-word
    "C-d" nil
    "C-p" nil
    "C-n" nil)

  (general-def '(normal motion operator visual)
    "t"   'backward-char
    "s"   'next-line
    "M-n" 'forward-paragraph
    "r"   'previous-line
    "M-p" 'backward-paragraph
    "n"   'forward-char
    "j"   'evil-find-char-to
    "k"   'evil-substitute
    "h"   'evil-replace
    "é"   'evil-forward-word-begin
    "É"   'evil-forward-WORD-begin
    "("   'evil-previous-open-paren
    "{"   'evil-backward-paragraph
    ")"   'evil-next-close-paren
    "}"   'evil-forward-paragraph
    "«"   'evil-shift-left
    "»"   'evil-shift-right)

  (general-def
    :states 'normal
    "z <tab>" 'outline-cycle)

  (evil-set-initial-state 'fundamental-mode 'normal)
  (evil-set-initial-state 'eshell-mode  'emacs)
  (evil-set-initial-state 'apropos-mode 'emacs)
  (evil-set-initial-state 'text-mode    'normal)
  (evil-set-initial-state 'conf-mode    'normal)
  (evil-set-initial-state 'org-mode     'normal)
  (evil-set-initial-state 'prog-mode    'normal)
  (evil-set-initial-state 'wdired-mode  'normal))


;;
;; `evil-surround': the power of surrounding things.
;;
(use-package evil-surround
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-evil-surround-mode))


;;
;; `evil-nerd-commenter': easy comments.
;;
(use-package evil-nerd-commenter
  :ensure t
  :after evil
  :init
  (general-def '(normal visual)
    "g c" 'evilnc-comment-or-uncomment-lines))


;;
;; Expand region
;;
(use-package expreg
  :ensure t
  :after evil
  :init
  (general-def
    :states 'visual
    "+" 'expreg-expand
    "-" 'expreg-contract))


;;; ----------------------------------------------------------------------------
;;; ORG-MODE & CALENDAR / DIARY

(setq calendar-week-start-day 1  ;; start the week display on Monday
      calendar-date-style "iso"
      appt-message-warning-time 15
      appt-display-interval 3
      appt-audible t)

(use-package org
  :hook (org-mode . visual-line-mode)
  :bind (:map org-mode-map
              ("<tab>" . org-cycle)
              ("M-t"   . org-metaleft)
              ("M-T"   . org-shiftmetaleft)
              ("M-n"   . org-metaright)
              ("M-N"   . org-shiftmetaright)
              ("M-s"   . org-metadown)
              ("M-S"   . org-shiftmetadown)
              ("M-r"   . org-metaup)
              ("M-R"   . org-shiftmetaup))
  :init
  :config
  (set-face-attribute 'org-block nil :inherit 'default)
  (custom-set-faces
   '(org-level-5 ((t (:inherit outline-5 :height 1.05))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.05))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.10))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.15))))
   '(org-level-1 ((t (:inherit outline-1 :height 1.20))))
   '(org-document-title ((t (:height 1.75)))))

  (setq org-hide-emphasis-markers t
        org-log-into-drawer t)
  (add-to-list 'org-export-backends 'md)
  (add-hook 'org-mode-hook
            (lambda ()
              (auto-fill-mode -1)
              (setq olivetti-body-width 0.66
                    ;; left-margin-width 4
                    ;; right-margin-width 4
                    completion-at-point-functions nil)))

  ;; Org-Agenda
  (require 'org-agenda)
  (setq org-agenda-hide-tags-regexp "."
        org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")
                                   (todo   . " ")
                                   (tags   . " %i %-12:c")
                                   (search . " %i %-12:c"))))


;; `org-appear' makes it so that when the cursor is on a hidden emphasis, the
;; symbols appear.
(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autolinks nil))


(use-package olivetti
  :ensure t)


;; Get Things Done workflow
;;
;; Inspired from:
;; - (heavily) https://github.com/rougier/emacs-gtd
(setq org-directory "~/Documents/org")
(setq org-agenda-files '("inbox.org" "agenda.org" "notes.org"))
(setq org-todo-keywords
      ;; ⚠️️ The separation, |, must be put between double quotes.
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w)" "|" "DONE(d)" "CANCELLED(c)")))

(require 'org-capture)
(setq org-capture-templates
      `(("i" "Inbox" entry (file "inbox.org")
         ,(concat "* %?\n"
                  "/Entered on/ %U"))

        ("m" "Meeting" entry (file+headline "agenda.org" "Future")
         ,(concat "* %? :meeting:\n"
                  "<%<%Y-%m-%d %a %H:00>>"))

        ("w" "Work Note" entry (file "notes.org")
         ;; The `%a' below is a template extension that will resolve to the
         ;; content created with the `org-store-link' command.
         ;;
         ;; If a note is captured while the cursor is on the same line of an
         ;; agenda entry, the `%a' will expand to this entry.
         ,(concat "* Note (%a)\n"
                  "/Entered on/ %U\n" "\n" "%?"))))

(defun my/org-open-inbox ()
  "Open the 'inbox.org' file."
  (interactive)
  (find-file (f-join org-directory "inbox.org")))

(general-def
  "C-c c"   'org-capture
  "C-c o a" 'org-agenda
  "C-c o i" 'my/org-open-inbox)

(general-def 'normal
  "SPC c" 'org-capture
  "SPC o a" 'org-agenda
  "SPC o i" 'my/org-open-inbox)


;;; ----------------------------------------------------------------------------
;;; DENOTE

;; NOTE: To create "silos" (i.e. denote files that do not share any
;;       characteristics) add the following content in a `.dir-locals.el' at
;;       the root of the "silo" folder.
;;
;; ((nil . ((denote-directory . "/path/to/the/folder"))))

(use-package denote
  :ensure t
  :config
  (setq denote-file-type :org
        denote-infer-keywords t
        denote-directory "~/Documents/"))


;;; ----------------------------------------------------------------------------
;;; NAVIGATION

(keymap-global-unset "s-S")
(keymap-global-unset "s-T")
(keymap-global-unset "s-R")
(keymap-global-unset "s-N")
(setq windmove-create-window t)
(keymap-global-set "s-T" 'windmove-left)
(keymap-global-set "s-S" 'windmove-down)
(keymap-global-set "s-R" 'windmove-up)
(keymap-global-set "s-N" 'windmove-right)
(keymap-global-set "s-d" 'delete-window)
(keymap-global-set "s-D" 'delete-other-windows)

(use-package avy
  :ensure t
  :bind (("M-s c" . avy-goto-char-timer)))


;;; ----------------------------------------------------------------------------
;;; COMPLETION & NARROWING

;;
;; Consult: search and navigation commands based on the completion function
;; backed in Emacs, `completing-read'.
;;
(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)
         ("M-i"   . consult-imenu)
         ("C-s"   . consult-line)
         ("M-y"   . consult-yank-from-kill-ring))
  :init
  (general-def 'normal
    "SPC b b"  'consult-buffer
    "SPC b p"  'consult-project-buffer
    "SPC / g"  'consult-git-grep
    "SPC / /"  'consult-ripgrep)
  :config
  (setq xref-show-xrefs-function       #'consult-xref
        xref-show-definitions-function #'consult-xref
        ;; TODO Investigate the narrowing key.
        ;; consult-narrow-key "«"
        ;; By default, the variable is set to `any' which means that any key
        ;; will trigger the preview (i.e. navigating to the previous/next line
        ;; will preview the file at point).
        ;;
        ;; Setting it to a specific key deactivate this behavior.
        consult-preview-key "M-."))


;;
;; Vertico
;;
(use-package vertico
  :ensure t
  :defer t
  :hook (after-init . vertico-mode)
  :commands vertico-mode
  :config
  (setq vertico-cycle t))

(use-package vertico-directory
  :after vertico
  :bind (:map vertico-map
              ("M-DEL" . vertico-directory-delete-word)))

(use-package nerd-icons-completion
  :if (display-graphic-p)
  :after marginalia
  :ensure t
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

;;
;; Marginalia
;;
(use-package marginalia
  :ensure t
  :defer t
  :hook (after-init . marginalia-mode)
  :commands (marginalia-mode marginalia-cycle)
  :config
  (set-face-attribute 'marginalia-documentation nil :foreground "#72809a" :height 1.0 :inherit nil))


;;
;; `orderless' completion style.
;;
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))


;;
;; Corfu: Completion Overlay in Region FUnction
;;

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :hook ((corfu-mode . corfu-popupinfo-mode))
  :config
  (add-hook 'evil-insert-state-exit-hook #'corfu-quit)
  (setq corfu-cycle t
        corfu-auto t
        corfu-auto-prefix 2
        corfu-preview-current 'insert
        corfu-on-exact-match nil
        corfu-auto-delay 0
        corfu-preselect 'first)
  (general-def
    :keymaps 'corfu-map
    "<tab>" 'corfu-insert
    "RET"   nil)

  (general-def 'insert
    :prefix "C-SPC"
    "SPC" 'completion-at-point))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :ensure t
  :init
  (general-def 'insert
    :prefix "C-SPC"
    "/" 'cape-dabbrev
    "d" 'cape-dict
    ":" 'cape-emoji
    "f" 'cape-file)

  (eval-after-load 'org
    (general-def
      :keymaps 'org-mode-map
      "C-SPC SPC" 'cape-dict)))


;;; ----------------------------------------------------------------------------
;;; EDITING

(use-package wgrep
  :ensure t)

;;
;; Embark
;;
(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act))         ;; pick some comfortable binding
  ;; ("C-;" . embark-dwim)        ;; good alternative: M-.
  ;; ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  )

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


;;; ----------------------------------------------------------------------------
;;; SPELL-CHECKER

(use-package jinx
  :ensure t
  :diminish t
  :hook (emacs-startup . global-jinx-mode)
  :bind ([remap ispell-word] . jinx-correct)
  ;; https://github.com/minad/jinx/discussions/160#discussioncomment-10951653
  ;; :init
  ;; (setenv "PKG_CONFIG_PATH" (concat "/opt/homebrew/opt/glib/lib/pkgconfig/:" (getenv "PKG_CONFIG_PATH")))
  :config
  (setq jinx-languages "en_GB fr_FR")
  (push '(toml-ts-mode font-lock-comment-face font-lock-string-face) jinx-include-faces))


;;; ----------------------------------------------------------------------------
;;; YASNIPPETS

(use-package yasnippet
  :ensure t
  :diminish
  :hook (after-init . yas-global-mode)
  :commands (yas-minor-mode-on
             yas-expand
             yas-expand-snippet
             yas-lookup-snippet
             yas-insert-snippet
             yas-new-snippet
             yas-visit-snippet-file
             yas-activate-extra-mode
             yas-deactivate-extra-mode
             yas-maybe-expand-abbrev-key-filter)
  :config
  (advice-add #'yas-snippet-dirs :filter-return #'delete-dups)
  (general-def 'insert
    :prefix "C-SPC"
    "y" 'yas-insert-snippet))

(use-package yasnippet-snippets
  :ensure t
  :diminish)


;;; ----------------------------------------------------------------------------
;;; PROJECT MANAGEMENT

(defun my/save-modified-buffers-in-current-project ()
  "Save all modified buffers for the current project."
  (interactive)
  (if (project-current nil)
      ;; we are visiting a buffer that belongs to a project, try to see if there
      ;; unmodified buffers
      (let* ((buffers (project-buffers (project-current nil)))
             (modified-buffers (cl-remove-if-not
                                (lambda (buf)
                                  ;; `buffer-file-name' will return `nil' if
                                  ;; `buf' points to a buffer that is not
                                  ;; associated to a real file.
                                  ;;
                                  ;; In short, that lambda filters out buffers
                                  ;; that are not pointing to a file.
                                  (and (buffer-file-name buf)
                                       (buffer-modified-p buf)))
                                buffers)))
        (if (null modified-buffers)
            (message "(No change need to be saved)")
          (dolist (buf modified-buffers)
            (with-current-buffer buf
              (save-buffer)
              (message "Saved < %s >" buf)))))
    ;; we are visiting a buffer that does not belong to a project
    (message "(No project found)")))

(setq project-vc-extra-root-markers '(".project"))

(general-def 'normal
  :prefix "SPC p"
  "p" 'project-switch-project
  "b" 'project-switch-to-buffer
  "f" 'project-find-file
  "S" 'my/save-modified-buffers-in-current-project
  "d" 'project-find-dir
  "g" 'project-find-regexp
  "k" 'project-kill-buffers
  "e" 'project-eshell)

;;
;; Treemacs
;;
(use-package treemacs
  :ensure t
  :init
  (general-def
    "s-b" 'treemacs-add-and-display-current-project-exclusively)
  :hook (treemacs-mode . treemacs-project-follow-mode)
  :config
  (general-def 'treemacs-mode-map
    "M-u" 'treemacs-root-up))

(use-package treemacs-nerd-icons
  :ensure t
  :after treemacs
  :config (treemacs-load-theme "nerd-icons"))


;;; ----------------------------------------------------------------------------
;;; PROGRAMMING

;;
;; Compilation mode
;;
(add-hook 'compilation-mode-hook (lambda ()
                                   (auto-fill-mode -1)))

(setq compilation-scroll-output t)


(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))


(use-package ws-butler
  :ensure t
  :hook (prog-mode . ws-butler-mode))


(use-package elec-pair
  :hook ((prog-mode . electric-pair-local-mode)
         (text-mode . electric-pair-local-mode)))


(use-package dape
  :ensure t
  :config
  (setq dape-buffer-window-arrangement 'right
        dape-inlay-hints t))

;; (use-package smartparens
;;   :ensure t
;;   :hook ((prog-mode . smartparens-mode)
;;          (text-mode . electric-pair-local-mode))
;;   :config
;;   (require 'smartparens-config)
;;   (setq sp-highlight-pair-overlay t
;;         sp-highlight-wrap-overlay nil
;;         sp-highlight-wrap-tag-overlay nil
;;         sp-show-pair-from-inside nil
;;         sp-cancel-autoskip-on-backward-movement nil
;;         ;; By default, if a pair is inserted, the `sp-pair-overlay-keymap' is
;;         ;; entered which makes `C-g' require two presses in order to quit
;;         ;; whatever we are doing.
;;         sp-pair-overlay-keymap (make-sparse-keymap)
;;         sp-max-prefix-length 25
;;         sp-max-pair-length 4))

  ;; ;; (defun smartparens-pair-newline-and-indent (id action context)
  ;; ;;   (save-excursion
  ;; ;;     (newline))
  ;; ;;   (indent-according-to-mode))

  ;; ;; (sp-pair "{" nil :post-handlers
  ;; ;;          '(:add (smartparens-pair-newline-and-indent "RET")))
  ;; ;; (sp-pair "[" nil :post-handlers
  ;; ;;          '(:add (smartparens-pair-newline-and-indent "RET")))

  ;; (sp-local-pair '(minibuffer-mode minibuffer-inactive-mode) "'" nil :actions nil)
  ;; (sp-local-pair '(minibuffer-mode minibuffer-inactive-mode) "`" nil :actions nil)
  ;; (sp-local-pair 'rust-ts-mode "r#\"" "\"#" :wrap "C-#"))


(use-package hl-todo
  :ensure t
  :hook (after-init . global-hl-todo-mode))


(use-package markdown-mode
  :ensure t
  :config
  (add-hook 'markdown-mode-hook (lambda ()
                                  (auto-fill-mode -1)
                                  (visual-line-mode))))


(use-package flymake
  :ensure nil
  :init
  (general-def 'normal
    "SPC d" '(:ignore t :which-key "[d]iagnostics")
    "SPC d l" 'flymake-show-project-diagnostics
    "SPC d n" 'flymake-goto-next-error
    "SPC d p" 'flymake-goto-prev-error)
  :config
  (setq flymake-no-changes-timeout 0.5
        flymake-start-on-save-buffer t)

  (defvar-keymap flymake-navigate-errors-repeat-map
    :doc "Keymap to repeat `flymake-goto-next-error' and `flymake-goto-prev-error'."
    :repeat t
    "n" #'flymake-goto-next-error
    "p" #'flymake-goto-prev-error))


;;; ----------------------------------------------------------------------------
;;; GIT

;; Setting up GPG on macOS.
;;
;; 1. Install pinentry-mac: homebrew install pinentry-mac
;;
;; 2. Modify the ~/.gnupg/gpg-agent.conf to include the following lines:
;;
;; allow-emacs-pinentry
;; allow-loopback-pinentry
;; pinentry-program /opt/homebrew/bin/pinentry-mac
;;
;; 3. Reload your gpg-agent:
;;
;; gpg-connect-agent reloadagent /bye

(use-package magit
  :ensure t
  :init
  (general-def 'normal smerge-mode-map
    :prefix "SPC g m"
    "n" 'smerge-next
    "p" 'smerge-prev)

  (general-def 'normal
    "SPC g" '(:ignore t :which-key "[M]agit")
    "SPC g s" 'magit-status)

  :config
  ;; Requiring `magit-extras' autoloads the function `magit-project-status'
  ;; which then appears once we open a new version-controlled project via
  ;; `project.el'
  (require 'magit-extras)
  (setq magit-display-buffer-function
        #'magit-display-buffer-fullframe-status-v1)
  (setq magit-bury-buffer-function #'magit-restore-window-configuration)

  (add-hook 'git-commit-mode-hook (lambda () (setq fill-column 72))))

;; As per the documentation of Forge, even though it is part of Magit it will
;; not load with it.
(use-package forge
  :ensure t
  :after magit)

(use-package diff-hl
  :ensure t
  :hook ((after-init         . global-diff-hl-mode)
         (dired-mode         . diff-hl-dired-mode)
         (magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

(use-package browse-at-remote
  :ensure t
  :init
  (general-def '(normal)
    "SPC g w" 'browse-at-remote))


;;; ----------------------------------------------------------------------------
;;; DOCUMENTATION

(defvar persistent-doc-buffer-name "*persistent-doc-at-point*"
  "The name of the buffer holding the persistent documentation.")

(setq max-mini-window-height 0.10)

(defun my/persistent-doc-at-point ()
  "Document the thing at point and display it in a frame below the current one.

  The content of the frame will not be refreshed if the cursor moves.  It will
  only be updated on a following call to this function."
  (interactive)
  (let ((symbol-documentation-buffer (eldoc-doc-buffer nil)))
    (with-temp-buffer-window
        persistent-doc-buffer-name
        nil  ; The display of the buffer is controlled by `display-buffer-alist'
        nil
      (with-current-buffer symbol-documentation-buffer
        (copy-to-buffer persistent-doc-buffer-name (point-min) (point-max))))

    (with-current-buffer persistent-doc-buffer-name (help-mode))))

(general-def 'normal
  "g h" 'my/persistent-doc-at-point)


;;; ----------------------------------------------------------------------------
;;; TREE-SITTER

(use-package tree-sitter
  :diminish
  :defer t)

(use-package tree-sitter-langs
  :ensure t)

(use-package tree-sitter-indent
  :ensure t)

(use-package treesit-auto
  :ensure t
  :diminish
  :config
  (setq treesit-auto-install 'prompt
        treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;;
;; `evil-textobj-tree-sitter': text objects based on tree-sitter
;;
(use-package evil-textobj-tree-sitter
  :ensure t
  :after (evil tree-sitter)
  :config
  ;; bind `function.outer`(entire function block) to `f` for use in things like `vaf`, `yaf`
  (define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
  ;; bind `function.inner`(function block without name and args) to `f` for use in things like `vif`, `yif`
  (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner")))


;;; ----------------------------------------------------------------------------
;;; LSP CLIENT

;; https://github.com/svaante/dape?tab=readme-ov-file#read-process-output-max
(if (eq system-type 'darwin)
    (setq read-process-output-max (* 64 1024))
  ;; I am assuming here that if the OS is not macOS then it is Linux.
  (setq read-process-output-max (* 1024 1024)))


(use-package eglot
  :ensure t
  :commands (eglot eglot-ensure)
  :init
  ;; (general-def
  ;;   :keymaps 'eglot-mode-map
  ;;   :states  'normal

  ;;   "SPC l" '(:ignore t :which-key "language server")
  ;;   "SPC l r" 'eglot-rename
  ;;   "SPC l a" 'eglot-code-actions
  ;;   "SPC l f" 'eglot-format-buffer
  ;;   "g t"     'eglot-find-typeDefinition
  ;;   "g i"     'eglot-find-implementation
  ;;   "g h"     'my/persistent-doc-at-point)

  ;; (general-def eglot-mode-map
  ;;   "C-c ." 'eglot-code-actions)

  (keymap-global-set "C-c ." 'eglot-code-actions)

  :config
  (add-hook 'eglot-managed-mode-hook (lambda ()
                                       (evil-define-key 'normal 'local
                                         (kbd "SPC l r") 'eglot-rename
                                         (kbd "SPC l a") 'eglot-code-actions
                                         (kbd "SPC l f") 'eglot-format-buffer
                                         (kbd "g t")     'eglot-find-typeDefinition
                                         (kbd "g i")     'eglot-find-implementation
                                         (kbd "g h")     'my/persistent-doc-at-point)))

  (custom-set-faces
   '(eglot-inlay-hint-face ((t
                             :height 0.8
                             ;; :foreground "#d8dee9"
                             :foreground "#72809a"
                             ;; :background "#2e3440"
                             :slant italic))))

  ;; NOTE: if an lsp server returns an error, change the value of the `:size'
  ;; property to be able to monitor the logs.
  (setq eglot-events-buffer-config '(:size 0 :format full)
        eglot-autoshutdown t)
  ;; Optimizations
  (fset #'jsonrpc--log-event #'ignore)
  (setq jsonrpc-event-hook nil)

  (add-to-list 'eglot-server-programs
               `((rust-ts-mode rust-mode) . ("rust-analyzer" :initializationOptions
                                              (:procmacro (:enable t)
                                               :check     (:command "clippy")
                                               :cargo     (:buildScripts (:enable t)))))))

(use-package consult-eglot
  :ensure t
  :after eglot
  :config
  (add-hook 'eglot-managed-mode-hook (lambda ()
                                       (evil-define-key 'normal 'local
                                         (kbd "SPC l s") 'consult-eglot-symbols))))

;; the package `eglot-booster' requires first to install the rust executable:
;;
;; https://github.com/blahgeek/emacs-lsp-booster
(if (executable-find "emacs-lsp-booster")
    (use-package eglot-booster
      :vc (:fetcher github :repo "jdtsmith/eglot-booster")
      :after eglot
      :config (eglot-booster-mode))
  (message "⚠️ could not find `emacs-lsp-booster' executable: https://github.com/jdtsmith/eglot-booster"))


(use-package breadcrumb
  :ensure t
  :hook ((rust-ts-mode . breadcrumb-local-mode))
  :config
  (custom-set-faces '(breadcrumb-face ((t :foreground "#72809a")))))


;;; ----------------------------------------------------------------------------
;;; RUST

(use-package rust-mode
  :ensure t
  :init
  (setq rust-mode-treesitter-derive t)
  :config
  (add-hook 'rust-ts-mode-hook
            (lambda ()
              (setq fill-column 100)
              (eglot-ensure)
              ;; The last argument to `add-hook' makes it
              ;; local to the mode.
              (add-hook 'before-save-hook #'eglot-format-buffer nil t)))
  (setq rust-format-on-save t
        rust-rustfmt-switches '("--config" "unstable_features=true"
                                "--config" "imports_granularity=Crate"
                                "--config" "group_imports=StdExternalCrate"
                                "--config" "format_code_in_doc_comments=true"
                                "--config" "edition=2021"
                                "--config" "format_strings=true")))


;;; ----------------------------------------------------------------------------
;;; PYTHON

(add-hook 'python-ts-mode-hook (lambda ()
                                   (setq python-indent-offset 4)))

(if (and (executable-find "dasel") (executable-find "sqlite3"))
    (use-package pet
      :ensure t
      :config
      ;; The `-10' tells Emacs to execute the hook as early as possible.
      (add-hook 'python-base-mode-hook 'pet-mode -10))
  (progn
    (unless (executable-find "dasel")
      (message "⚠️ Could not find `dasel' executable"))
    (unless (executable-find "sqlite3")
      (message "⚠️ Could not find `sqlite3' executable"))))

(use-package python
  :config
  (add-hook 'python-ts-mode-hook (lambda ()
                                   (eglot-ensure)
                                   (setq fill-column 80))))


;;; ----------------------------------------------------------------------------
;;; YAML
(add-to-list 'auto-mode-alist '("\\.\\(?:yml\\|yaml\\)\\'" . yaml-ts-mode))
(add-hook 'yaml-mode-hook #'display-line-numbers-mode)

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-vc-selected-packages
   '((vc-use-package :vc-backend Git :url "https://github.com/slotThe/vc-use-package"))))
