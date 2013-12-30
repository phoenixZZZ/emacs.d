
;;设置默认打开emacs,自动最大化
(defun my-max-window()
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
  '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
  '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
)
(run-with-idle-timer 1 nil 'my-max-window)

;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: Tou must place this *before* any CEDET component (including
;; EIEIO) gets activated by another package (Gnus, auth-source, ...).
(load-file "~/.emacs.d/site-lisp/cedet/cedet-devel-load.el")

;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode t)

;; Enable Semantic
(semantic-mode 1)

;; Enable EDE (Project Management) features
(global-ede-mode 1)

;; Load CEDET CONTRIB.
(load-file "~/.emacs.d/site-lisp/cedet/contrib/cedet-contrib-load.el")

;;;;配置库文件路径
(setq semanticdb-project-roots (list (expand-file-name "/")))
(defconst cedet-user-include-dirs
  (list "." "./include" "./src"
  ".." "../include" "../inc" "../common" "../public" "../include/sys" "../include/asm" "../include/linux" 
        "../.." "../../include" "../../inc" "../../common" "../../public"
        "/usr/local/apr/include/apr-1"
        "/opt/oSIP/include/osip2"
        "/opt/oSIP/include/osipparser2"))
;;(require 'semantic-c nil 'snoerror)
(let ((include-dirs cedet-user-include-dirs))
  (mapc
   (lambda (dir)
   ;;(semantic-add-system-include dir 'c++-mode)
   (semantic-add-system-include dir 'c-mode))
   include-dirs)) 
(add-hook 'semantic-init-hooks 'semantic-decoration-mode) ;会对每一个函数进行标注(蓝线标出)
(add-hook 'semantic-init-hooks 'semantic-idle-completions-mode) ;空闲时进行补全分析

;; 避免semantic占用CPU过多,单位second(但是开启这个会影响,cedet的代码提示功能) 
;;(setq-default semantic-idle-scheduler-idle-time 432000)

;;全局关闭cedet #if #else 智能分析 
;;(setq semantic-c-obey-conditional-section-parsing-flag nil)

;;;;==================配置文件跳转快捷键Start===================================
(require 'eieio-opt)  ;;不加的话会报一个eieio的错误
(setq stack-trace-on-error t) ;;不加的话会报一个eieio的错误

(defvar mru-tag-stack '()
"Tag stack, when jumping to new tag, current tag will be stored here,
and when jumping back, it will be removed.")

(defun yc/store-mru-tag (pt)
  "Store tag info into mru-tag-stack"
  (interactive "d")
  (let* ((tag (semantic-mrub-find-nearby-tag pt)))
    (if tag
        (let ((sbm (semantic-bookmark (semantic-tag-name tag)
                                      :tag tag)))
          (semantic-mrub-update sbm pt 'mark)
          (add-to-list 'mru-tag-stack sbm)
          )
      (error "No tag to go!")))
  )

(defun yc/goto-func (pt)
  "Store current postion and call (semantic-ia-fast-jump)"
  (interactive "d")
  (yc/store-mru-tag pt)
  (semantic-ia-fast-jump pt)
)

(defun yc/goto-func-any (pt)
  "Store current postion and call (semantic-ia-fast-jump)"
  (interactive "d")
  (yc/store-mru-tag pt)
  (semantic-complete-jump)
  )

(defun yc/symref (pt)
  (interactive "d")
  (yc/store-mru-tag pt)
  (semantic-symref))

(defun yc/return-func()
  "Return to previous tag."
  (interactive)
  (if (car mru-tag-stack)
      (semantic-mrub-switch-tags (pop mru-tag-stack))
    (error "TagStack is empty!")))

(require 'eassist nil 'noerror)
(defun setup-program-keybindings()
  ;;;; Common program-keybindings
  (interactive)
  (local-set-key [f7] 'yc/symref)           ;;全局查找类似 search-project
  (local-set-key [f8] 'semantic-mrub-switch-tags)  ;;切换跳转位置
  (local-set-key [f9] 'yc/store-mru-tag)    ;;查找某一个已经被分析过的函数
  (local-set-key [f10]'yc/goto-func-any)    ;;当yc/goto-func不管用是尝试下
  (local-set-key (kbd "s-<f10>") 'eassist-switch-h-cpp)   ;;跳转到相关的h文件中,目前来看只是支持当前工程内的查找
  (local-set-key [f11] 'yc/goto-func)       ;;定义跳转
  (local-set-key (kbd "s-<f11>") 'eassist-list-methods)   ;;跳转到相关的h文件中,目前来看只是支持当前工程内的查找
  (local-set-key [f12] 'yc/return-func)     ;;跳转返回
  (local-set-key (kbd "M-n") 'semantic-ia-complete-symbol-menu)   ;;自动补全
)
(add-hook 'c-mode-hook 'setup-program-keybindings) 

;;==============================某些插件的使用Start============================
(add-to-list 'load-path "~/.emacs.d/")
;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(defconst *spell-check-support-enabled* nil)
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))

;;;;package-list ALL
(require 'init-utils)
(require 'init-elpa)      ;; Machinery for installing required packages

(require 'init-windows)   ;;窗体切换快捷键设置

(require 'init-ibuffer)   
(require 'init-git)       ;;设置git相关

(require 'init-ido)       ;;设置ido相关(命令补全)

(require 'highlight-symbol)
(highlight-symbol-mode 1)
(global-set-key (kbd "C-c M-h") 'highlight-symbol-at-point)
(global-set-key (kbd "C-c M-r") 'highlight-symbol-remove-all)
(global-set-key (kbd "C-c M-n") 'highlight-symbol-next)
(global-set-key (kbd "C-c M-m") 'highlight-symbol-prev)
(global-set-key (kbd "C-c r")   'highlight-symbol-query-replace)
(global-set-key (kbd "C-c M-,") 'highlight-symbol-next-in-defun)
(global-set-key (kbd "C-c M-.") 'highlight-symbol-prev-in-defun)

;; 鼠标滚轮，把默认滚动改为3行 
(defun up-slightly () (interactive) (scroll-up 3)) 
(defun down-slightly () (interactive) (scroll-down 3)) 
(global-set-key [mouse-4] 'down-slightly) 
(global-set-key [mouse-5] 'up-slightly)
(global-set-key [prior] 'down-slightly) 
(global-set-key [next] 'up-slightly)
;;Ctrl+鼠标滚轮，调整字体大小
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)

(require-package 'diminish) ;;添加这个是为了保证在使用cedet时没有error出现
;;(require-package 'starter-kit)
;;(provide 'init-starter-kit)

;;设置行跳转
(global-linum-mode t) 
(global-set-key (kbd "\C-c\C-g") 'goto-line)

;;设置tabbar,C-tab在当前分组内切换,S-tab在分组间切换

(require 'tabbar)
(tabbar-mode)
;(global-set-key (kbd "<backtab>") 'tabbar-backward-group)
(global-set-key (kbd "C-<tab>") 'tabbar-backward-tab)

;;代码自动高亮,可以将自定义的函数和变量(只要cedet识别),分别进行高亮
(require 'zjl-hl)
(zjl-hl-enable-global-all-modes)

;;设置中文显示支持
(prefer-coding-system 'gb2312)
(add-hook 'after-init-hook (lambda () (load "init-gui-frames.el")))

;;TAB Blank-mode
;;(require 'blank-mode)
;;(global-blank-mode)
(add-hook 'c-mode-hook
          (lambda()
            (setq whitespace-style '(trailing newline spaces
                                tab-mark tabs newline-mark))
            (whitespace-mode t)))

;;set TAB's width 
;; C language setting
(add-hook 'c-mode-hook
          '(lambda ()
             (c-set-style "K&R")
             (setq tab-width 4)
             (setq indent-tabs-mode t)
             (setq c-basic-offset 4)))

;; C++ language setting
(add-hook 'c++-mode-hook
          '(lambda ()
             (c-set-style "K&R")
             ;;(c-toggle-auto-state)
             (setq tab-width 4)
             (setq indent-tabs-mode t)
             (setq c-basic-offset 4)))

;;==============================某些插件的使用End============================

;;==============================ECB的使用Start============================
(add-to-list 'load-path "~/.emacs.d/site-lisp/ecb")
(require 'ecb)

;;设置显示/隐藏ecb快捷键
(defun hjr/ecb-my-switch()
  (interactive)
  (if(ecb-minor-mode)
      (ecb-activate)
    (ecb-deactivate)))

(global-set-key (kbd "C-`") 'hjr/ecb-my-switch)

(setq ecb-tip-of-the-day nil
      ecb-tree-indent 4
      ecb-windows-height 0.5
      ecb-windows-width 0.15)

ecb-auto-compatibility-check nil
ecb-version-check nil
inhibit-startup-message t

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.

 ;; If there is more than one, they won't work right.
 '(ecb-debug-mode t)
 '(ecb-layout-window-sizes (quote (("left8" (ecb-directories-buffer-name 0.1927710843373494 . 0.28205128205128205) (ecb-sources-buffer-name 0.1927710843373494 . 0.23076923076923078) (ecb-methods-buffer-name 0.1927710843373494 . 0.28205128205128205) (ecb-history-buffer-name 0.1927710843373494 . 0.1794871794871795)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-source-path (quote ("/")))
 '(split-width-threshold 160))
(custom-set-faces

 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;窗口布局;;;;;;;;;;;;;;;;;;;;;;;;;;;
(ecb-layout-define "my-ecb-layout" left nil
                   (ecb-set-sources-buffer)
                   (ecb-split-ver 0.5 t)
                   (other-window 1)
                   (ecb-set-methods-buffer))

;;(defecb-window-dedicator ecb-set-cscope-buffer " *ECB cscope-buf*"
;;                         (switch-to-buffer "*cscope*"))

(setq ecb-layout-name "my-ecb-layout")

;; Disable buckets so that history buffer can display more entries
;;(setq ecb-directories-make-buckets 'never)
(setq ecb-history-make-buckets 'never)

;;==============================ECB的使用End============================

;;==============================color-theme-start============================
(add-to-list 'load-path "~/.emacs.d/site-lisp/color-theme-6.6.0")  
(require 'color-theme-autoloads "color-theme-autoloads") 
(color-theme-initialize) 
(color-theme-dark-blue2) 
;;(color-theme-gnome2)
(set-default-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1") 
;;==============================color-theme-end============================
