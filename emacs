; Will's emacs configuration
;
; Notes:
; C-h b gets a list of all key bindings currently in effect.
;
; I've remapped ESC-ESC-ESC to a single ESC, but it's probably better to
; get used to C-g for backing out of a partially typed command.
;
; M-\ deletes horizontal space (useful for deleting all indentation up
; to the beginning of a line). Remember this since it is just below the
; backspace key.
;
; C-M-\ corrects the indentation for a block of code.
; C-space is supposed to be the command to select a region by keyboard.
; C-c-> adds an indentation level to the block of text
; C-c-< removes an indentation level from the block of text
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
;
; Collection of Emacs Development Environment Tools (CEDET)
; http://cedet.sourceforge.net/
;
; UndoTree
; http://www.emacswiki.org/emacs/UndoTree


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

(defun vi-open-line-above ()
  "Insert a newline above the current line and put point at beginning."
  (interactive)
  (unless (bolp)
    (beginning-of-line))
  (newline)
  (forward-line -1)
  (indent-according-to-mode))

(defun vi-open-line-below ()
  "Insert a newline below the current line and put point at beginning."
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent))

(global-set-key (kbd "C-<return>") 'vi-open-line-above)
(global-set-key (kbd "M-<return>") 'vi-open-line-below)



; ---------------------------------------------------------------------------
; Colors
; ---------------------------------------------------------------------------

; Set color theme.
(require 'color-theme)
(color-theme-initialize)

;(color-theme-andreas)
;(color-theme-charcoal-black)
(color-theme-xp)

; ---------------------------------------------------------------------------
; Autocompletion
; ---------------------------------------------------------------------------

(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")

; ---------------------------------------------------------------------------
; Indentation and whitespace
; ---------------------------------------------------------------------------

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
  (my-ret-fix)

  (setq tab-width 4)
  (c-set-style "stroustrup")

  ; Consume all consecutive whitespace on Backspace or C-d.
  (c-toggle-hungry-state t))

(add-hook 'c-mode-common-hook 'my-c-mode-hook)

; Cross-referencing capabilities.
(require 'xcscope)


; ---------------------------------------------------------------------------
; Python
; ---------------------------------------------------------------------------

(require 'pymacs)

(defun my-python-mode-hook ()
  (my-ret-fix)
  
  ; 4-space indent is standard in Python
  (setq c-set-style "python"))

(add-hook 'python-mode-hook 'my-python-mode-hook)

(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

; Load ropemacs on startup (slow).
;(pymacs-load "ropemacs" "rope-")

; Load ropemacs with 'C-x p l'
(defun load-ropemacs ()
  "Load pymacs and ropemacs"
  (interactive)
  (require 'pymacs)
  (pymacs-load "ropemacs" "rope-")
  ;; Automatically save project python buffers before refactorings
  (setq ropemacs-confirm-saving 'nil))
(global-set-key "\C-xpl" 'load-ropemacs)


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
  (my-ret-fix))

; Causes SLIME to be loaded on startup (slow).
;(add-hook 'clojure-mode-hook 'my-clojure-mode-hook)


; ---------------------------------------------------------------------------
; ErgoEmacs key bindings
; ---------------------------------------------------------------------------

; US keyboard layout.
(setenv "ERGOEMACS_KEYBOARD_LAYOUT" "us")

; Load ErgoEmacs key bindings.
;(load "~/.emacs.d/ergoemacs-keybindings-5.1/ergoemacs-mode")

; Turn on minor mode ergoemacs-mode.
;(ergoemacs-mode 1)


; ---------------------------------------------------------------------------
; Motion and kill DWIM
; ---------------------------------------------------------------------------
(require 'motion-and-kill-dwim)

(defun vim-forward-word (&optional n)
  "Emulate vim forward word movement: Skip to end of word or punctuation group, then skip over whitespace group.
With argument, do this that many times"
  (interactive "p")
  (setq zmacs-region-stays t)
  (makd-dotimes n '(progn
		     (cond
		       ((looking-at "[a-zA-Z0-9]") (skip-chars-forward "a-zA-Z0-9"))
		       ((looking-at "[^a-zA-Z0-9 \t\n]") (skip-chars-forward "^a-zA-Z0-9 \t\n")))
		     (when (looking-at "[ \t\n]") (skip-chars-forward " \t\n")))))


(defun vim-backward-word (&optional n)
  "Emulate vim backward word movement: Skip over whitespace group, then skip to beginning of word or punctuation group.
With argument, do this that many times"
  (interactive "p")
  (setq zmacs-region-stays t)
  (makd-dotimes n '(progn
		     (when (looking-back "[ \t\n]") (skip-chars-backward " \t\n"))
		     (cond
		       ((looking-back "[a-zA-Z0-9]") (skip-chars-backward "a-zA-Z0-9"))
		       ((looking-back "[^a-zA-Z0-9 \t\n]") (skip-chars-backward "^a-zA-Z0-9 \t\n"))))))

(defun vim-forward-kill-word (&optional n)
  "Smart kill forward.
1. If region is active, kill it
2. Else if at the beginning of a word, kill the word and trailing whitespace
3. Else if in the middle of a word, kill the rest of the word
4. Else if looking at whitespace, kill whitespace forward
5. Else if looking at punctuation, kill punctuation forward
6. Else kill next char
With argument, do this that many times"
  (interactive "p")
  (if (makd-mark-active)
      (kill-region (region-beginning) (region-end))
    (makd-dotimes n '(kill-region (point)
                                  (progn
                                    (cond ((looking-at "\\<\\(\\sw\\|\\s_\\)")
                                           (skip-syntax-forward "w_")
                                           (skip-syntax-forward " "))
                                          ((looking-at "\\(\\sw\\|\\s_\\)")
                                           (skip-syntax-forward "w_"))
                                          ((looking-at "\\s ")
                                           (skip-syntax-forward " "))
                                          ((looking-at "\\s.")
                                           (skip-syntax-forward "."))
                                          (t
                                           (forward-char)))
                                    (point))))))

(defun vim-backward-kill-word (&optional n)
  "Smart kill backward.
1. If region is active, kill it
2. Else if looking back at whitespace, kill backward whitespace and word
3. Else if in the middle of a word, kill backward word
4. Else if looking at punctuation, kill backward punctuation
5. Else kill previous char
With argument, do this that many times"
  (interactive "p")
  (if (makd-mark-active)
      (kill-region (region-beginning) (region-end))
    (makd-dotimes n '(kill-region (point)
                                  (progn
                                    (cond ((looking-back "\\s ")
                                           (skip-syntax-backward " ")
                                           (when (looking-back "\\(\\sw\\|\\s_\\)")
                                             (skip-syntax-backward "w_")))
                                          ((looking-back "\\(\\sw\\|\\s_\\)\\>")
                                           (skip-syntax-backward "w_")
                                           (unless (looking-back "^\\s +")
                                             (skip-syntax-backward " ")))
                                          ((looking-back "\\(\\sw\\|\\s_\\)")
                                           (skip-syntax-backward "w_"))
                                          ((looking-back "\\s.")
                                           (skip-syntax-backward "."))
                                          (t
                                           (backward-char)))
                                    (point))))))

(global-set-key (kbd "M-f") 'vim-forward-word)
(global-set-key (kbd "M-b") 'vim-backward-word)
(global-set-key (kbd "M-d") 'vim-forward-kill-word)
(global-set-key (kbd "M-<backspace>") 'vim-backward-kill-word)
(global-set-key (kbd "C-<backspace>") 'vim-backward-kill-word)

(global-set-key (kbd "M-u") 'backward-char)
(global-set-key (kbd "M-o") 'forward-char)
(global-set-key (kbd "M-j") 'vim-backward-word)
(global-set-key (kbd "M-l") 'vim-forward-word)
(global-set-key (kbd "M-i") 'previous-line)
(global-set-key (kbd "M-k") 'next-line)


(add-hook 'c-mode-hook
 (lambda () (define-key c-mode-map (kbd "M-j") 'vim-backward-word)))
(add-hook 'c++-mode-hook
 (lambda () (define-key c++-mode-map (kbd "M-j") 'vim-backward-word)))

; ---------------------------------------------------------------------------
; Snippets (TextMate-style)
; ---------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/packages")
(require 'yasnippet-bundle)


; ---------------------------------------------------------------------------
; Interactive-Do
; ---------------------------------------------------------------------------
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)


; ---------------------------------------------------------------------------
; Breadcrumbs
; ---------------------------------------------------------------------------

(require 'breadcrumb)
(global-set-key (kbd "S-SPC") 'bc-set)    ; set breadcrumb
(global-set-key (kbd "C-<left>") 'bc-previous)
(global-set-key (kbd "C-<right>") 'bc-next)
(global-set-key (kbd "C-<up>") 'bc-list)


; ---------------------------------------------------------------------------
; Natural text caret (emacs point) positioning on mouse click
; ---------------------------------------------------------------------------
(defun closer-goto-char (posn)
  (let ((x (car (posn-object-x-y posn)))
	(w (car (posn-object-width-height posn))))
    (goto-char (+ (posn-point posn)
		  (if (and (>= x (/ w 2)) (< x w)) 1 0)))))


(defun mouse-set-point (event)
  "Move point to the position clicked on with the mouse.
This should be bound to a mouse click event type."
  (interactive "e")
  (mouse-minibuffer-check event)
  ;; Use event-end in case called from mouse-drag-region.
  ;; If EVENT is a click, event-end and event-start give same value.
  (let ((posn (event-end event)))
    (select-window (posn-window posn))
    (if (numberp (posn-point posn))
	(closer-goto-char posn))))

; ---------------------------------------------------------------------------
; Session persistence
; ---------------------------------------------------------------------------

(setq auto-save-default nil)

; Reopen files in the last place they were when previously visited.
(require 'saveplace)
(setq-default save-place t)

; Persist emacs desktop over multiple sessions. Perform this step as late
; as possible.
(desktop-save-mode t)

