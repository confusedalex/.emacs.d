(require 'package)

(require 'use-package-ensure) ;; Load use-package-always-ensure
(setq use-package-always-ensure t) ;; Always ensures that a package is installed
(setq package-archives '(("melpa" . "https://melpa.org/packages/") ;; Sets default package repositories
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/") ;; For Eat Terminal
                         ))

(use-package emacs
  :init
  (tool-bar-mode -1)                              ;; Disable the tool bar
  (menu-bar-mode -1)                              ;; Disable the menu bar 
  (scroll-bar-mode -1)                            ;; Disable the scroll bar

  :custom                      
  (auto-save-default nil)                         ;; Disable automatic saving of buffers.
  (make-backup-files nil)                         ;; Don't create backup files!
  (delete-by-moving-to-trash t)                   ;; Move deleted files to the trash instead of permanently deleting them.
  (delete-selection-mode 1)                       ;; Enable replacing selected text with typed text.
  (inhibit-startup-message t)                     ;; Disable the startup message when Emacs launches.
  (tab-always-indent 'complete)                   ;; Make the TAB key complete text instead of just indenting.
  
  (display-line-numbers-type 'visual)             ;; Use relative line numbering in programming modes.
  (global-display-line-numbers-mode 1)            ;; display line numbers
  (gc-cons-threshold 100000000 t)                 ;; increase performance
  (use-short-answers t)                           ;; y/n instead of yes/no
  (global-auto-revert-mode t)                     ;; automatically reload files

  (indent-tabs-mode nil)
  (tab-width 4)

  :bind
  ("C-+" . text-scale-increase)
  ("C--" . text-scale-decrease)
  ("C-_" . text-scale-decrease)
  ("<C-wheel-up>" . text-scale-increase)
  ("<C-wheel-down>" . text-scale-decrease)
  )

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

(set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 110)

(load-theme 'modus-vivendi-tinted t)

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package which-key
  :ensure nil     
  :defer t        
  :hook
  (after-init . which-key-mode)) ;; Enable which-key mode after initialization.

(use-package rainbow-delimiters
  :defer t
  :hook
  (prog-mode . rainbow-delimiters-mode))

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

(use-package vertico
  :defer t
  :commands vertico-mode
  :hook (after-init . vertico-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package marginalia
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  (completion-styles '(orderless partial-completion basic))
  (completion-category-defaults nil)
  (completion-category-overrides nil))

(use-package embark
  :defer t
  :commands (embark-act
             embark-dwim
             embark-export
             embark-collect
             embark-bindings
             embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :defer t
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :init
  ;; Enhance register preview with thin lines and no mode line.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult for xref locations with a preview feature.
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

(use-package olivetti
  :defer t
  :commands (olivetti-mode)
  :custom
  (olivetti-body-width 130)
)

(use-package auto-olivetti
  :vc (:url "https://git.sr.ht/~ashton314/auto-olivetti")
  :config
  (auto-olivetti-mode))

(defvar-keymap prefix-find-files-map
  :doc "Find Files"
  "/" 'consult-line
  "C" 'consult-git-grep
  "c" #'(lambda() (interactive)(find-file "~/.emacs.d/config.org"))
  "f" 'consult-fd
  "g" 'consult-ripgrep
  "h" 'consult-info
  "r" 'consult-recent-file
  "t" 'consult-theme
) 

(defvar-keymap prefix-org-map
  :doc "Org mode keys"
  "a" 'org-agenda
  "c" 'org-capture
  "e" 'org-export-dispatch

  ;; Files
  "h" '(lambda() (interactive)(find-file "~/persist/org/hardware.org"))
  "j" '(lambda() (interactive)(find-file "~/persist/org/journal.org"))
  "n" '(lambda() (interactive)(find-file "~/persist/org/notes.org"))
  "w" '(lambda() (interactive)(find-file "~/persist/org/work.org"))
  )

(defvar-keymap prefix-mode-map
  "A" 'org-archive-subtree-default
  "e" 'org-export-dispatch
  "f" 'consult-org-heading
  "h" 'org-toggle-heading
  "n" 'org-store-link
  "o" 'org-set-property
  "r" 'org-refile
  "t" 'org-todo
  
  ;; Org tables
  "b d c" 'org-table-delete-column
  "b d r" 'org-table-delete-row

  ;; Org dates
  "d d" 'org-deadline
  "d s" 'org-schedule
  "d t" 'org-time-stamp
  "d T" 'org-time-stamp-inactive

  ;; Org subtree
  "s n" 'org-narrow-to-subtree
  "s N" 'widen
  "s r" 'org-refile
  "s S" 'org-sort
  )

(defvar-keymap prefix-magit-map
  :doc "Magit keybindings for Git integration"
  "g" 'magit-status      ;; Open Magit status
  "d" 'magit-diff-buffer-file ;; Show diff for the current file
  "D" 'diff-hl-show-hunk ;; Show diff for a hunk
  "b" 'vc-annotate       ;; Annotate buffer with version control info
)

(defvar-keymap prefix-dired-map
  :doc "Dired commands for file management"
  "d" 'dired
  "j" 'dired-jump
  "f" 'find-file
  )

(defvar-keymap prefix-project-map
  :doc "Project management keybindings"
  "b" 'consult-project-buffer ;; Consult project buffer
  "p" 'project-switch-project ;; Switch project
  "f" 'project-find-file ;; Find file in project
  "g" 'project-find-regexp ;; Find regexp in project
  "k" 'project-kill-buffers ;; Kill project buffers
  "D" 'project-dired ;; Dired for project
)

(defvar-keymap prefix-buffer-map
  :doc "Buffer management keybindings"
  "b" 'ibuffer ;; Open Ibuffer
  "d" 'kill-current-buffer ;; Kill current buffer
  "i" 'consult-buffer ;; Open consult buffer list
  "k" 'kill-current-buffer ;; Kill current buffer
  "l" 'consult-buffer ;; Consult buffer
  "s" 'save-buffer ;; Save buffer
  "x" 'kill-current-buffer ;; Kill current buffer
  )

(defvar-keymap prefix-compute-map
  :doc "Compute"
  "b r" 'elisp-eval-region-or-buffer ;; Reload config
  "f" 'format-all-buffer ;; Formatter
  "a" 'eglot-code-actions ;; Code actions
  "r" 'eglot-rename ;; rename symbol
  "i" 'eglot-inlay-hints-mode ;; Toggles inlay hints
  )

(defvar-keymap spc-prefix-map
  :doc "My prefix key map."
  "b" prefix-buffer-map
  "c" prefix-compute-map
  "f" prefix-find-files-map
  "g" prefix-magit-map
  "m" prefix-mode-map
  "o" prefix-org-map
  "p" prefix-project-map
  "x" prefix-dired-map
  )

(which-key-add-keymap-based-replacements spc-prefix-map
  "f" `("find files" . ,prefix-find-files-map))

(use-package corfu
  :after orderless
  :defer t
  :commands (corfu-mode global-corfu-mode)
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode))
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([ tab ] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous))
  :custom
  (corfu-cycle t)           ;; Enable cycling for `corfu-next/previous'
  (corfu-preselect 'prompt) ;; Always preselect the prompt
  (corfu-auto t)            ;; Enables auto-completion
  (corfu-popupinfo-mode t)  ;; Enable popup information
  (corfu-auto-delay 0.1)    ;; lower delay for completion
  
  (completion-ignore-case t)

  (text-mode-ispell-word-completion nil) ;; Disable Ispell completion
  
  :config
  (global-corfu-mode))

(use-package cape
  :defer t
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  ;; The functions that are added later will be the first in the list
  
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible)

  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; Complete word from current buffers
  (add-to-list 'completion-at-point-functions #'cape-dict) ;; Dictionary completion
  (add-to-list 'completion-at-point-functions #'cape-file) ;; Path completion
  (add-to-list 'completion-at-point-functions #'cape-elisp-block) ;; Complete elisp in Org or Markdown mode
  (add-to-list 'completion-at-point-functions #'cape-keyword) ;; Keyword/Snipet completion

  ;; (add-to-list 'completion-at-point-functions #'cape-abbrev) ;; Complete abbreviation
  (add-to-list 'completion-at-point-functions #'cape-history) ;; Complete from Eshell, Comint or minibuffer history
  ;; (add-to-list 'completion-at-point-functions #'cape-line) ;; Complete entire line from current buffer
  ;; (add-to-list 'completion-at-point-functions #'cape-elisp-symbol) ;; Complete Elisp symbol
  ;; (add-to-list 'completion-at-point-functions #'cape-tex) ;; Complete Unicode char from TeX command, e.g. \hbar
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml) ;; Complete Unicode char from SGML entity, e.g., &alpha
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345) ;; Complete Unicode char using RFC 1345 mnemonics
  )

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode))

(use-package flycheck
  :bind (:map flycheck-mode-map
              ("M-n" . flycheck-next-error)
              ("M-p" . flycheck-previous-error))
  :hook (prog-mode . flycheck-mode)
  )

(use-package lsp-mode
  :commands lsp lsp-deferred
  :defer t
  :init
  (setq lsp-use-plists t)
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

(use-package lsp-eslint
  :ensure nil
  :after lsp-mode)

(use-package lsp-biome
  :vc (:url "https://github.com/cxa/lsp-biome")
  :custom
  (lsp-biome-format-on-save t)
  )

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package format-all
  :defer t
  :commands format-all-mode
  :hook (prog-mode . format-all-mode))

(use-package smartparens
  :hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  (require 'smartparens-config))

(use-package magit
  :defer t
  :commands (magit-status magit-diff-buffer-file))

(use-package diff-hl
  :hook ((dired-mode         . diff-hl-dired-mode-unless-remote)
         (magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :init (global-diff-hl-mode))

(use-package org
  :defer t        ;; Defer loading Org-mode until it's needed.
  :hook
  ((org-mode . org-indent-mode)
   (org-mode . visual-line-mode))
  :custom
  (org-directory "~/persist/org/")
  (org-agenda-files (list org-directory))
  (org-ellipsis "⤵")
  
  (org-fold-catch-invisible-edits 'error) ;; error when editing in not folded area

  (global-hi-lock-mode 1)
  (org-todo-keywords
   '((sequence
      "TODO(t)"  ; A task that needs doing & is ready to do
      "STRT(s)"  ; A task that is in progress
      "WAIT(w@/!)"  ; Something external is holding up this task
      "IDEA(i)"  ; An unconfirmed and unapproved task or notion
      "NEXT(n)"  ; Item that can be worked on right now
      "|"
      "DONE(d)"  ; Task successfully completed
      "KILL(k@)")) ; Task was cancelled, aborted, or is no longer applicable
   )
  (org-log-done 'time) ; Add timestamp when a task is closed
  (org-log-into-drawer t) ;; Log changes into a drawer, so it wont clutter up my entry

  (org-extend-today-until 4) ;; my day ends at 03:00, you have to love org mode for this

  (org-agenda-start-on-weekday nil) ; We don't need to start on a weekday, do we?

  (org-agenda-tags-todo-honor-ignore-options t) ;; Don't show scheduled items which are already shown on the agenda
  (org-agenda-skip-schedulded-if-done t) ;; Don't show schedulded items, if done
  (org-agenda-skip-deadline-if-done t) ;; Don't show deadlined items, if done
  (org-agenda-todo-ignore-scheduled 'all) ;; Don't show schedulded dates in global TODO list
  (org-agenda-todo-ignore-deadlines 7) ;; Don't show deadlines that are more than 7 days away

  (org-agenda-time-grid
   '((today require-timed remove-match)
     (000 1200 1600 2400)
     "  " "┈┈┈┈┈┈┈┈┈┈┈┈┈"))
  (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈┈ now")
  (org-agenda-sort-notime-is-late nil) ;; Show timestamps with no time first

  (org-agenda-window-setup 'current-window)

  (org-return-follows-link t)

  (org-export-with-toc nil)
  
  (org-hide-leading-stars t)
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
     ("@uni" . ?U)
     ("@school" . ?S)

     ;; Devices
     ("@computer" . ?C)
     ("@phone" . ?P)

     ;; Activities
     ("@planning" . ?n)
     ("@programming" . ?p)
     ("@email" . ?e)
     ("@shopping" . ?g)
     ("@calls" . ?a)
     ("@errands" . ?r))
   )
  )

(use-package calfw)
(use-package calfw-org)

(use-package org
  :custom
  (org-archive-location "~/persist/org/archive.org::datetree/")
  )

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
        ("j" "Journal entry" entry (file+datetree "journal.org") "* %(format-time-string \"%H:%M\") \n%?")
        ("J" "Journal entry (Prompt)" entry (file+datetree+prompt "journal.org") "* %(format-time-string \"%H:%M\") \n%?")
	    ("b" "Bookmark" entry (file+headline "notes.org" "Bookmarks")
	     "* %(org-cliplink-capture) \n:PROPERTIES:\n:CREATED: %U\n:END:\n")
        ("e" "Email capture" entry (file+headline "notes.org" "Inbox") "* TODO %a")
	    ("a" "Appointment" entry (file+headline "notes.org" "Events") "* %? %^t")
        ("w" "Weight" table-line ( id "e0957b0e-d05e-485d-ad0a-e769287a5fe6" ) " | %^u | %^{Gewicht} |" :prepend t)
        )
      )

(use-package org-super-agenda
  :after org-agenda
  :defer t
  :config
  (defvar common-todo-groups
	'((:name "Important"
			 :tag "Important"
			 :priority "A"
			 :order 6)
	  (:name "Due Today"
			 :deadline today
			 :order 2)
	  (:name "Due Soon"
			 :deadline future
			 :order 8)
	  (:name "Overdue"
			 :deadline past
			 :face error
			 :order 7)
	  (:name "Started"
			 :todo "STRT"
			 :order 10)
	  (:name "Waiting"
			 :todo "WAIT"
			 :order 10)))
  (defvar work-files '("/home/alex/persist/org/work.org" "/home/alex/persist/org/google-calendar.org"))
  :custom
  (org-super-agenda-header-map nil)
  (org-super-agenda-mode t)
  (org-agenda-custom-commands
   '(
     ("fd" "Today"
	  ((agenda "" ((org-agenda-span 'day)))
	   (todo "" ((org-agenda-overriding-header "")
                 (org-super-agenda-groups
                  (append common-todo-groups
					      '((:name "Shopping"
						           :tag "@shopping"
						           :order 19)
                            (:name "Reading"
						           :todo "READING"
						           :order 20)
					        ))))))
	  ((org-agenda-tag-filter-preset '("-gifts"))))
     ("fw" "Week"
	  ((agenda "" ((org-agenda-span 'week)))
	   (todo "" ((org-agenda-overriding-header "")
                 (org-super-agenda-groups
                  (append common-todo-groups
					      '((:name "Shopping"
						           :tag "@shopping"
						           :order 19)
                            (:name "Reading"
						           :todo "READING"
						           :order 20)
					        ))))))
	  ((org-agenda-tag-filter-preset '("-gifts"))))
     ("pd" "private day"
	  ((agenda "" ((org-agenda-span 'day)))
	   (todo "" ((org-agenda-overriding-header "")
                 (org-super-agenda-groups
                  (append common-todo-groups
					      '((:name "Shopping"
						           :tag "@shopping"
						           :order 19)
                            (:name "Reading"
						           :todo "READING"
						           :order 20)
					        ))))))
	  ((org-agenda-tag-filter-preset '("-@work" "-gifts"))))
	 ("pw" "private week"
	  ((agenda "" ((org-agenda-span 7)))
	   (todo "" ((org-agenda-overriding-header "")
                 (org-super-agenda-groups
                  (append common-todo-groups
					      '((:name "People"
						           :tag "people"
						           :order 19)
					        (:name "Tech"
						           :tag "tech"
						           :order 19)
					        ))))))
	  ((org-agenda-tag-filter-preset '("-@work" "-gifts"))))
     ("wd" "work today"
	  ((agenda "" ((org-agenda-files work-files)
                   (org-agenda-span 'day)))
	   (todo "" ((org-agenda-overriding-header "")
                 (org-agenda-files work-files)
                 (org-super-agenda-groups
                  common-todo-groups)))))
     ("ww" "work week"
	  ((agenda "" ((org-agenda-files work-files)
                   (org-agenda-span 'week)))
	   (todo "" ((org-agenda-overriding-header "")
                 (org-agenda-files work-files)
                 (org-super-agenda-groups
                  common-todo-groups)))))
     ("g" "gifts"
	  ((tags-todo "+gifts" ((org-super-agenda-groups '((:auto-outline-path t))))))
	  )
     )
   )
  )

(use-package toc-org
  :commands toc-org-enable
  :hook (org-mode . toc-org-mode))

(use-package org-tempo
  :ensure nil
  :after org
  :config
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  )

(use-package ob-python :ensure nil)

(use-package org
  :config
  (setq org-confirm-babel-evaluate nil) ;; don't ask for permission to run
  (setq org-src-window-setup 'current-window)
  (setq org-edit-src-persistent-message nil)
  (setq org-src-fontify-natively t)
  (setq org-src-preserve-indentation t) ; use the indentation of the major mode
  (setq org-src-tab-acts-natively t)
  (setq org-edit-src-content-indentation 0))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((plantuml . t)))

;; (use-package org-caldav
;;   :vc (:url "https://github.com/confusedalex/org-caldav.git"
;; 	    :rev :newest :branch "fix-tags"
;; 	    )
;;   :custom
;;   (org-caldav-url "https://cloud.mytbu.de/remote.php/dav/calendars/alex")
;;   (org-caldav-calendar-id "orgmode")
;;   (org-caldav-inbox "~/persist/org/events.org")
;;   (org-caldav-files '("~/persist/org/notes.org"))
;;   (org-icalendar-timezone "Europe/Berlin")
;;   (org-caldav-select-tags '("calendar"))
;;   (org-caldav-save-directory "~/persist/org/")
;;   )

(use-package gnuplot)

(use-package nix-ts-mode
  :mode "\\.nix\\'")

(use-package dart-mode
  :defer t
  :hook (dart-mode . flutter-test-mode))

(use-package flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  ;; :custom
  ;; (flutter-sdk-path "/Applications/flutter/")
  )

(use-package kdl-mode
  :mode ("\\.kdl\\'"))

(use-package web-mode
  :defer t
  :hook (web-mode . lsp-deferred)
  :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.php\\'" . web-mode)
   ("\\.tpl\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.vue\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)))

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

(use-package go-mode)

(use-package pdf-tools
  :init
  (pdf-tools-install))

(use-package auctex
  :config
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-PDF-mode t)
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  )
(use-package cdlatex)
(use-package reftex)

(use-package evil
  :init
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :hook (after-init . evil-mode)
  :custom
  (evil-want-C-u-scroll t)
  (evil-undo-system 'undo-redo)
  ;; Set the leader key to space for easier access to custom commands.
  (evil-want-leader t)
  (evil-leader/in-all-states t)  ;; Make the leader key available in all states.
  (evil-want-fine-undo t)        ;; Evil uses finer grain undoing steps
  :config

  (evil-define-key '(normal motion visual) 'global
    (kbd "RET") nil ; unset RET to use with org-return-follows-link
    (kbd "SPC") spc-prefix-map
    )

  (global-unset-key (kbd "M-H"))
  )

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil-collection
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after (evil org)
  :config (evil-commentary-mode 1)
  )

(use-package evil-matchit
  :after evil-collection
  :config
  (global-evil-matchit-mode 1))

(use-package evil-org
  :after org
  :hook
  (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
