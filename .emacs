;;;;;;;;;;;;;;;;;;;;;
;; < 共通設定 >
;;;;;;;;;;;;;;;;;;;;;

;; set default locale
; (set-language-environment "Japanese")
(set-language-environment 'utf-8)
;; (set-input-method "japanese-anthy")
(setq prefer-conding-system "utf-8")
(set-default-coding-systems 'utf-8)
;;;
(setq inhibit-startup-message t)

;; delete menu
;(menu-bar-mode 0)
(tool-bar-mode 0)

; set original key-bind
(define-key global-map "\C-c#" 'comment-region) ;set comment region on #
(define-key global-map "\C-\\" 'nil) ;disable japanese mode on c-\\
; (define-key global-map "\C-z" 'undo) ; for windows user (-;

;;;;;;;;;;;;;;;;;;;;;
;; ウィンドウサイズ設定
;;;;;;;;;;;;;;;;;;;;;

;; (setq default-frame-alist
;;       (append
;;        '((width   .1024) ;frame x
;; 	 (height  .768)) ;frame y
;; 	 default-frame-alist))

; set wheel mode
(mouse-wheel-mode t)
(setq mouse-wheel-follow-mouse t)

; enable completion mode.(auto complete)
(setq partial-completion-mode 1)

; from emacs menu
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

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 読み込みパスの設定
;;;;;;;;;;;;;;;;;;;;;;;;;

;; flymakeの設定
(load "~/.emacs.env/.flymake.emacs")
;; variousは単一のelファイルを入れる場所
(setq load-path (cons "~/.emacs.d/tools/various" load-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 各設定
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; migemo (can search japanese by english words)
;; (load "migemo.el")
;;;; c/migemo -- incremental searches by ro-maji
;; base
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs" "-i" "\a"))
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict") ; PATH of migemo-dict
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)

;; use cache
(setq migemo-use-pattern-alist t)
(setq migemo-use-frequent-pattern-alist t)
(setq migemo-pattern-alist-length 1024)
;; charset encoding
(setq migemo-coding-system 'utf-8-unix)

(load-library "migemo")
;; initialization
(migemo-init)



;; svn mode
(autoload 'svn-status "dsvn" "Run `svn status'." t)
(autoload 'svn-update "dsvn" "Run `svn update'." t)

;; shell-mode でエスケープを綺麗に表示
(autoload 'ansi-color-for-comint-mode-on "ansi-color"
   "Set `ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;; shell-modeで上下でhistory補完
(add-hook 'shell-mode-hook
   (function (lambda ()
      (define-key shell-mode-map [up] 'comint-previous-input)
      (define-key shell-mode-map [down] 'comint-next-input))))

;;; for anthymode
;(load-library "anthy")
;(if (>= emacs-major-version 23)
;  (setq anthy-accept-timeout 1))
;(setq default-input-method "japanese-anthy")
;(global-set-key [zenkaku-hankaku] 'anthy-mode)
;(setq anthy-wide-space " ")

;; 対応する括弧を強調
(show-paren-mode t)

;;; 同名ファイルを開いたとき、ファイル名の1階層上のディレクトリを表示する。
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;; メタタグのエンコーディングで保存しようとする行為を防ぐ
(delete 'sgml-html-meta-auto-coding-function auto-coding-functions)

;;; 背景とか文字色とか
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
;; F8でセット
(defun switch-full-screen ()
  (interactive)
  (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f8] 'switch-full-screen)
;; (funcall 'switch-full-screen) 



;; raile-mode seting

;; rinariの方が開発が進んでいるとかいないとか。
;;;;;;;;;;;;;;;;;;;;;;; ここからrails-rinari ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; もう少し使えるようになるには時間かかりそう
;(require 'ido)
;(ido-mode t)
;; load jump for Rinari
(add-to-list 'load-path "~/.emacs.d/tools/jump")
(require 'jump)
;; Rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)
;;; rhtml-mode
(add-to-list 'load-path "~/.emacs.d/rinari/rhtml")
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
    (lambda () (rinari-launch)))

;;;;;;;;;;;;;;;;;;;;;;;;ここまでrails-rinari;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;emacs-railsは開発者がやる気がないらしい
;;;;;;;;;;;;;;;;;;;;;;;;;;; ここからemacs-rails ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(setq load-path (cons "~/.emacs.d/emacs-rails" load-path))
;; Interactively Do Things (highly recommended, but not strictly required)
;; (defun try-complete-abbrev (old)
;;        (if (expand-abbrev) t nil))
;; (setq hippie-expand-try-functions-list
;;       '(try-complete-abbrev
;;         try-complete-file-name
;;         try-expand-dabbrev))
;; (require 'cl)
;; (require 'rails)
;; (define-key rails-minor-mode-map "\C-c\C-p" 'rails-lib:run-primary-switch)
;; (define-key rails-minor-mode-map "\C-c\C-n" 'rails-lib:run-secondary-switch)

;;;;;;;;;;;;;;;;;;;;;;;;;;;ここまでemacs-rails;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; for clipboard (通常、コピーしてもクリップボードではなくemacs上でコピーとなるため)
(global-set-key [(shift delete)] 'clipboard-kill-ring-save)
(global-set-key [(control insert)] 'clipboard-kill-region)
(global-set-key [(shift insert)] 'clipboard-yank)
; (transient-mark-mode 1)  ; Now on by default: makes the region act quite like the text "highlight" in many apps.
; (setq shift-select-mode t) ; Now on by default: allows shifted cursor-keys to control the region.
  (setq mouse-drag-copy-region nil)  ; stops selection with a mouse being immediately injected to the kill ring
  ; (setq x-select-enable-primary nil)  ; stops killing/yanking interacting with primary X11 selection
 ;  (setq x-select-enable-clipboard t)  ; makes killing/yanking interact with clipboard X11 selection

   ;; these will probably be already set to these values, leave them that way if so!
   ; (setf interprogram-cut-function 'x-select-text)
   ; (setf interprogram-paste-function 'x-cut-buffer-or-selection-value)

   ; You need an emacs with bug #902 fixed for this to work properly. It has now been fixed in CVS HEAD.
   ; it makes "highlight/middlebutton" style (X11 primary selection based) copy-paste work as expected
   ; if you're used to other modern apps (that is to say, the mere act of highlighting doesn't
   ; overwrite the clipboard or alter the kill ring, but you can paste in merely highlighted
   ; text with the mouse if you want to)
  ; (setq select-active-regions t) ;  active region sets primary X11 selection
  ; (global-set-key [mouse-2] 'mouse-yank-primary)  ; make mouse middle-click only paste from primary X11 selection, not clipboard and kill ring.

   ;; with this, doing an M-y will also affect the X11 clipboard, making emacs act as a sort of clipboard history, at
   ;; least of text you've pasted into it in the first place.
   ; (setq yank-pop-change-selection t)  ; makes rotating the kill ring change the X11 clipboard.

;;透過は今現在動かない？
;; don't work.. 
;(defun modify-frame-alpha (arg)
;    (interactive "Nalpha parameter: ")
;    (modify-frame-parameters nil (list (cons 'alpha arg)))
;)
;; デフォルトの透明度を設定する (85%)
;(add-to-list 'default-frame-alist '(alpha . 85))
;(set-frame-parameter nil 'alpha 30)

;; yasnippetのロード
(setq load-path (cons (expand-file-name "~/.emacs.d/yasnippet-0.6.1c") load-path))
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet-0.6.1c/yasnippets-rails/rails-snippets")


;; twitter mode
(add-to-list 'load-path "~/.emacs.d/tools/twitter/") ;; if you need
(require 'twittering-mode)
(setq twittering-username "watamin.syou@gmail.com")

;; yaml mode
(add-to-list 'load-path "~/.emacs.d/tools/yaml-mode/") ;; if you need
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook '(lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent))) 


;; auto install
;(add-to-list 'load-path "~/.emacs.d/tools/anything/") ;; if you need
;(require 'auto-install)
;(setq auto-install-directory "~/.emacs.d/tools/anything/auto-install/")
;(auto-install-update-emacswiki-package-name t)
;(auto-install-compatibility-setup)

;(add-to-list 'load-path "~/.emacs.d/tools/anything/auto-install/") ;; if you need
;(require 'anything-startup)

; elscreen
;; (add-to-list 'load-path "~/.emacs.d/tools/apel/") ;; if you need
;; (add-to-list 'load-path "~/.emacs.d/tools/elscreen/") ;; if you need

;; ; hook for ansi-term
;; (add-hook 'term-mode-hook ' (lambda()
;; 			      (define-key term-raw-map "\C-z"
;; 				(lookup-key (current-global-map) "\C-z"))))
;; (defun elscreen-frame-title-update ()
;;   (when (elscreen-screen-modified-p 'elscreen-frame-title-update)
;;     (let* ((screen-list (sort (elscreen-get-screen-list) '<))
;; 	   (screen-to-name-alist (elscreen-get-screen-to-name-alist))
;; 	   (title (mapconcat
;; 		   (lambda (screen)
;; 		     (format "%d%s %s"
;; 			     screen (elscreen-status-label screen)
;; 			     (get-alist screen screen-to-name-alist)))
;; 		   screen-list " ")))
;;       (if (fboundp 'set-frame-name)
;; 	  (set-frame-name title)
;; 	(setq frame-title-format title)))))

;; (eval-after-load "elscreen"
;;   '(add-hook 'elscreen-screen-update-hook 'elscreen-frame-title-update))
;; (setq elscreen-display-tab 8) ; tab width
;; (setq elscreen-tab-display-kill-screen nil) ; not show [x]
;; (load "elscreen" "ElScreen" t)

;; windows.el
(add-to-list 'load-path "~/.emacs.d/tools/windows/") 
(defvar win:switch-prefix "\C-z")
(require 'windows)
(setq win:use-frame nil)
(win:startup-with-window)
(define-key ctl-x-map "C" 'see-you-agein)
(define-key global-map "\C-c\C-r" 'resume-windows)

;; read uim.el
(require 'uim)
;; uncomment next and comment out previous to load uim.el on-demand
;; (autoload 'uim-mode "uim" nil t)

;; key-binding for activate uim (ex. C-\)
(global-set-key [zenkaku-hankaku] 'uim-mode)

;; Set UTF-8 as preferred character encoding (default is euc-jp).
(setq uim-lang-code-alist
      (cons '("Japanese" "Japanese" utf-8 "UTF-8")
           (delete (assoc "Japanese" uim-lang-code-alist) 
                   uim-lang-code-alist)))

;; Set Hiragana input mode at activating uim with anthy (utf-8).
(setq uim-default-im-prop '("action_anthy_utf8_hiragana"))
;; set inline candidates displaying mode as default
(setq uim-candidate-display-inline t)

;; Set Hiragana input mode at activating uim with mozc.
;(setq uim-default-im-prop '("action_mozc_hiragana"))

;; Load CEDET
;; (load-file "/usr/share/emacs/site-lisp/cedet/common/cedet.el")

;;
;; (add-to-list 'load-path "~/.emacs.d/jdee/lisp")
;; (add-to-list 'load-path "~/.emacs.d/lisp/jdee/lisp")

;; JDEE
;;(load "cedet")
;(setenv "JAVA_HOME" "/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home")
;;(require 'jde)

;;(custom-set-variables
 ;;'(jde-global-classpath (quote (
 ;  ;要らない                              "/opt/android-sdk/platforms/android-3/android.jar"
;                                "/opt/android-sdk/platforms/android-4/android.jar"
;                                "/opt/android-sdk/platforms/android-7/android.jar"
;                                "/opt/android-sdk/platforms/android-8/android.jar"
;                                ))))

;; android-mode
;(add-to-list 'load-path "~/.emacs.d/tools/android-mode")
;(require 'android-mode)
;(setq android-mode-sdk-dir "/opt/android-sdk")
