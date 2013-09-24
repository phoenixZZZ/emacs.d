;;设置默认打开emacs,自动最大化
(defun my-max-window()
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
  '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
  '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
)
(run-with-idle-timer 1 nil 'my-max-window)

;;==============================CEDET配置Start============================

;;C-h v load-path 检查是否去掉emacs内置cede
(setq load-path (remove "/usr/share/emacs/24.3/lisp/cedet" load-path))  ;;移除内置的cedet功能,现在都是使用cedet1.1外部源码版

(load-file "~/.emacs.d/site-lisp/cedet-1.1/common/cedet.el")
(require 'cedet)
;;;; 具体说明可参考源码包下的INSTALL文件，或《A Gentle introduction to Cedet》
;; Enabling Semantic (code-parsing, smart completion) features
;; Select one of the following:
(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
;;(semantic-load-enable-gaudy-code-helpers)
;;(semantic-load-enable-excessive-code-helpers) ;;此功能开启会严重影响emacs的执行效率
;;(semantic-load-enable-semantic-debugging-helpers)

;;;;配置库文件路径
(setq semanticdb-project-roots (list (expand-file-name "/")))
(defconst cedet-user-include-dirs
  (list "." "./include" "./src"
  ".." "../include" "../inc" "../common" "../public" "../include/sys" "../include/asm" "../include/linux" 
        "../.." "../../include" "../../inc" "../../common" "../../public"
        "/usr/local/apr/include/apr-1"
        "/opt/oSIP/include/osip2"
        "/opt/oSIP/include/osipparser2"))
(require 'semantic-c nil 'snoerror)
(let ((include-dirs cedet-user-include-dirs))
  (mapc (lambda (dir)
;;        (semantic-add-system-include dir 'c++-mode)
        (semantic-add-system-include dir 'c-mode))
        include-dirs)) 

(add-hook 'semantic-init-hooks 'semantic-decoration-mode) ;会对每一个函数进行标注(蓝线标出)
(add-hook 'semantic-init-hooks 'semantic-idle-completions-mode) ;空闲时进行补全分析
;;(add-hook 'semantic-init-hooks 'semantic-show-unmatched-syntax-mode) ;将所有cedet没有进行正常解析的部分用红线标出，鼠标悬停会出相应的解释

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
  (local-set-key (kbd "C-<f11>") 'eassist-switch-h-cpp)   ;;跳转到相关的h文件中,目前来看只是支持当前工程内的查找
  (local-set-key [f11] 'yc/goto-func)       ;;定义跳转
  (local-set-key [f12] 'yc/return-func)     ;;跳转返回
  (local-set-key (kbd "M-n") 'semantic-ia-complete-symbol-menu)   ;;自动补全
)
(add-hook 'c-mode-hook 'setup-program-keybindings) 
;;;;==================配置文件跳转快捷键End===================================

;;EDE 工程管理
;;(global-ede-mode t)

;;开启cedet的可是化书签功能 F2添加/删除 S-F2查找书签
(enable-visual-studio-bookmarks)

;;;;==========================Not Using==========================
;;;;全局查找类似 search-project
;;(global-set-key [f7] 'yc/symref)
;;;;切换跳转位置
;;(global-set-key [f8] 'semantic-mrub-switch-tags)
;;;;查找某一个已经被分析过的函数
;;(global-set-key [f9] 'yc/store-mru-tag)
;;;;当yc/goto-func不管用是尝试下
;;(global-set-key [f10] 'yc/goto-func-any)  
;;;;定义跳转
;;(global-set-key [f11] 'yc/goto-func)
;;;;跳转到相关的h文件中,目前来看只是支持当前工程内的查找
;;(global-set-key (kbd "C-<f11>") 'semantic-analyze-proto-impl-toggle)
;;(require 'eassist nil 'noerror)
;;(global-set-key (kbd "C-<f11>") 'eassist-switch-h-cpp)
;;;;返回跳转前的位置
;;(global-set-key [f12] 'yc/return-func)
;;;;代码补全
;;(define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)
;;;;==========================Not Using==========================

;;==============================CEDET配置End============================

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

(require-package 'diminish) ;;添加这个是为了保证在使用cedet时没有error出现
;;(require-package 'starter-kit)
;;(provide 'init-starter-kit)

;;设置行跳转
(global-linum-mode t) 
(global-set-key (kbd "\C-c\C-g") 'goto-line)

;;设置tabbar,C-tab在当前分组内切换,S-tab在分组间切换

(require 'tabbar)
(tabbar-mode)
(global-set-key (kbd "<backtab>") 'tabbar-backward-group)
(global-set-key (kbd "C-<tab>") 'tabbar-backward-tab)

;;代码自动高亮,可以将自定义的函数和变量(只要cedet识别),分别进行高亮
(require 'zjl-hl)
(zjl-hl-enable-global-all-modes)

;;设置中文显示支持
(prefer-coding-system 'gb2312)
(add-hook 'after-init-hook (lambda () (load "init-gui-frames.el")))


;;==============================某些插件的使用End============================

;;==============================ECB的使用Start============================
(add-to-list 'load-path "~/.emacs.d/site-lisp/ecb-master")
(load-file "~/.emacs.d/site-lisp/ecb-master/ecb.el")
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

;;==============================cflow使用Start============================
(require 'cflow-mode)
(defvar cmd nil nil)
(defvar cflow-buf nil nil)
(defvar cflow-buf-name nil nil)
 
(defun yyc/cflow-function (function-name)
  "Get call graph of inputed function. "
  ;(interactive "sFunction name:\n")
  (interactive (list (car (senator-jump-interactive "Function name: "
                                                    nil nil nil))))
  (setq cmd (format "cflow  -b --main=%s %s" function-name buffer-file-name))
  (setq cflow-buf-name (format "**cflow-%s:%s**"
                               (file-name-nondirectory buffer-file-name)
                               function-name))
  (setq cflow-buf (get-buffer-create cflow-buf-name))
  (set-buffer cflow-buf)
  (setq buffer-read-only nil)
  (erase-buffer)
  (insert (shell-command-to-string cmd))
  (pop-to-buffer cflow-buf)
  (goto-char (point-min))
  (cflow-mode)
)
;;==============================cflow使用End============================
