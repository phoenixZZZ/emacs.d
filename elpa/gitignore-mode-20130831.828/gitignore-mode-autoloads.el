;;; gitignore-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (gitignore-mode) "gitignore-mode" "gitignore-mode.el"
;;;;;;  (21049 6423 129976 859000))
;;; Generated autoloads from gitignore-mode.el

(autoload 'gitignore-mode "gitignore-mode" "\
A major mode for editing .gitignore files.

\(fn)" t nil)

(dolist (pattern (list (rx "/.gitignore" string-end) (rx "/.git/info/exclude" string-end) (rx "/git/ignore" string-end))) (add-to-list 'auto-mode-alist (cons pattern 'gitignore-mode)))

;;;***

;;;### (autoloads nil nil ("gitignore-mode-pkg.el") (21049 6423 134550
;;;;;;  685000))

;;;***

(provide 'gitignore-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; gitignore-mode-autoloads.el ends here
