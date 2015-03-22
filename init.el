
;;; init.el --- elegantmush's custom Emacs initialization

;; Filename: init.el
;; Author: elegantmush <elegantmush@gmail.com>


;;; Commentary:
;;
;; This is the initialization file used to set up Emacs
;; with elegantmush's preferred defaults.

;;; Code:


;; Startup settings

(setq inhibit-startup-message t)
(add-to-list 'default-frame-alist '(height . 48))
(add-to-list 'default-frame-alist '(width . 160))
(setq-default ns-pop-up-frames nil)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
;; make whitespace-mode use just basic coloring
;(setq-default whitespace-style (quote (spaces tabs newline space-mark tab-mark newline-mark)))
(setq-default whitespace-display-mappings

       ;; all numbers are Unicode codepoint in decimal. try (insert-char 182 ) to see it
      '(
        (space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
        (newline-mark 10 [182 10]) ; 10 LINE FEED
        (tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
        ))
;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-c w") 'whitespace-mode)

;; Smarter text editing
(defun smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(global-set-key [(shift return)] 'smart-open-line)
(electric-indent-mode +1)
(electric-pair-mode +1)
(global-hl-line-mode +1)

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

;; Easy window navigation / transposition operations
(global-set-key "\M-o" 'other-window)
(require 'buffer-move)
(global-set-key (kbd "<C-s-up>")     'buf-move-up)
(global-set-key (kbd "<C-s-down>")   'buf-move-down)
(global-set-key (kbd "<C-s-left>")   'buf-move-left)
(global-set-key (kbd "<C-s-right>")  'buf-move-right)


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

;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)

(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")


;; speedbar
(require 'sr-speedbar)
(global-set-key (kbd "\C-c\ s") 'sr-speedbar-toggle)

;; ECB
(require 'ecb)
(require 'ecb-autoloads)
(setq ecb-compile-window-height 12)

;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)


;; Shell colours
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; IRC
(require 'erc)

; for ERC modules, these were set using M-x customize-variable RET erc-modules RET , and then "Apply and Save" ing.

(setq-default erc-log-channels-directory "~/.erc/logs/")
(setq-default erc-save-buffer-on-part t)
(setq-default erc-hide-timestamps t)

(defun gnutls-available-p ()
  "Function redefined in order not to use built-in GnuTLS support."
  nil)


;; All Programming languages
(add-hook 'prog-mode 'nlinum-mode)

;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)


;; Clojure
(require 'clojure-mode)
(require 'paredit)
(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'clojure-mode-hook 'linum-mode)

;(setq-default cider-popup-stacktraces nil)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
;(setq-default nrepl-hide-special-buffers t)
(setq-default cider-repl-print-length 25)

;; Leiningen
(setq-default exec-path (append exec-path '("/usr/local/bin")))

;; Non-Lisp Paredit hook
(add-hook 'prog-mode-hook 'paredit-everywhere-mode)

;; Java
(defun malabar-mode-bootstrap ()
  (require 'cedet)
  (require 'semantic)
  (load "semantic/loaddefs.el")
  (semantic-mode 1) ;;
  (require 'malabar-mode)
  (load "malabar-flycheck")
  (malabar-mode)
  (flycheck-mode))

(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode-bootstrap))

;; Python
(require 'ein)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:ac-setup)
(add-hook 'python-mode-hook 'nlinum-mode)

;; Markdown
(require 'markdown-mode)
(autoload 'gfm-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.text$" . gfm-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.md$" . gfm-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.mdown$" . gfm-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.mdt$" . gfm-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.markdown$" . gfm-mode) auto-mode-alist))

;; HTML
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.htm\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

;; JavaScript
(require 'js2-mode)
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq js2-highlight-level 3)

;; Gherkin
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\\.feature\\'" . feature-mode))


;; C
(require 'cc-mode)
(add-hook 'cc-mode-hook 'auto-complete-mode)
(add-hook 'cc-mode-hook 'paredit-everywhere-mode)
(setq-default c-basic-offset 4 c-default-style "linux")  ; alternatives are "gnu", "linux", "k&r"
(setq-default tab-width 4 indent-tabs-mode nil)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
(add-hook 'cc-mode-hook 'linum-mode)
(add-hook  'c-mode-hook 'nlinum-mode)

(require 'auto-complete-clang)
(define-key c++-mode-map (kbd "C-<space>-<return>") 'ac-complete-clang)
;; replace C-<space>-<return> with a key binding that you want



;; SET THROUGH M-x customize-variable RET <variable> RET
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(background-color "#202020")
 '(background-mode dark)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(cursor-color "#cccccc")
 '(custom-enabled-themes (quote (monokai)))
 '(custom-safe-themes
   (quote
    ("4e262566c3d57706c70e403d440146a5440de056dfaeb3062f004da1711d83fc" "1cd9defef2a98138c732728568b04043afd321eb802d25a254777de9b2463768" "dd4db38519d2ad7eb9e2f30bc03fba61a7af49a185edfd44e020aa5345e3dca7" "569dc84822fc0ac6025f50df56eeee0843bffdeceff2c1f1d3b87d4f7d9fa661" "2affb26fb9a1b9325f05f4233d08ccbba7ec6e0c99c64681895219f964aac7af" "ed5af4af1d148dc4e0e79e4215c85e7ed21488d63303ddde27880ea91112b07e" "885ef8634f55df1fa067838330e3aa24d97be9b48c30eadd533fde4972543b55" "fa942713c74b5ad27893e72ed8dccf791c9d39e5e7336e52d76e7125bfa51d4c" "0c311fb22e6197daba9123f43da98f273d2bfaeeaeb653007ad1ee77f0003037" "53e29ea3d0251198924328fd943d6ead860e9f47af8d22f0b764d11168455a8e" "573e46dadf8c2623256a164831cfe9e42d5c700baed1f8ecd1de0675072e23c2" "e6d83e70d2955e374e821e6785cd661ec363091edf56a463d0018dc49fbc92dd" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "e24180589c0267df991cf54bf1a795c07d00b24169206106624bb844292807b9" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(ecb-layout-name "left2")
 '(ecb-options-version "2.40")
 '(erc-modules
   (quote
    (autojoin button completion fill irccontrols list log match menu move-to-prompt netsplit networks noncommands notifications readonly ring stamp track)))
 '(fci-rule-color "#073642")
 '(foreground-color "#cccccc")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(linum-format "%3i")
 '(magit-diff-use-overlays nil)
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(powerline-color1 "#3d3d68")
 '(powerline-color2 "#292945")
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(sr-speedbar-right-side nil)
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c85d17")
     (60 . "#be730b")
     (80 . "#b58900")
     (100 . "#a58e00")
     (120 . "#9d9100")
     (140 . "#959300")
     (160 . "#8d9600")
     (180 . "#859900")
     (200 . "#669b32")
     (220 . "#579d4c")
     (240 . "#489e65")
     (260 . "#399f7e")
     (280 . "#2aa198")
     (300 . "#2898af")
     (320 . "#2793ba")
     (340 . "#268fc6")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here

