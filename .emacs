;; バックアップ
(setq backup-directory-alist '(("" . "~/.emacs.d/backup")))

;; ロードパス
(setq load-path (cons "/home/takayuki/.emacs.d/elisp/" load-path))
;;(add-to-list 'load-path "~/.emacs.d/elisp/")

;; package
;;(package-initialize)
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; インデント
(setq-default tab-width 4 indent-tabs-mode t)

;; diredのバッファ抑止
(put 'dired-find-alternate-file 'disabled nil)

;; window_move_customize
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-vertically))
  (other-window 1)
)
(global-set-key (kbd "C-t") 'other-window-or-split)
(global-set-key "\C-x\C-t" 'other-window-or-split)

(defun other-window-or-split2 ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1)
)
(global-set-key (kbd "C-o") 'other-window-or-split2)

;; バッファリストの分割抑止
(global-set-key "\C-x\C-b" 'buffer-menu)

(setq resize-mini-windows 'grow-only)

;;------------------------------------------------------------------------------
;; Mode-Line Display
;;------------------------------------------------------------------------------
;; 文字コードと改行コードを確認しやすくする
;; BOMなしを 大文字の U に
(coding-system-put 'utf-8 :mnemonic ?U)
;; BOMありを 小文字の u に
(coding-system-put 'utf-8-with-signature :mnemonic ?u)

;; 改行コード
(setq eol-mnemonic-dos "[CR+LF]")
(setq eol-mnemonic-mac "[CR]")
(setq eol-mnemonic-unix "[LF]")
(setq eol-mnemonic-undecided "[?]")

;; 行番号表示
(global-linum-mode)
(setq linum-format "%4d ")
(global-set-key [f6] 'global-linum-mode)

;; web-mode呼び出し
(global-set-key [f7] 'web-mode)


;; php-mode
;;(load-library "php-mode")
(require 'php-mode)
(setq auto-mode-alist(cons '("\\.php\\'" . php-mode) auto-mode-alist))

(setq php-mode-force-pear t)
(c-set-offset 'case-label '+)
(defun php-lint ()
  "Performs a PHP lint-check on the current file."
  (interactive)
  (shell-command  (concat "/usr/bin/php -l " (buffer-file-name)))
  )
(defun php-exec ()
  "Execute a PHP on the current file."
  (interactive)
  (shell-command (concat "/usr/bin/php " (buffer-file-name))))

;; php array indent
(defun ywb-php-lineup-arglist-intro (langelem)
  (save-excursion
    (goto-char (cdr langelem))
    (vector (+ (current-column) c-basic-offset))))
(defun ywb-php-lineup-arglist-close (langelem)
  (save-excursion
    (goto-char (cdr langelem))
    (vector (current-column))))

;; key binding re-define and more
(add-hook 'after-save-hook 'php-lint)
(add-hook 'php-mode-hook
          '(lambda ()
			 (setq tab-width 4)
			 (setq indent-tabs-mode t)
             (local-set-key [f8] 'php-lint)
             (add-hook 'after-save-hook 'php-lint)
             (c-set-offset 'arglist-intro 'ywb-php-lineup-arglist-intro)
             (c-set-offset 'arglist-close 'ywb-php-lineup-arglist-close)
           ))

;; html-mode
(setq auto-mode-alist(cons '("\\.html\\'" . html-mode) auto-mode-alist))
(setq auto-mode-alist(cons '("\\.tpl\\'" . html-mode) auto-mode-alist))
(setq auto-mode-alist(cons '("\\.ctp\\'" . html-mode) auto-mode-alist))
(add-hook 'sgml-mode-hook
  (lambda () (setq sgml-basic-offset 4))
)


;; jdee
;;(add-to-list 'load-path "/usr/local/jdee/lisp")
;;(load "jde-autoload")

;;(defun my-jde-mode-hook ()
;;  (require 'jde)

;;  (setq jde-build-function 'jde-ant-build) ; ビルドにantを利用する
;;  (setq jde-ant-read-target t)             ; targetを問い合わせる
;;  (setq jde-ant-enable-find t)             ; antに-findオプションを指定する(要らないかも)

  ;; complilationバッファを自動的にスクロールさせる
;;  (setq compilation-ask-about-save nil)
;;  (setq compilation-scroll-output 'first-error)

;; (define-key jde-mode-map (kbd "C-c C-v .") 'jde-complete-minibuf)
;; )

;;(add-hook 'jde-mode-hook 'my-jde-mode-hook)

;;(setq gtags-path-style 'relative)

;; eshell
;; alias
(setq eshell-command-aliases-list
	  (append
	   (list
		(list "ll" "ls -la $*")
		(list "emacs" "find-file $1")
		)
	   )
	  )

;; 補完時に大文字小文字を区別しない
(setq eshell-cmpl-ignore-case t)
;; 確認なしでヒストリ保存
(setq eshell-ask-to-save-history (quote always))
;; 補完時にサイクルする
(setq eshell-cmpl-cycle-completions t)
;;補完候補がこの数値以下だとサイクルせずに候補表示
(setq eshell-cmpl-cycle-cutoff-length 5)
;; 履歴で重複を無視する
(setq eshell-hist-ignoredups t)

;; キーバインドの変更
(add-hook 'eshell-mode-hook
		  '(lambda ()
			 (define-key eshell-mode-map "\C-a" 'eshell-bol)
			 )
		  )

;; web-mode
(require 'web-mode)

;;; emacs 23以下の互換
;;(when (< emacs-major-version 24)
;;  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
;;(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.ctp$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq indent-tabs-mode t)
  (setq web-mode-html-indent-offset   4)
  (setq web-mode-css-indent-offset    4)
  (setq web-mode-script-indent-offset 4)
  (setq web-mode-php-offset    4)
  (setq web-mode-java-offset   4)
  (setq web-mode-asp-offset    4)
  )
(add-hook 'web-mode-hook 'web-mode-hook)

;; apache-mode
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

(defun php-lint2 ()
  "Performs a PHP lint-check on the current file."
  (interactive)
  (shell-command  "tail -n 5 /var/log/php_errors.log")
)
(global-set-key [f9] 'php-lint2)
