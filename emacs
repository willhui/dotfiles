; Will's emacs configuration
;
; Notes:
; I've remapped ESC-ESC-ESC to a single ESC, but it's probably better to
; get used to C-g for backing out of a partially typed command.
;
; M-\ deletes horizontal space (useful for deleting all indentation up
; to the beginning of a line). Remember this since it is just below the
; backspace key.
;
; TODO:
; Predictive mode
; http://www.emacswiki.org/emacs/PredictiveMode
;
; Org-mode
; http://orgmode.org/
;
; AUCTeX
; http://www.gnu.org/software/auctex/
;
; Emacs Code Browser (ECB)
; http://ecb.sourceforge.net/


; ---------------------------------------------------------------------------
; General
; ---------------------------------------------------------------------------

; Add .emacs.d to the load-path.
(add-to-list 'load-path "~/.emacs.d")

; Both Alt and Windows keys should act as Meta.
(setq x-alt-keysym 'meta)
(setq x-super-keysym 'meta)
(setq mac-command-modifier 'meta)

; ESC key as modifier is retarded; rebind ESC-ESC-ESC to single escape
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)

; Merge emacs kill-ring with the system clipboard.
(setq x-select-enable-clipboard t)

; Consolidate backup files.
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
(setq delete-old-versions t)

; Make scripts executable on save.
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

; Preserve owner and group of file on save.
(setq backup-by-copying-when-mismatch t)

; Case insensitive filename completion.
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

; Prevent annoying "Active processes exist?" query on exit.
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  (flet ((process-list ())) ad-do-it))

; Ugly hack to fix up the PATH on Mac OS X (we want Python 2.6 instead of 2.5).
(when (equal system-type 'darwin)
  (setenv "PATH" (concat "~/bin:/usr/local/bin:" (getenv "PATH")))
  (push "/usr/local/bin" exec-path)
  (push "~/bin" exec-path))

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))


; ---------------------------------------------------------------------------
; GUI
; ---------------------------------------------------------------------------

; Enable mouse wheel.
(mouse-wheel-mode t)

; Mouse wheel scroll speed.
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3) ((control) . nil)))

; Do not progressively increase scroll speed as wheel scrolls faster.
(setq mouse-wheel-progressive-speed nil)

; Line-by-line scrolling.
(setq scroll-step 1)

