;;delete menu!
(menu-bar-mode 0)
(tool-bar-mode 0)

;set original key-bind
(define-key global-map "\C-c#" 'comment-region) ;set comment region on #
(define-key global-map "\C-\\" 'nil) ;disable japanese mode on c-\\
; (define-key global-map "\C-z" 'undo) ; for windows user (-;

;set default open window size
(setq initial-frame-alist
      (append
       '((top     .0) ;frame potision y
	 (left    .0) ;frame position x
	 (width  .1024) ;size x not working??
	 (height .768)) ;size y
	 initial-frame-alist))
(setq default-frame-alist
      (append
       '((width   .1024) ;frame x
	 (height  .768)) ;frame y
	 default-frame-alist))

;set wheel mode
(mouse-wheel-mode t)
(setq mouse-wheel-follow-mouse t)

;enable completion mode.(auto complete)
(setq partial-completion-mode 1)



(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-time-mode t)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "M+2P+IPAG")))))

;;;elを読み込むパスの指定。
;; variousは単一のファイルを入れる場所としている。
(setq load-path (cons "~/.emacs.d/tools/various" load-path))


;;;set default locale
(set-language-environment "Japanese")
;; (set-input-method "japanese-anthy")
(setq prefer-conding-system "utf-8")
(set-default-coding-systems 'utf-8)
;;;
(setq inhibit-startup-message t)

;;; shell-mode でエスケープを綺麗に表示
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
   "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;; shell-modeで上下でヒストリ補完
(add-hook 'shell-mode-hook
   (function (lambda ()
      (define-key shell-mode-map [up] 'comint-previous-input)
      (define-key shell-mode-map [down] 'comint-next-input))))

;;; for anthymode
(load-library "anthy")
(if (>= emacs-major-version 23)
  (setq anthy-accept-timeout 1))
(setq default-input-method "japanese-anthy")
(global-set-key [zenkaku-hankaku] 'anthy-mode)
;(setq anthy-wide-space " ")


;; Shift+矢印で画面移動できる。
(windmove-default-keybindings)

 
;; 対応する括弧を強調
(show-paren-mode t)

;;; 同名ファイルを開いたとき、ファイル名の1階層上のディレクトリを表示する。
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;; メタタグのエンコーディングで保存しようとする行為を防ぐ
(delete 'sgml-html-meta-auto-coding-function auto-coding-functions)


;;; 背景とか文字色とか
(set-background-color "black") 
(set-foreground-color "white")
(defface gnus-cite-face-1 '((((class color)
                              (background dark))
                             (:foreground "light blue"))
                            (((class color)
                              (background light))
                             (:foreground "MidnightBlue"))
                            (t
                             (:italic t)))
  "Citation face.")


;;; モードラインに時間を表示する
(setq display-time-24hr-format t)
(display-time)

;;; find-fileの検索方法で大文字小文字を区別しない
(setq read-file-name-completion-ignore-case t)

;;; バッファの履歴を引き継ぐ
;; checkin 後に実行される関数をフック
(add-hook 'vc-checkin-hook
          '(lambda ()
              (setq buffer-undo-list higepon-san)))

;; checkin 前に実行される関数をフック
(add-hook 'vc-before-checkin-hook
          '(lambda ()
             (setq higepon-san buffer-undo-list)))

(setq completion-ignore-case t)

;;; for fullscreen
(defun switch-full-screen ()
  (interactive)
  (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f8] 'switch-full-screen)
;; (funcall 'switch-full-screen) 

;;;;;;;;;;;;;;;;;;;;;;; ここからrails-rinari ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; もう少し使えるようになるには時間かかりそう
;; (require 'ido)
;; (ido-mode t)
;; ;; load jump for Rinari
;; (add-to-list 'load-path "~/.emacs.d/tools/jump")
;; (require 'jump)
;; ;; Rinari
;; (add-to-list 'load-path "~/.emacs.d/rinari")
;; (require 'rinari)
;; ;;; rhtml-mode
;; (add-to-list 'load-path "~/.emacs.d/rinari/rhtml")
;; (require 'rhtml-mode)
;; (add-hook 'rhtml-mode-hook
;;     (lambda () (rinari-launch)))
;;;;;;;;;;;;;;;;;;;;;;;;ここまでrails-rinari;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;; ここからemacs-rails ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-path (cons "~/.emacs.d/emacs-rails" load-path))
;; Interactively Do Things (highly recommended, but not strictly required)
(defun try-complete-abbrev (old)
       (if (expand-abbrev) t nil))
(setq hippie-expand-try-functions-list
      '(try-complete-abbrev
        try-complete-file-name
        try-expand-dabbrev))
(require 'cl)
(require 'rails)
(define-key rails-minor-mode-map "\C-c\C-p" 'rails-lib:run-primary-switch)
(define-key rails-minor-mode-map "\C-c\C-n" 'rails-lib:run-secondary-switch)

;;;;;;;;;;;;;;;;;;;;;;;;;;;ここまでemacs-rails;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;ここからflymakeの設定;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flymake)
(defun flymake-show-and-sit ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (progn
    (let* ( (line-no             (flymake-current-line-no) )
            (line-err-info-list  (nth 0 (flymake-find-err-info 
              d                          flymake-err-info line-no)))
            (count               (length line-err-info-list))
            )
      (while (> count 0)
        (when line-err-info-list
          (let* ((file       (flymake-ler-file (nth (1- count) 
                                                    line-err-info-list)))
                 (full-file  (flymake-ler-full-file (nth (1- count)
                                                         line-err-info-list)))
                 (text (flymake-ler-text (nth (1- count) line-err-info-list)))
                 (line       (flymake-ler-line (nth (1- count) 
                                                    line-err-info-list))))
            (message "[%s] %s" line text)
            )
          )
        (setq count (1- count)))))
  (sit-for 60.0)
  )
(global-set-key "\C-cd"
                'flymake-show-and-sit)

(defun flymake-c-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "gcc" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
(push '("\\.c$" flymake-c-init) flymake-allowed-file-name-masks)

(add-hook 'c-mode-hook
          '(lambda ()
             (flymake-mode t)))

(defun flymake-cc-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
(push '("\\.cc$" flymake-cc-init) flymake-allowed-file-name-masks)

(add-hook 'c++-mode-hook
          '(lambda ()
             (flymake-mode t)))

; You must prepare epylint by hand
; See also http://www.emacswiki.org/cgi-bin/wiki/PythonMode
(defun flymake-pylint-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "epylint" (list local-file))))
(push '("\\.py\\'" flymake-pylint-init) flymake-allowed-file-name-masks)

(add-hook 'python-mode-hook
          '(lambda ()
             (flymake-mode t)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;ここまでflymakeの設定;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; for clipboard (通常、コピーしてもクリップボードではなくemacs上でコピーとなるため)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-w" 'clipboard-kll-region)
