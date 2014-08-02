;;; init.el --- elegantmush's custom Emacs initialization

;; Filename: init.el
;; Author: elegantmush <e@f.g>


;;; Commentary:
;;
;; This is the initialization file used to set up Emacs
;; with elegantmush's preferred defaults.

;;; Code:

;; Startup settings
(setq inhibit-startup-message t)
(add-to-list 'default-frame-alist '(height . 48))
(add-to-list 'default-frame-alist '(width . 140))

;; Package Manager - Add GNU, Marmalade and MELPA Repositories
(require 'package)
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; El-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))
(when (fboundp 'el-get) (el-get 'sync))

;; Recent Files
(recentf-mode 1)
(setq-default recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; Other window - rebind to easier key binding
(global-set-key "\M-o" 'other-window)

;; IDO
(ido-mode t)
(setq-default ido-enable-prefix nil
	      ido-enable-flex-matching t
	      ido-auto-merge-work-directories-length nil
	      ido-create-new-buffer 'always
	      ido-use-filename-at-point 'guess
	      ido-use-virtual-buffers t
	      ido-handle-duplicate-virtual-buffers 2
	      ido-max-prospects 10)

;; Display ido results vertically, rather than horizontally
(setq-default  ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-trucation () "Disable line truncation." (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)


;; ECB
(require 'ecb)
(require 'ecb-autoloads)


;; Theme
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)


;; Shell colours
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook 'nlinum-mode)


;; Clojure
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;(setq-default cider-popup-stacktraces nil)
;(add-hook 'cider-repl-mode-hook 'paredit-mode)
;(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
;(setq-default nrepl-hide-special-buffers t)
;(setq-default cider-repl-print-length 25)


;; Python
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:ac-setup)
(add-hook 'python-mode-hook 'nlinum-mode)

(provide 'init)
;;; init.el ends here