; Show line numbers.
(require 'linum)
;(global-linum-mode)
(global-set-key (kbd "<f6>") 'linum-mode)

; Show line and column number in modeline.
(line-number-mode 1)
(column-number-mode 1)

; Set default font.
(add-to-list 'default-frame-alist '(font . "Inconsolata-12"))

; Hide splash screen.
(setq inhibit-splash-screen t)

; Hide menu bar and toolbar.
;(menu-bar-mode -1)
(tool-bar-mode -1)

; Disable alert bell.
(setq ring-bell-function 'ignore)

; Use bar cursor instead of block cursor.
(require 'bar-cursor)
(bar-cursor-mode 1)

; Delete selected region on backspace, C-d, or DEL.
(delete-selection-mode t)

; C-k deletes the newline character as well. This allows you
; to do C-a C-k C-y C-y to duplicate a line for editing.
(setq kill-whole-line t)


; ---------------------------------------------------------------------------
; Colors
; ---------------------------------------------------------------------------

; Set color theme.
(require 'color-theme)
(color-theme-initialize)

; Inkpot color theme
(defun color-theme-inkpot ()
  "Color theme based on the Inkpot theme. Ported and tweaked by Per Vognsen."
  (interactive)
  (color-theme-install
    '(color-theme-inkpot
       ((foreground-color . "#cfbfad")
	(background-color . "#1e1e27")
	(border-color . "#3e3e5e")
	(cursor-color . "#404040")
	(background-mode . dark))
       (region ((t (:background "#404040"))))
       (highlight ((t (:background "#404040"))))
       (fringe ((t (:background "#16161b"))))
       (show-paren-match-face ((t (:background "#606060"))))
       (isearch ((t (:bold t :foreground "#303030" :background "#cd8b60"))))
       (modeline ((t (:bold t :foreground "#b9b9b9" :background "#3e3e5e"))))
       (modeline-inactive ((t (:foreground "#708090" :background "#3e3e5e"))))
       (modeline-buffer-id ((t (:bold t :foreground "#b9b9b9" :background "#3e3e5e"))))
       (minibuffer-prompt ((t (:bold t :foreground "#708090"))))
       (font-lock-builtin-face ((t (:foreground "#c080d0"))))
       (font-lock-comment-face ((t (:foreground "#708090")))) ; original inkpot: #cd8b00
       (font-lock-constant-face ((t (:foreground "#506dbd"))))
       (font-lock-doc-face ((t (:foreground "#cd8b00"))))
       (font-lock-function-name-face ((t (:foreground "#87cefa"))))
       (font-lock-keyword-face ((t (:bold t :foreground "#c080d0"))))
       (font-lock-preprocessor-face ((t (:foreground "309090"))))
       (font-lock-reference-face ((t (:bold t :foreground "#808bed"))))
       (font-lock-string-face ((t (:foreground "#ffcd8b" :background "#404040"))))
       (font-lock-type-face ((t (:foreground "#ff8bff"))))
       (font-lock-variable-name-face ((t nil)))
       (font-lock-warning-face ((t (:foreground "#ffffff" :background "#ff0000")))))))

;(color-theme-andreas)
;(color-theme-charcoal-black)
(color-theme-inkpot)

; ---------------------------------------------------------------------------
; Autocompletion
; ---------------------------------------------------------------------------

(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")

; ---------------------------------------------------------------------------
; Indentation and whitespace
; ---------------------------------------------------------------------------

(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding
  point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))

(defun my-tab-fix ()
  (local-set-key [tab] 'indent-or-expand))
(defun my-ret-fix ()
  (local-set-key (kbd "RET") 'newline-and-indent))

; Default to tab characters.
(setq-default indent-tabs-mode t)


; ---------------------------------------------------------------------------
; C/C++/Java
; ---------------------------------------------------------------------------

(require 'cc-mode)
(global-set-key [(f9)] 'compile)

(defun my-c-mode-hook ()
  (my-tab-fix)
  (my-ret-fix)
  
  ; BSD indentation style
  (setq tab-width 4)
  (c-set-style "bsd")
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'case-label '+)
  (c-set-offset 'arglist-cont-nonempty '+)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'topmost-intro-cont '+)

  ; Consume all consecutive whitespace on Backspace or C-d.
  (c-toggle-hungry-state t))

(add-hook 'c-mode-common-hook 'my-c-mode-hook)

; Cross-referencing capabilities.
(require 'xcscope)


; ---------------------------------------------------------------------------
; Python
; ---------------------------------------------------------------------------

(defun my-python-mode-hook ()
  (my-tab-fix)
  (my-ret-fix)
  
  ; 4-space indent is standard in Python
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq standard-indent 4))

(add-hook 'python-mode-hook 'my-python-mode-hook)

(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))


; ---------------------------------------------------------------------------
; Clojure
; ---------------------------------------------------------------------------

; Use M-x swank-clojure-project to set the classpath appropriately.
; See http://github.com/technomancy/swank-clojure for more information.

(setq swank-clojure-library-paths (list "~/projects/octoshark/lib/native/"))

; Highlight matching parentheses
(setq show-paren-delay 0
      show-paren-style 'parenthesis)
(show-paren-mode 1)

(defun my-clojure-mode-hook ()
  (my-tab-fix)
  (my-ret-fix))

(add-hook 'clojure-mode-hook 'my-clojure-mode-hook)

; ---------------------------------------------------------------------------
; ErgoEmacs key bindings
; ---------------------------------------------------------------------------

; US keyboard layout.
(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "us")

; Load ErgoEmacs key bindings.
(load "~/.emacs.d/ergoemacs-keybindings-5.1/ergoemacs-mode")

; Turn on minor mode ergoemacs-mode.
(ergoemacs-mode 1)


; ---------------------------------------------------------------------------
; Session persistence
; ---------------------------------------------------------------------------

; Reopen files in the last place they were when previously visited.
(require 'saveplace)
(setq-default save-place t)

; Persist emacs desktop over multiple sessions. Perform this step as late
; as possible.
(desktop-save-mode t)

