;; add ~/emacs to load-path
(add-to-list 'load-path "~/emacs")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-fill-mode t)
 '(blink-cursor-mode t)
 '(case-fold-search t)
 '(column-number-mode t)
 '(cua-mode nil nil (cua-base))
 '(default-tab-width 4 t)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-mode t)
 '(global-font-lock-mode t)
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(icomplete-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(jde-help-docsets (quote (("JDK API" "/opt/jdk1.7.0_07/docs/api" nil))))
 '(jde-jdk-registry (quote (("1.7.0_07" . "/opt/jdk1.7.0_07"))))
 '(kill-whole-line t)
 '(line-number-mode t)
 '(menu-bar-mode t)
 '(mouse-yank-at-point t)
 '(scroll-bar-mode nil)
 '(scroll-conservatively 10000)
 '(scroll-margin 3)
 '(scroll-step 1)
 '(show-paren-mode t)
 '(show-paren-style (quote parenthesis))
 '(speedbar-default-position (quote left))
 '(tool-bar-mode nil)
 '(transient-mark-mode t)
 '(uniquify-buffer-name-style (quote forward)))
;; no yes-or-not, just y-or-n
(defalias 'yes-or-no-p 'y-or-n-p)

;; color-theme
(add-to-list 'load-path "~/emacs/color-theme")
(require 'color-theme)
(color-theme-deep-blue)

;; set title name
(setq frame-title-format
      '((:eval
         (funcall
          (lambda ()
            (if buffer-file-name
                (concat
                 (directory-file-name
                  (file-name-directory buffer-file-name))
                 "/"
                 (file-name-nondirectory buffer-file-name)
                 )
              (buffer-name)))))))

;; input method
(add-to-list 'load-path "~/emacs/wubi")
(require 'wubi)
(register-input-method "chinese-wubi" "chinese-gbk" 'quail-use-package
					   "WuBi" "WuBi" "wubi")
(setq default-input-method 'chinese-wubi)

;; universal charset auto detector
(require 'unicad)
(setq file-name-coding-system 'utf-8)
(setq-default coding-system-history '("utf-8" "gb2312" "latin-2" "latin-1" "gbk"))

;; emms
(add-to-list 'load-path "~/emacs/emms/")
(add-to-list 'load-path "~/emacs/emms/lisp")
(require 'emms-setup)
(emms-standard)
(emms-default-players)

;; sdcv
(require 'sdcv)
(require 'init-sdcv)

(require 'ibuffer)
(require 'ido)
(ido-mode t)
'(ido-ignore-buffers (quote ("\\` " "\\`\\*info\\*" "\\`\\*Shell Command Output\\*" "\\`\\*Completions\\*")))


;; short cut
(global-set-key [(f1)] 'other-window)
(global-set-key [(meta g)] 'goto-line)
(global-set-key (kbd "C-o") 'vi-open-next-line)
(global-set-key "%" 'match-paren)
(global-set-key (kbd "C-c d") 'sdcv-search-pointer)

(defun vi-open-next-line (arg)
  "Move to the next line (like vi) and then opens a line."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (indent-according-to-mode))

(defun dos2unix ()
  "dos2unix on current buffer."
  (interactive)
  (set-buffer-file-coding-system 'unix))
 
(defun unix2dos ()
  "unix2dos on current buffer."
  (interactive)
  (set-buffer-file-coding-system 'dos))

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;;;;;test whether page is useful
  
;;;;;;;;;end test
;; kill buffer
(setq buffer-to-delete '("\*Shell Command Output\*" "\*Completions\*" "\*Backtrace\*" "\*cscope\*"))
(run-at-time "1" 20
             (lambda ()
               (mapcar (lambda (buffer)
                         (interactive)
                         (if (get-buffer buffer)
                             (if (not (get-buffer-window buffer))
                                 (kill-buffer buffer)
                               )
                           )
                         )
                       buffer-to-delete
                       )
               )
             )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;programming
;; short cut
(global-set-key (kbd "M-o") 'eassist-switch-h-cpp)
(global-set-key (kbd "M-m") 'eassist-list-methods)
(global-set-key  [(f7)]    'compile)
(global-set-key  [(f8)]    'ediff-revision)
(global-set-key [f12] 'semantic-ia-fast-jump)
(global-set-key [(shift f12)]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))
;(define-key c-mode-base-map [M-S-f12] 'semantic-analyze-proto-impl-toggle)                
;; get next error
(global-set-key [(f4)]    'next-error)

;; get previous error
(global-set-key [(shift f4)]    'previous-error)

;; auto complete
(add-to-list 'load-path "~/emacs/auto-complete-1.3.1")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/emacs/auto-complete-1.3.1/dict")
(ac-config-default)

;; cedet
(add-to-list 'load-path "~/emacs/cedet-1.1")
(load-file "~/emacs/cedet-1.1/common/cedet.el")
(require 'cedet)
(require 'semantic-ia)
(semantic-load-enable-guady-code-helpers)
;(semantic-decoration-mode nil)

(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))
(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))
;; eassist
(load-file "~/emacs/eassist.el")

;; version control -- git
(add-to-list 'load-path "~/emacs/magit")
(require 'magit)

(require 'psvn)

(require 'xcscope)
(setq cscope-database-regexps
      '(( "" 
          (t)
          t
          ("~/cscope" ("-d" "-I/usr/include"))
          )
        )
      )
;; find cscope.out from cscope-initial-directory
(setq cscope-initial-directory "~/cscope")

(add-hook 'gdb-mode-hook
          (lambda ()
            (local-set-key (kbd "<f9>") 'gud-break)
            (local-set-key (kbd "S-<f9>") 'gud-remove)
            (local-set-key (kbd "<f5>") 'gud-cont)
            (local-set-key  (kbd "<f10>") 'gud-next)
            (local-set-key  (kbd "<f11>") 'gud-step)
            (local-set-key  (kbd "S-<f11>") 'gud-finish)
            )
          )



;;view code, jump to function defination



;;gdb setting
(add-hook 'gud-mode 'linux-gud-mode)



(defun my-indent-or-complete ()
   (interactive)
   (if (looking-at "\\>")
 	  (hippie-expand nil)
 	  (indent-for-tab-command))
)
;auto complete pair
(defun my-c-mode-auto-pair ()
  (interactive)
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist '( (?` ?` _ "''")
                               (?\( _ ")")
                               (?\[ _ "]")
							   (?< _ ">")
                               (?{ \n > _ \n ?} >)
                               )
        )
  (setq skeleton-pair t)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "`") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe))

(require 'semantic-tag-folding nil 'noerror)
(global-semantic-tag-folding-mode 1)

(add-hook 'c-mode-common-hook 'my-c-mode-auto-pair)
(add-hook 'python-mode-common-hook 'my-c-mode-auto-pair)
(defun linux-cpp-mode() 
  (hs-minor-mode)
  (define-key c-mode-base-map [(control tab)] 'yas/expand)
  (define-key c-mode-base-map [(tab)] 'my-indent-or-complete)
  (define-key c-mode-base-map [(meta ?/)]  'semantic-ia-complete-symbol-menu)
  (define-key c-mode-base-map [return] 'newline-and-indent) 
  (define-key c-mode-base-map [(control c) (c)] 'compile) 
  (define-key c-mode-base-map [(meta ?h)] 'hs-hide-all)
  (define-key c-mode-base-map [(meta ?s)] 'hs-toggle-hiding)
  (define-key c-mode-base-map  [(f10)] 'gud-next)
  (define-key c-mode-base-map  [(f11)] 'gud-step)
  (define-key c-mode-base-map  [(shift f11)] 'gud-finish)
  (define-key c-mode-base-map  [(f9)] 'gud-break)
  (define-key c-mode-base-map  [(shift f9)] 'gud-remove)
  (interactive) 
  (c-set-style "stroustrup") 
  (c-toggle-hungry-state) 
  (c-set-offset 'inline-open 0)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'friend '-)
  (c-set-offset 'substatement-open 0)
  ;; change tabtas to spaces when entering it
  (setq-default indent-tabs-mode nil)
  (setq c-basic-offset 4) 
  (setq c-comment-only-line-offset 0)
  (imenu-add-menubar-index) 
  (which-function-mode) ;; turn which-function-mode on, show the current function name in mode line
  
)

(add-hook 'c-mode-hook 'linux-cpp-mode)
(add-hook 'c++-mode-hook 'linux-cpp-mode) 

(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("dired" (mode . dired-mode))
               ("perl" (mode . cperl-mode))
               ("erc" (mode . erc-mode))
               ("planner" (or
                           (name . "^\\*Calendar\\*$")
                           (name . "^diary$")
                           (mode . muse-mode)))
               ("emacs" (or
                         (name . "^\\*scratch\\*$")
                         (name . "^\\*Messages\\*$")))
               ("gnus" (or
                        (mode . message-mode)
                        (mode . bbdb-mode)
                        (mode . mail-mode)
                        (mode . gnus-group-mode)
                        (mode . gnus-summary-mode)
                        (mode . gnus-article-mode)
                        (name . "^\\.bbdb$")
                        (name . "^\\.newsrc-dribble")))))))

(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-switch-to-saved-filter-groups "default")))

(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)
(global-set-key [(control meta f3)] 'highlight-symbol-query-replace)

(require 'multi-term)

(require 'smooth-scroll)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

;; 检查为啥函数的开始和关闭都不是对齐的。。。
(c-set-offset 'inline-open 0)
(c-set-offset 'friend '-)
(c-set-offset 'substatement-open 0)
(c-set-offset 'defun-open 0)
(c-set-offset 'defun-close 0)

(setq c-macro-shrink-window-flag t)
(setq c-macro-preprocessor "cpp")
(setq c-macro-cppflags " ")
(setq c-macro-prompt-flag t)
(setq hs-minor-mode t)
(setq abbrev-mode t)

(add-to-list 'load-path "~/emacs/doxymacs")
(require 'doxymacs)
(add-hook 'c-mode-common-hook 'doxymacs-mode)


;; (defconst doxymacs-C++-file-comment-template
;;  '(
;;    "/******************************************************************************" > n
;;    "*" > n
;;    "* " "FILE NAME   :"
;;    (if (buffer-file-name)
;;        (file-name-nondirectory (buffer-file-name))
;;      "") > n
;;    "*" > n
;;    "*" " DESCRIPTION :"> n
;;    "*" > n
;;    "*" "    "> n
;;    "*" > n
;;    "*" " HISTORY     :"> n
;;    "*" > n
;;    "*" "    See Log at end of file"> n
;;    "*" > n
;;    "*" "Copyright (c) 2006, VIA Technologies, Inc."> n
;;    "*" "******************************************************************************/"> n)
;;  "Default C++-style template for file documentation.")
(add-to-list 'load-path "~/emacs/yasnippet-0.6.1c")
(require 'yasnippet)
(setq yas/root-directory "~/emacs/yasnippet-0.6.1c/snippets")
(yas/load-directory yas/root-directory)

(require 'dropdown-list)
(setq yas/prompt-functions '(yas/dropdown-prompt
                             yas/ido-prompt
                             yas/completing-prompt))

(add-to-list 'load-path "~/emacs/jdee-2.4.0.1/lisp")
(add-to-list 'load-path "~/emacs/elib-1.0")
(setenv "JAVA_HOME" "/opt/jdk1.7.0_07")
(setenv "CLASSPATH" ".:/opt/jdk1.7.0_07/tools.jar:/opt/jdk1.7.0_07/dt.jar")
(require 'jde)
(defun screen-width nil -1)
(define-obsolete-function-alias 'make-local-hook 'ignore "21.1")
(add-hook 'jde-mode-hook
          (lambda()
	    (local-set-key [(control return)] 'jde-complete)
	    (local-set-key [(shift return)] 'jde-complete-minibuf)
	    (local-set-key [(meta return)] 'jde-complete-in-line)))
