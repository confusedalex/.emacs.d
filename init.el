;; Package Management
;; I use [[https://github.com/radian-software/straight.el][straight.el]] for package managment. Instead of the default
;; ~package.el~ it allows for creating lockfiles and different
;; profiles. So all packages needed for development could go into a dev
;; profile and don't pollute or rather slow down emacs on my phone. But
;; currently I don't make use of both these features.

;; [[file:README.org::*Package Management][Package Management:1]]
;; Bootstrap Straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; Package setup -----
(straight-use-package 'use-package)

(use-package straight
  :custom
  (straight-use-package-by-default t)
  (straight-current-profile 'base)
  )
;; Package Management:1 ends here

;; macos
;; These are some macos specific settings, which change the meta-key do the command-key on macos and disables the option key in Emacs.

;; [[file:README.org::*macos][macos:1]]
(when (memq system-type '(darwin))
  (set-fontset-font t nil "SF Pro Display" nil 'append)

  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none)

  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-to-list 'default-frame-alist '(undecorated-round . t))
  (add-to-list 'load-path "/opt/homebrew/share/emacs/site-lisp/mu/mu4e")
  (setq mu4e-mu-binary "/opt/homebrew/bin/mu")
  )
;; macos:1 ends here

;; Path fix

;; [[file:README.org::*Path fix][Path fix:1]]
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))
;; Path fix:1 ends here

;; emacs

;; [[file:README.org::*emacs][emacs:1]]
(use-package emacs
  :init
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  :custom
  (auto-save-visited-mode 1)
  (make-backup-files nil)
  (global-auto-revert-mode t)
  (repeat-mode t)
  (help-window-select t)
  (help-window-keep-selected t)
  (shr-use-colors nil)
  (shr-use-fonts nil )
  (delete-by-moving-to-trash t)                   ;; Move deleted files to the trash instead of permanently deleting them.
  (delete-selection-mode 1)                       ;; Enable replacing selected text with typed text.
  (inhibit-startup-message t)                     ;; Disable the startup message when Emacs launches.
  (tab-always-indent 'complete)                   ;; Make the TAB key complete text instead of just indenting.
  
  (display-line-numbers-type 'visual)             ;; Use relative line numbering in programming modes.
  (use-short-answers t)                           ;; y/n instead of yes/no
  
  (auth-sources '("~/.emacs.d/.authinfo.gpg"))
  
  (scroll-conservatively 101)
  (pixel-scroll-precision-mode t) 
  
  (set-default-coding-systems 'utf-8)             ;; utf-8
  (redisplay-skip-fontification-on-input t)       ;; Only syntax-highlight when I stopped typing
  (read-process-output-max (* 4 1024 1024)) ; 4MB
  
  ;; save your last position in file
  ;; https://www.emacswiki.org/emacs/SavePlace
  (save-place-mode 1)
  
  (indent-tabs-mode nil)
  (tab-width 2)
    (enable-recursive-minibuffers t)
    ;; Hide commands in M-x which do not work in the current mode.  Vertico
    ;; commands are hidden in normal buffers. This setting is useful beyond
    ;; Vertico.
    (read-extended-command-predicate #'command-completion-default-include-p)
    ;; Do not allow the cursor in the minibuffer prompt
    (minibuffer-prompt-properties
     '(read-only t cursor-intangible t face minibuffer-prompt))
  :bind
  ("C-+" . text-scale-increase)
  ("C-_" . text-scale-decrease)
  ("<C-wheel-up>" . text-scale-increase)
  ("<C-wheel-down>" . text-scale-decrease)
  ("C-x k" . kill-current-buffer)
  :hook
  (prog-mode . display-line-numbers-mode)
  (text-mode . display-line-numbers-mode)
  )
;; emacs:1 ends here

;; Theme

;; [[file:README.org::*Theme][Theme:1]]
(use-package ef-themes
  :config
  (load-theme 'ef-dream t)
  )
;; Theme:1 ends here

;; dired

;; [[file:README.org::*dired][dired:1]]
(use-package dired
  :straight nil
  :init
  (require 'dired-x)
  :bind
  (:map dired-mode-map
	("M-." . dired-omit-mode)) ;; toggle using Command-Shift-.  same as macOS Finder
  :hook
  (dired-mode . dired-omit-mode)
  (dired-mode . dired-hide-details-mode)
  :config
  (setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
  :custom
  (dired-dwim-target t)
  (dired-recursive-copies 'always)
  (dired-create-destination-dirs 'ask)   
  (dired-clean-confirm-killing-deleted-buffers nil)
  (dired-make-directory-clickable t)
  (dired-mouse-drag-files t)
  (dired-kill-when-opening-new-dired-buffer t)
  )
;; dired:1 ends here

;; date2name

;; [[file:README.org::*date2name][date2name:1]]
(use-package date2name
  :after org
  :custom
  (date2name-default-separation-character " "))
;; date2name:1 ends here

;; filetags

;; [[file:README.org::*filetags][filetags:1]]
(use-package filetags)
;; filetags:1 ends here

;; Snake

;; [[file:README.org::*Snake][Snake:1]]
(use-package snake
  :straight nil
  :bind
  (:map snake-mode-map
   ("w" . snake-move-up)
   ("a" . snake-move-left)
   ("s" . snake-move-down)
   ("d" . snake-move-right)
   )
  )
;; Snake:1 ends here

;; Font

;; [[file:README.org::*Font][Font:1]]
(set-face-attribute 'default nil :family "AporeticSerifMonoNerdFont" :height 160)
(set-face-attribute 'variable-pitch nil :family "Aporetic Sans" :height 1.5)
;; Font:1 ends here

;; Appearance
;; Ignore compile errors

;; [[file:README.org::*Appearance][Appearance:1]]
(add-to-list 'display-buffer-alist                                                      
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"                               
               (display-buffer-no-window)                                               
               (allow-no-window . t)))                                                  
;; Appearance:1 ends here

;; [[file:README.org::*Appearance][Appearance:2]]
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))
;; Appearance:2 ends here

;; [[file:README.org::*Appearance][Appearance:3]]
(use-package nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))
;; Appearance:3 ends here

;; [[file:README.org::*Appearance][Appearance:4]]
(use-package rainbow-delimiters
  :defer t
  :hook
  (prog-mode . rainbow-delimiters-mode))
;; Appearance:4 ends here

;; [[file:README.org::*Appearance][Appearance:5]]
(use-package olivetti
  :custom
  (olivetti-body-width 82)
  (olivetti-style nil)
  :bind ("C-c z" . olivetti-mode))
;; Appearance:5 ends here

;; [[file:README.org::*Appearance][Appearance:6]]
(use-package dashboard
  :config
  (dashboard-setup-startup-hook))
;; Appearance:6 ends here


;; Vertico enables vertical completiton in the minibuffer, which makes
;; the minibuffer easier to use and more pleasent to view.

;; [[file:README.org::*Minibuffer][Minibuffer:2]]
(use-package vertico
  :defer t
  :commands vertico-mode
  :hook (after-init . vertico-mode))
;; Minibuffer:2 ends here



;; Marginalia adds annotations like keybinds to the minibuffer results

;; [[file:README.org::*Minibuffer][Minibuffer:3]]
(use-package marginalia
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))
;; Minibuffer:3 ends here



;; ~Consult~ adds more completion interfaces to work with.

;; [[file:README.org::*Minibuffer][Minibuffer:4]]
(use-package consult
  :defer t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind
  (
   ("C-x b" . consult-buffer)
   ("M-y"   . consult-yank-pop)
   ("M-s f" . consult-fd)
   ("M-s c" . (lambda() (interactive)(find-file "~/.emacs.d/README.org")))
   ("M-s g" . consult-ripgrep)
   ("M-s h" . consult-info)
   ("M-s r" . consult-recent-file)
   ("M-s t" . consult-theme)
   ("M-s s" . consult-line)
   ("M-s l" . consult-line)
   )
  :init
  ;; Enhance register preview with thin lines and no mode line.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult for xref locations with a preview feature.
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))
;; Minibuffer:4 ends here

;; [[file:README.org::*Minibuffer][Minibuffer:5]]
(use-package which-key
  :straight nil
  :hook
  (after-init . which-key-mode))

(use-package disproject
  :bind (("C-c p" . disproject-dispatch)))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package savehist
  :straight nil
  :hook (after-init . savehist-mode))

(use-package flycheck
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error))
  :hook (prog-mode . flycheck-mode)
  )



(use-package apheleia
  :hook (prog-mode . apheleia-global-mode)
  :bind
  ("C-c M-f"))

(use-package smartparens
  :hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  (require 'smartparens-config)) 



(use-package pdf-tools
  :init
  (pdf-tools-install)
  (pdf-loader-install)
  )

(use-package agent-shell)

(use-package dired-preview)
;; Minibuffer:5 ends here

;; Completion
;; ~Orderless~ reworks the completion ordering by usage and
;; mark-at-point.

;; [[file:README.org::*Completion][Completion:1]]
(use-package orderless
  :custom
  (completion-styles '(orderless partial-completion basic))
  (completion-category-defaults nil)
  (completion-category-overrides nil))
;; Completion:1 ends here


;; ~Cape~ adds more completetion providers.

;; [[file:README.org::*Completion][Completion:2]]
(use-package cape
  :init
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; Complete word from current buffers
  (add-to-list 'completion-at-point-functions #'cape-file) ;; Path completion
  (add-to-list 'completion-at-point-functions #'cape-elisp-block) ;; Complete elisp in Org or Markdown mode
  )
;; Completion:2 ends here

;; [[file:README.org::*Completion][Completion:3]]
(use-package corfu
  :after orderless
  :hook
  (after-init . global-corfu-mode)
  :custom
  (corfu-cycle t)           ;; Enable cycling for `corfu-next/previous'
  (corfu-preselect 'prompt) ;; Always preselect the prompt
  (corfu-auto t)            ;; Enables auto-completion
  (corfu-auto-trigger ".")            ;; Enables auto-completion
  (corfu-popupinfo-mode t)  ;; Enable popup information
  (corfu-popupinfo-delay '(0.25 . 0.1)) ;; Lowers the delay of popup appearance
  (corfu-auto-delay 0.1)    ;; lower delay for completion
  
  (completion-ignore-case t)

  (text-mode-ispell-word-completion nil) ;; Disable Ispell completion
)  
;; Completion:3 ends here

;; vundo
;; visual-undo allows traversing a undo-timeline and deciding between
;; branching points. Makes undo way more powerful and easier to
;; understand.

;; [[file:README.org::*vundo][vundo:1]]
(use-package vundo
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))
;; vundo:1 ends here

;; git
;; Of course I use ~magit~ as my git interface.

;; [[file:README.org::*git][git:1]]
(use-package magit :bind ("C-c g" . 'magit-status)
  :config
  (with-eval-after-load 'magit-commit
    (transient-replace-suffix 'magit-commit 'magit-commit-autofixup
      '("x" "Absorb changes" magit-commit-absorb))))
;; git:1 ends here


;; To see which lines are changed, delete or added I use ~diff-hl~ to
;; visualize these changes in the fringe. ~diff-hl-flydiff-mode~ redraws
;; the fringe on every change, not every file save as otherwise.

;; [[file:README.org::*git][git:2]]
(use-package diff-hl
  :hook ((dired-mode         . diff-hl-dired-mode-unless-remote)
         (magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1)
  )
;; git:2 ends here


;; ~forge~ allows me to use interact with Github or Gitlab in magit. I
;; can open, close or participate in Issues and even merge pull requests.

;; [[file:README.org::*git][git:3]]
(use-package forge
  :after magit)
;; git:3 ends here

;; Code commenting
;; ~comment-dwin-2~ makes commenting a nicer experience. It supports comments in front and at the end of a line.

;; [[file:README.org::*Code commenting][Code commenting:1]]
(use-package comment-dwim-2
  :bind
  ("M-;" . comment-dwim-2))
;; Code commenting:1 ends here

;; No littering

;; [[file:README.org::*No littering][No littering:1]]
(use-package no-littering)
;; No littering:1 ends here

;; expreg
;; Expand region allow for simple region increase and decrease with
;; treesitter objects.

;; [[file:README.org::*expreg][expreg:1]]
(use-package expreg
  :ensure t
  :bind (("C-=" . expreg-expand)
         ("C--" . expreg-contract)
         (:repeat-map expreg-repeat-map
                      ("=" .  expreg-expand)
                      ("-" .  expreg-contract)))
  )
;; expreg:1 ends here

;; tramp
;; Tramp allow to connect with emacs to other servers.

;; [[file:README.org::*tramp][tramp:1]]
(use-package tramp
  :custom
  (remote-file-name-inhibit-locks t)
  (tramp-use-scp-direct-remote-copying t)
  (remote-file-name-inhibit-auto-save-visited t))
;; tramp:1 ends here


;; Tramp-rpc uses json-rpc which makes tramp way faster for me.

;; [[file:README.org::*tramp][tramp:2]]
(use-package tramp-rpc
  :straight (tramp-rpc :type git :host github :repo "ArthurHeymans/emacs-tramp-rpc")
  :custom
  (tramp-rpc-deploy-git-build-policy 'release))
;; tramp:2 ends here

;; Language Server Protocol

;; [[file:README.org::*Language Server Protocol][Language Server Protocol:1]]
(use-package lsp-mode
  :commands lsp lsp-deferred
  :defer t
  :init
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))) ;; Configure orderless
  :custom
  (lsp-completion-provider :none)       ; Using Corfu as the provider
  (lsp-keymap-prefix "C-c l")           ; Prefix for LSP actions
  (lsp-log-io nil)
  (lsp-signature-render-documentation nil)
  (lsp-eldoc-enable-hover nil)
  (lsp-auto-execute-action nil) ; don't automatically run first code action
  (lsp-enable-file-watchers nil)
  :hook (
         (nix-ts-mode . lsp-deferred)
		     (python-ts-mode . lsp-deferred)
		     (dart-mode . lsp-deferred)
		     (go-mode . lsp-deferred)
		     (typescript-ts-mode . lsp-deferred)
		     (tsx-ts-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)
         (lsp-completion-mode . my/lsp-mode-setup-completion))
  )

(use-package lsp-ui
  :custom
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover nil)
  :commands lsp-ui-mode)

(use-package lsp-dart
  :custom
  (lsp-dart-flutter-widget-guides nil))

(use-package lsp-biome
  :straight (lsp-biome :type git :host github :repo "cxa/lsp-biome")

  :preface
  (defun my/lsp-biome-active-hook ()
    (setq-local apheleia-formatter '(biome)))
  
  :config
  (add-hook 'lsp-biome-active-hook #'my/lsp-biome-active-hook)
  )
;; Language Server Protocol:1 ends here

;; Dart/Flutter
;; First we use dart-mode for dart specific stuff.

;; [[file:README.org::*Dart/Flutter][Dart/Flutter:1]]
(use-package dart-mode
  :defer t
  :hook (dart-mode . flutter-test-mode))
;; Dart/Flutter:1 ends here


;; For running flutter apps and tests I use flutter mode

;; [[file:README.org::*Dart/Flutter][Dart/Flutter:2]]
(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  )
;; Dart/Flutter:2 ends here


;; Flutter can only run on started emulators. Because I don't want to
;; start the emulator manually I've developed this little wrapper:

;; [[file:README.org::*Dart/Flutter][Dart/Flutter:3]]
 (defun flutter-launch-emulator (emulator-id)
  "Launches the emulator with the given ID."
  (interactive
   (list (completing-read "Emulator: " (flutter--emulators))))
  (shell-command (format "flutter emulators --launch %s" emulator-id))
  )

(defun flutter--emulators ()
  "Return an list of emulators."
  (string-lines (shell-command-to-string "emulator -list-avds") t)
  )
;; Dart/Flutter:3 ends here

;; Latex

;; [[file:README.org::*Latex][Latex:1]]
(use-package auctex
  :hook
  (LaTeX-mode . TeX-source-correlate-mode) ;; jump between source and preview
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil) ;; ask for master file
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  )
(use-package cdlatex)
(use-package reftex)
;; Latex:1 ends here

;; Nix

;; [[file:README.org::*Nix][Nix:1]]
(use-package nix-mode
  :mode "\\.nix$")
;; Nix:1 ends here

;; Kdl

;; [[file:README.org::*Kdl][Kdl:1]]
(use-package kdl-mode
  :mode ("\\.kdl\\'"))
;; Kdl:1 ends here

;; Yaml

;; [[file:README.org::*Yaml][Yaml:1]]
(use-package yaml-mode
  :defer t
  :mode (
         ("\\.yml\\'" . yaml-mode))
  )
;; Yaml:1 ends here

;; fish

;; [[file:README.org::*fish][fish:1]]
(use-package fish-mode
  :defer t
  :mode (
         ("\\.fish\\'" . fish-mode))
  )
;; fish:1 ends here

;; Prisma

;; [[file:README.org::*Prisma][Prisma:1]]
(use-package prisma-mode
  :straight (prisma-mode :type git :host github :repo "pimeys/emacs-prisma-mode"))
;; Prisma:1 ends here

;; Golang

;; [[file:README.org::*Golang][Golang:1]]
(use-package go-mode)
;; Golang:1 ends here

;; Org-Mode

;; [[file:README.org::*Org-Mode][Org-Mode:1]]
(use-package org
  :hook
  ((org-mode . org-indent-mode)
   (org-mode . visual-line-mode))
  :bind
  (
   ("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c e" . org-export-dispatch)
   ("C-c n h" . (lambda() (interactive)(find-file "~/persist/org/hardware.org")))
   ("C-c n j" . (lambda() (interactive)(find-file "~/persist/org/journal.org.gpg")))
   ("C-c n n" . (lambda() (interactive)(find-file "~/persist/org/notes.org")))
   ("C-c n w" . (lambda() (interactive)(find-file "~/persist/org/work.org")))

   ("C-c A" . org-archive-subtree-default)
   ("C-c f" . consult-org-heading)
   ("C-c h" . org-toggle-heading)
   ("C-c o" . org-set-property)
   ("C-c r" . org-refile)
   ("C-c t" . org-todo)
   
   ;; Org subtree
   ("C-c N" . org-narrow-to-subtree)
   ("C-c W" . widen)
   ("C-c S" . org-sort)
   )
  :custom
  (org-directory "~/persist/org/")
  (org-agenda-files (list org-directory))
  (org-ellipsis "⤵")
  
  (org-fold-catch-invisible-edits 'error) ;; error when editing in not folded area

  (global-hi-lock-mode 1)
  (org-todo-keywords
   '((sequence
      "PROJ(p)"  ; State for projects
      "TODO(t)"  ; A task that needs doing & is ready to do
      "STRT(s)"  ; A task that is in progress
      "WAIT(w@/!)"  ; Something external is holding up this task
      "DELEGATED(g)"  ; Item that's delegate to someone else
      "SOMEDAY(m)"
      "OTHER(o)" ; A task which I isn't my direct or indirect responsibilty
      "|"
      "DONE(d)"  ; Task successfully completed
      "KILL(k@)")) ; Task was cancelled, aborted, or is no longer applicable
   )
  (org-todo-keyword-faces
   '(("DELEGATED" . (:foreground "orange" :weight bold))
     ("WAITING" . (:foreground "yellow" :weight bold))))

  (org-log-done 'time) ; Add timestamp when a task is closed
  (org-log-into-drawer t) ;; Log changes into a drawer, so it wont clutter up my entry

  (org-extend-today-until 5) ;; my day ends at 05:00, you have to love org mode for this

  (org-agenda-start-on-weekday nil) ; We don't need to start on a weekday, do we?

  (org-agenda-skip-deadline-prewarning-if-scheduled t) ;; don't show deadlined when it's schedules on the same date
  (org-agenda-tags-todo-honor-ignore-options t) ;; Always honor options
  (org-agenda-skip-schedulded-if-done t) ;; Don't show schedulded items, if done
  (org-agenda-skip-scheduled-if-deadline-is-shown t) ;; don't show scheduled if deadlined on the same day
  (org-agenda-skip-deadline-if-done t) ;; Don't show deadlined items, if done
  (org-agenda-todo-ignore-scheduled 'all) ;; Don't show schedulded dates in global TODO list
  (org-agenda-skip-timestamp-if-deadline-is-shown t)

  (org-agenda-time-grid
   '((today require-timed remove-match)
     (000 1200 1600 2400)
     "  " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))
  (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈┈ now")
  (org-agenda-sort-notime-is-late nil) ;; Show timestamps with no time first

  (org-agenda-window-setup 'current-window)

  (org-return-follows-link t)

  (org-export-with-toc nil)
  (org-html-htmlize-output-type 'css)
  (org-html-head-include-default-style nil)
  (org-html-postamble nil) ;; no postamble
  
  (org-refile-targets
   '((nil :maxlevel . 5)
     (org-agenda-files :maxlevel . 5)) ;; add all agenda files as refile targets
   ;; Without this, completers like ivy/helm are only given the first level of
   ;; each outline candidates. i.e. all the candidates under the "Tasks" heading
   ;; are just "Tasks/". This is unhelpful. We want the full path to each refile
   ;; target! e.g. FILE/Tasks/heading/subheading
   org-refile-use-outline-path 'file
   org-outline-path-complete-in-steps nil)

  (org-tag-alist
   '(;; Places
     ("@home" . ?H)
     ("@work" . ?W)

     ;; Devices
     ("@computer" . ?C)
     ("@phone" . ?P)

     ;; Activities
     ("@planning" . ?n)
     ("@programming" . ?p)
     ("@email" . ?e)
     ("@shopping" . ?g)
     ("@calls" . ?a)
     )
   )
  )

(defun my/org-normalize-all-timestamps ()
  (interactive)
  (save-excursion
    (let ((positions (org-element-map (org-element-parse-buffer) 'timestamp
                       (lambda (timestamp)
                         (org-element-property :begin timestamp)))))
      (dolist (pos (reverse positions))
        (goto-char pos)
        (org-timestamp-up-day 0)      )
      )))

(use-package org
  :config
  (org-clock-persistence-insinuate)
  :custom
  (org-clock-in-resume t)
  (org-clock-into-drawer t)
  (org-clock-out-remove-zero-time-clocks t)
  (org-clock-out-when-done t)
  (org-clock-persist t)
  (org-clock-persist-query-resume nil)
  (org-clock-report-include-clocking-task t)
  )

(use-package org-cliplink
  :defer t
  :commands (org-cliplink-capture))

(setq org-capture-templates
      '(
	      ("p" "Personal")
        ("pt" "Personal todo" entry
         (file+headline "notes.org" "Inbox")
         "* TODO %?\n%i" :prepend t)
        ("pn" "Personal notes" entry
         (file+headline "notes.org" "Inbox")
         "* %u %?\n%i" :prepend t)
        ("B" "Book" entry (file+headline "hardware.org" "Bücher")
         "** TODO %^{ Title }
         %^{AUTHOR}p
         %^{PAGES}p
         %^{RATING}p
         %^{CUSTOM_ID}p
         %^{SERIAL_NUMBER}p
         "
         )
        ("i" "Item" entry (file "hardware.org")
         "* %^{Item name}
         %^{CUSTOM_ID}p
         %^{LOCATION}p
         %^{DESCRIPTION}p
         %^{PURCHASE_DATE}p
         %^{PRICE}p
         %^{SERIAL_NUMBER}p
         %^{LENDING}p
         %^{LEND_DATE}p
         ")
        ("j" "Journal entry" entry (file+datetree "journal.org.gpg") "* %(my/org-journal-timestamp) \n%?")
	      ("b" "Bookmark" entry (file+headline "notes.org" "Bookmarks")
	       "* %(org-cliplink-capture) \n:PROPERTIES:\n:CREATED: %U\n:END:\n")
        ("e" "Email capture" entry (file+headline "notes.org" "Inbox") "* TODO %a")
	      ("a" "Appointment" entry (file+headline "notes.org" "Events") "* %? %^t")
        ("w" "Weight" table-line ( id "e0957b0e-d05e-485d-ad0a-e769287a5fe6" ) " | %^u | %^{Gewicht} |" :prepend t)
        )
      )

(defun my/org-capture-setup-action ()
  (when (equal (plist-get org-capture-plist :key) "j")
    (delete-other-windows)
    (olivetti-mode)
    (refill-mode)
    ))

(add-hook 'org-capture-mode-hook 'my/org-capture-setup-action)

(defun my/org-journal-timestamp ()
  (let ((hour (string-to-number (format-time-string "%H"))))
    (if (< hour 6)
        (format-time-string "%H:%M (%d.%m)")
      (format-time-string "%H:%M"))))


;; Nicer list creation
(use-package org-autolist
  :hook (org-mode . org-autolist-mode))

;; for the occasional ics import
(use-package org-caldav
  :custom
  (org-caldav-inbox "/Users/alex/persist/org/inbox.org")
  )

(use-package org-super-agenda
  :after org-agenda
  :defer t
  :config
  (defvar work-files '("/home/alex/persist/org/work.org" "/home/alex/persist/org/google-calendar.org"))
  :custom
  (org-super-agenda-header-map nil)
  (org-super-agenda-mode t)
  (org-agenda-custom-commands
   '(
     ("i" "Inbox" tags-todo "+TODO=\"TODO\""
      ((org-agenda-files (file-expand-wildcards "~/persist/org/inbox.org"))))
     ("a" "3 Day Agenda"
      ((agenda ""
               ((org-agenda-span 3)
                (org-deadline-warning-days 0))) 
       (agenda ""
               ((org-agenda-time-grid nil)
                (org-agenda-entry-types '(:deadline))
                (org-agenda-start-on-weekday nil)
                (org-agenda-start-day "+3d")
                (org-agenda-span 14)
                (org-agenda-show-all-dates nil)
                (org-deadline-warning-days 0)
                (org-agenda-block-separator nil)
                
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                (org-agenda-overriding-header "\nUpcoming deadlines (+14d)\n")))
       (tags-todo "-TODO=\"DELEGATED\""
                  ((org-agenda-overriding-header "")
                   (org-super-agenda-groups
                    '((:name "Started"
			                       :todo "STRT")
	                    (:name "Waiting"
			                       :todo "WAIT")
                      (:name "Inbox"
                             :and (
                             :todo "TODO"
                             :tag "inbox"))
                      (:name "Tasks"
                             :todo "TODO")
                      (:name "Someday"
                             :todo "SOMEDAY")
                      )))))
      ((org-agenda-tag-filter-preset '("-@work" "-gifts"))
       (org-agenda-skip-function-global
        '(org-agenda-skip-entry-if 'todo '("OTHER"))))
      )
     )
   )
  )

(use-package toc-org
  :commands toc-org-enable
  :hook (org-mode . toc-org-mode))

(use-package org-tempo
  :straight nil
  :after org
  :config
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  )

(use-package ob-python :straight nil)

(use-package org
  :custom
  (org-confirm-babel-evaluate nil) ;; don't ask for permission to run
  (org-src-window-setup 'current-window)
  (org-edit-src-persistent-message nil)
  (org-src-fontify-natively t)
  (org-src-preserve-indentation t) ; use the indentation of the major mode
  (org-src-tab-acts-natively t)
  (org-edit-src-content-indentation 0)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t)))

  )
;; Org-Mode:1 ends here

;; wordcloud
;; Builts a worldcloud of the current buffer. Can be sortet
;; alphabetically or by frequency.

;; [[file:README.org::*wordcloud][wordcloud:1]]
(use-package wordcloud
  :straight (wordcloud :type git :host github :repo "davep/wordcloud.el"))
;; wordcloud:1 ends here

;; elfeed
;; For reading rss feeds I use elfeed. I set "g" to update my feeds when
;; in the elfeed buffer. For a nicer reading experience I enter
;; olivetti-mode on opening an entry.

;; [[file:README.org::*elfeed][elfeed:1]]
(use-package elfeed
  :bind (("C-x e" . elfeed)
         :map elfeed-search-mode-map
         ("g" . 'elfeed-update)
         )
  :hook (elfeed-show-mode . olivetti-mode))
;; elfeed:1 ends here


;; To use elfeed with my rss reader, I need to use elfeed protocol. 

;; [[file:README.org::*elfeed][elfeed:2]]
(use-package elfeed-protocol
  :custom
  (elfeed-protocol-fever-update-unread-only nil)
  (elfeed-protocol-fever-fetch-category-as-tag t)
  (elfeed-feeds '(("fever+https://alex@rss.mytbu.de"
                            :api-url "https://rss.mytbu.de/fever/"
                            :use-authinfo t)))
  :config
  (elfeed-protocol-enable))
;; elfeed:2 ends here

;; Email
;; I want to read my emails via Emacs. For this I use mu4e:

;; [[file:README.org::*Email][Email:1]]
(use-package mu4e
  :straight nil
  :bind (("C-x m" . mu4e))
  :custom
  (user-mail-address "alex@loll.be")
  (user-full-name "Alexander Loll")
  (mu4e-sent-folder   "/Sent")
  (mu4e-drafts-folder "/Drafts")
  (mu4e-trash-folder  "/Trash")
  (mu4e-get-mail-command "mbsync -a")
  (mu4e-update-interval 300)
  (mu4e-change-filenames-when-moving t)
  (sendmail-program (executable-find "msmtp"))
  (send-mail-function 'message-send-mail-with-sendmail)
  (message-send-mail-function 'message-send-mail-with-sendmail)
  (message-sendmail-envelope-from 'header)
  (message-kill-buffer-on-exit t)
  (mu4e-maildir-shortcuts '(
                            (:maildir "/INBOX" :key ?i)
                            (:maildir "/Sent" :key ?s)
                            (:maildir "/Drafts" :key ?d)
                            (:maildir "/Trash" :key ?t)
                            (:maildir "/Archive" :key ?a)
                            (:maildir "/Politik" :key ?p)
                            (:maildir "/Menschen" :key ?m)
                            ))
  (mail-user-agent 'mu4e-user-agent)
  (read-mail-command 'mu4e)
  (mml-secure-openpgp-encrypt-to-self t)
  :config
  (load-file (expand-file-name "refile.el" user-emacs-directory))
  (defun my/mu4e-unsubscribe ()
    "A quick and dirty function to unsubscribe from mails"
    (interactive)
    (browse-url
             (concat
              (cdr
               (butlast
                (string-to-list
                 (mu4e-fetch-field (mu4e-message-at-point) "List-Unsubscribe"))))
              ))
    (mu4e-headers-mark-for-delete)
    )
  )
;; Email:1 ends here
