(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "gray85" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 125 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;;显示行号20:26 2014/10/18
 (global-linum-mode 1) 

(setq default-frame-alist '((height . 30) (width . 80)))
;; 15:48 2013/03/06

(defun to-dotemacs ()
  "swich to the buffer that can edit the file .emacs."
  (interactive)
  (find-file "~/.emacs"))

(global-set-key (kbd "C-x p") 'to-dotemacs)   ;; means profile.

;; 16:05 2013/03/06块注释
(global-set-key (kbd "C-c C-;") 'comment-region)
(global-set-key (kbd "C-c C-u") 'uncomment-region)


;; 14:33 2014/09/27buffer 切换
(global-set-key (kbd "C-c n") 'next-buffer)
(global-set-key (kbd "C-c p") 'previous-buffer)



;; 14:56 2014/09/27set mArk
(global-set-key (kbd "C-c a") 'set-mark-command)



(defun run-script-without-input ()
  "run current script that needn't input on shell command."
  (interactive)
  (save-buffer)
  (shell-command (concat "./"
			  (buffer-name))))

(global-set-key (kbd "C-x c") 'run-script-without-input)  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; - 12:03 2013/03/19


(fset 'enter-macro 
      [return])

(defun run-script-in-shell ()
  "run current script in a shell and it will not return back to current buffer."
  (interactive)
  (save-buffer)
  (let ((script-file (buffer-file-name)))
    (other-window 1)
    (shell)
    (insert "\"" script-file "\"")
    (execute-kbd-macro 'enter-macro)))

(global-set-key (kbd "C-c C-c") 'run-script-in-shell)
(global-set-key (kbd "C-c C-s") 'replace-string)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 12:39 2013/03/19


(defun insert-current-time ()
  "Print the current time and date."
  (interactive)
  (insert (format-time-string "%H:%M %Y/%m/%d" (current-time))))
(global-set-key (kbd "C-x t") 'insert-current-time)
;; (global-set-key [(f5)] 'insert-current-time) 

;;                                             16:58 2012/11/13

;;; Always do syntax highlighting
(global-font-lock-mode 1)

;;; Also highlight parens
(setq show-paren-delay 0
      show-paren-style 'parenthesis)
(show-paren-mode 1)

;; input the real tab  @ 14:29 2014/09/27
(global-set-key [C-tab] '(lambda () (interactive) (insert-char 9 1)))

;; ++++++++++++++++ cpp dev support ++++++++++++++++

(global-set-key [(f7)] 'compile)

;; Cedet
(require 'cedet)
(global-ede-mode t)

;;;;  Helper tools.
(custom-set-variables
 '(semantic-default-submodes (quote (global-semantic-decoration-mode global-semantic-idle-completions-mode
                                     global-semantic-idle-scheduler-mode global-semanticdb-minor-mode
                                     global-semantic-idle-summary-mode global-semantic-mru-bookmark-mode)))
 '(semantic-idle-scheduler-idle-time 3))

(semantic-mode)

;; smart complitions
(require 'semantic/ia)
(setq-mode-local c-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))
(setq-mode-local c++-mode semanticdb-find-default-throttle
                 '(project unloaded system recursive))

;;;; Include settings
(require 'semantic/bovine/gcc)
(require 'semantic/bovine/c)

(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public" "."
        "../.." "../../include" "../../inc" "../../common" "../../public"))

(setq cedet-sys-include-dirs (list
                              "/usr/include"
                              "/usr/include/bits"
                              "/usr/include/glib-2.0"
                              "/usr/include/gnu"
                              "/usr/include/gtk-2.0"
                              "/usr/include/gtk-2.0/gdk-pixbuf"
                              "/usr/include/gtk-2.0/gtk"
                              "/usr/local/include"
                              "/usr/local/include"))

(let ((include-dirs cedet-user-include-dirs))
  (setq include-dirs (append include-dirs cedet-sys-include-dirs))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))

(setq semantic-c-dependency-system-include-path "/usr/include/")

;;;; TAGS Menu
(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))

(add-hook 'semantic-init-hooks 'my-semantic-hook)

;;;; Semantic DataBase存储位置
(setq semanticdb-default-save-directory
      (expand-file-name "~/.emacs.d/semanticdb"))

;; 使用 gnu global 的TAGS。
(require 'semantic/db-global)
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)

;; (ede-cpp-root-project "Kernel"
;;                 :name "Kernel Project"
;;                 :file "~/Work/projects/kernel/linux-2.6.34/Makefile"
;;                 :include-path '("/"
;;                                 "/include"
;;                                )
;;                 :system-include-path '("/usr/include")    )

;;;;  缩进或者补齐
;;; hippie-try-expand settings
(setq hippie-expand-try-functions-list
      '(
        yas/hippie-try-expand
        semantic-ia-complete-symbol
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs))

(defun indent-or-complete ()
  "Complete if point is at end of a word, otherwise indent line."
  (interactive)
  (if (looking-at "\\>")
      (hippie-expand nil)
    (indent-for-tab-command)
    ))

(defun yyc/indent-key-setup ()
  "Set tab as key for indent-or-complete"
  (local-set-key  [(tab)] 'indent-or-complete)
  )

;;;; C-mode-hooks .
(defun yyc/c-mode-keys ()
  "description"
  ;; Semantic functions.
  (semantic-default-c-setup)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-cb" 'semantic-mrub-switch-tags)
  (local-set-key "\C-cR" 'semantic-symref)
  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cp" 'semantic-ia-show-summary)
  (local-set-key "\C-cl" 'semantic-ia-show-doc)
  (local-set-key "\C-cr" 'semantic-symref-symbol)
  (local-set-key "\C-c/" 'semantic-ia-complete-symbol)
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "." 'semantic-complete-self-insert)
  (local-set-key ">" 'semantic-complete-self-insert)
  ;; Indent or complete
  (local-set-key  [(tab)] 'indent-or-complete)
  )
(add-hook 'c-mode-common-hook 'yyc/c-mode-keys)


