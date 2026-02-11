;; use a separate custom file to avoid clutter here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; package setup
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package '(modus-themes avy expand-region magit pdf-tools solarized-theme vterm corfu vertico orderless marginalia ace-window))
  (unless (package-installed-p package)
    (package-install package)))

;; basic UI/UX tweaks
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
;; (scroll-bar-mode -1)
(setq column-number-mode t)
(load-theme 'modus-vivendi-tinted t)

;; font (GUI only)
(when (display-graphic-p)
  (set-frame-font "JetBrains Mono-16" nil t))

;; disable mouse in GUI
(defun disable-mouse ()
  (interactive)
  (dolist (mouse-function '(mouse-set-point mouse-drag-region
                            mouse-set-point-and-stay mouse-yank-primary
                            mouse-scroll-up mouse-scroll-down))
    (global-unset-key (vector mouse-function))))
(add-hook 'window-setup-hook #'disable-mouse)

;; indentation
(setq-default tab-width 8)
(setq-default indent-tabs-mode t)

(add-hook 'c-mode-common-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq c-basic-offset 8)))
(add-hook 'c-mode-common-hook
          (lambda ()
            (setq comment-style 'extra-line
                  c-block-comment-prefix " * "
                  comment-start "/* "
                  comment-end   " */")))

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)))

;; vertico
(vertico-mode t)
(setq vertico-cycle t)
(with-eval-after-load 'vertico
  (require 'vertico-directory)
  (define-key vertico-map (kbd "RET")
    (lambda ()
      (interactive)
      (if (and (< vertico--index 0)
               (string-suffix-p "/" (minibuffer-contents-no-properties)))
          (vertico-next)
        (vertico-directory-enter))))
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
  (define-key vertico-map (kbd "M-DEL") #'vertico-directory-delete-word))
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

;; marginalia
(marginalia-mode t)

;; orderless
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

;; electric pair
(electric-pair-mode t)

;; avy config
(global-set-key (kbd "C-;") 'avy-goto-char-2)
(setq avy-all-windows 'all-frames)

;; ace-window
(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

;; Corfu
(setq corfu-auto t
      corfu-auto-prefix 2
      corfu-auto-delay 0.1
      corfu-quit-no-match 'separator)
(global-corfu-mode)

;; Elgot
(add-hook 'prog-mode-hook 'eglot-ensure)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '((c-mode c++-mode)
		 . ("clangd"
		    "--fallback-style=none"))))

;; expand-region keybindings
(global-set-key (kbd "C-'") 'er/expand-region)
(global-set-key (kbd "M--") 'er/contract-region)

;; Tramp config for remote editing
(setq tramp-default-method "ssh")
(setq tramp-auto-save-directory "/tmp")
(setq tramp-chunksize 2000)

;; native compilation
(setq native-comp-deferred-compilation t)

;; trailing-whitespace
(setq-default show-trailing-whitespace t)

;; highlight symbol at point
(defface symbol-highlight-face '((t :background "#C75B73"))
  "Custom face for highlighting symbols.")
(defvar highlight-overlays nil)
(defun remove-highlights ()
  (mapc #'delete-overlay highlight-overlays)
  (setq highlight-overlays nil))
(defun highlight-all-occurrences ()
  (remove-highlights)
  (let* ((sym (thing-at-point 'symbol t)))
    (when sym
      (save-excursion
        (let ((regex (concat "\\_<" (regexp-quote sym) "\\_>"))
              (win-start (window-start))
              (win-end (window-end)))
          (goto-char win-start)
          (while (re-search-forward regex win-end t)
            (let ((ov (make-overlay (match-beginning 0) (match-end 0))))
              (overlay-put ov 'face 'symbol-highlight-face)
              (push ov highlight-overlays))))))))
(defvar highlight-timer nil)
(defun start-highlight-timer ()
  (when highlight-timer (cancel-timer highlight-timer))
  (setq highlight-timer
        (run-with-idle-timer 1.5 nil #'highlight-all-occurrences)))
(defun refresh-highlights ()
  (remove-highlights)
  (start-highlight-timer))
(add-hook 'post-command-hook #'refresh-highlights)
