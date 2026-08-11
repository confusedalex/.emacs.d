(straight-use-package 'use-package)

(use-package straight
  :custom
  (straight-use-package-by-default t)
  (straight-current-profile 'base)
  )

(defvar os-linux (string-equal system-type "gnu/linux") "Running on Linux.")
(defvar os-macos (string-equal system-type "darwin") "Running on macOS.")
(defvar is-work (string= system-name "avin5K0B2K4"))

(cond
 (os-linux (defvar my/font-height 140 "The default font height for Emacs on Linux (in 1/10th points)."))
 (os-macos (defvar my/font-height 180 "The default font height for Emacs on macOS (in 1/10th points)."))
 (t (defvar my/font-height 140 "The default font height for Emacs on Windows and other systems (in 1/10th points).")))

(when os-macos
  (set-fontset-font t nil "SF Pro Display" nil 'append)

  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none)

  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark))
  (add-to-list 'default-frame-alist '(undecorated-round . t))
  (add-to-list 'load-path "/opt/homebrew/share/emacs/site-lisp/mu/mu4e")
  (setq mu4e-mu-binary "/opt/homebrew/bin/mu")
  )

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(when os-linux
  (add-to-list 'default-frame-alist '(undecorated . t))
  )

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
  
  (auth-sources '("~/.emacs.d/.authinfo.gpg" "~/.authinfo"))
  
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

(use-package ef-themes
  :config
  (load-theme 'ef-dream t)
  )

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

(use-package dired-preview)

(use-package date2name
  :after org
  :custom
  (date2name-default-separation-character " "))

(use-package filetags)

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

(set-face-attribute 'default nil :family "AporeticSerifMonoNerdFont" :height my/font-height)
(set-face-attribute 'variable-pitch nil :family "Aporetic Sans" :height 1.5)

(add-to-list 'display-buffer-alist                                                      
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"                               
               ``(display-buffer-no-window)                                               
               (allow-no-window . t)))                                                  

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

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

(use-package rainbow-delimiters
  :defer t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package olivetti
  :custom
  (olivetti-body-width 82)
  (olivetti-style nil)
  :bind ("C-c z" . olivetti-mode))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

(use-package which-key
  :straight nil
  :hook
  (after-init . which-key-mode))

(use-package savehist
  :straight nil
  :hook (after-init . savehist-mode))

(use-package vertico
  :defer t
  :commands vertico-mode
  :hook (after-init . vertico-mode))

(use-package marginalia
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

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

(use-package disproject
  :bind (("C-c p" . disproject-dispatch)))

(use-package project
  :custom
  (project-vc-extra-root-markers '("package.json")))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless partial-completion basic))
  (completion-category-defaults nil)
  (completion-category-overrides nil))

(use-package cape
  :init
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; Complete word from current buffers
  (add-to-list 'completion-at-point-functions #'cape-file) ;; Path completion
  (add-to-list 'completion-at-point-functions #'cape-elisp-block) ;; Complete elisp in Org or Markdown mode
  )

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

(use-package vundo
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))

(use-package magit
  :bind ("C-c g" . 'magit-status)
  :config
  (transient-replace-suffix 'magit-commit 'magit-commit-autofixup
    '("x" "Absorb changes" magit-commit-absorb)))

(use-package diff-hl
  :hook ((dired-mode         . diff-hl-dired-mode-unless-remote)
         (magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1)
  )

(use-package mise
  :hook (after-init . global-mise-mode)
  )

(use-package forge
  :after magit)

(use-package comment-dwim-2
  :bind
  ("M-;" . comment-dwim-2))

(use-package no-littering)

(use-package expreg
  :ensure t
  :bind (("C-=" . expreg-expand)
         ("C--" . expreg-contract)
         (:repeat-map expreg-repeat-map
                      ("=" .  expreg-expand)
                      ("-" .  expreg-contract)))
  )

(use-package tramp
  :custom
  (remote-file-name-inhibit-locks t)
  (tramp-use-scp-direct-remote-copying t)
  (remote-file-name-inhibit-auto-save-visited t))

(use-package tramp-rpc
  :straight (tramp-rpc :type git :host github :repo "ArthurHeymans/emacs-tramp-rpc")
  :custom
  (tramp-rpc-deploy-git-build-policy 'release))

(use-package smartparens
  :hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  (require 'smartparens-config)) 

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
  (lsp-ui-sideline-show-diagnostics nil)
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

(use-package flycheck
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error))
  :hook ((after-init . global-flycheck-mode)
         (after-init . global-flycheck-annotate-mode))
  :custom
  (flycheck-annotate-background t)
  (flycheck-annotate-other-lines-style nil)
  )

(use-package agent-shell)

(use-package apheleia
  :hook (prog-mode . apheleia-global-mode))

(use-package dart-mode
  :defer t
  :hook (dart-mode . flutter-test-mode))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  )

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

(use-package nix-mode
  :mode "\\.nix$")

(use-package kdl-mode
  :mode ("\\.kdl\\'"))

(use-package yaml-mode
  :defer t
  :mode (
         ("\\.yml\\'" . yaml-mode))
  )

(use-package fish-mode
  :defer t
  :mode (
         ("\\.fish\\'" . fish-mode))
  )

(use-package prisma-mode
  :straight (prisma-mode :type git :host github :repo "pimeys/emacs-prisma-mode"))

(use-package go-mode)

(use-package pdf-tools
  :init
  (pdf-tools-install)
  (pdf-loader-install)
  )

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

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

(use-package org-cliplink
  :defer t
  :commands (org-cliplink-capture))

;; Nicer list creation
(use-package org-autolist
  :hook (org-mode . org-autolist-mode))

(use-package org-caldav
  :custom
  (org-caldav-inbox "/Users/alex/persist/org/inbox.org")
  )

(use-package org-tempo
  :straight nil
  :after org
  :config
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  )

(use-package toc-org
  :commands toc-org-enable
  :hook (org-mode . toc-org-mode))

(use-package wordcloud
  :straight (wordcloud :type git :host github :repo "davep/wordcloud.el"))

(use-package elfeed
  :bind (("C-x e" . elfeed)
         :map elfeed-search-mode-map
         ("g" . 'elfeed-update)
         )
  :hook (elfeed-show-mode . olivetti-mode))

(use-package elfeed-protocol
  :custom
  (elfeed-protocol-fever-update-unread-only nil)
  (elfeed-protocol-fever-fetch-category-as-tag t)
  (elfeed-feeds '(("fever+https://alex@rss.mytbu.de"
                            :api-url "https://rss.mytbu.de/fever/"
                            :use-authinfo t)))
  :config
  (elfeed-protocol-enable))

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

(when is-work
  (use-package jira
    :custom
    (jira-base-url "https://dhl.atlassian.net")
    (jira-token-is-personal-access-token nil)
    (jira-api-version 3)))
