;;; zjl-hl-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (zjl-hl-next-comment-pos-elisp zjl-hl-next-comment-pos-c
;;;;;;  zjl-hl-find-hl-var-arg-regions-elisp zjl-hl-find-hl-var-arg-regions-c
;;;;;;  zjl-hl-get-body-begin-elisp zjl-hl-get-body-begin-c zjl-hl-disable-global
;;;;;;  zjl-hl-enable-global zjl-hl-disable-global-all-modes zjl-hl-enable-global-all-modes
;;;;;;  zjl-hl-semantic-after-partial-cache-change-hook zjl-hl-init
;;;;;;  zjl-hl-window-scroll-hook zjl-hl-timer-do-every-time zjl-hl-func-too-big-stop-reset
;;;;;;  zjl-hl-what-face zjl-hl-local-variable-and-parameter-region
;;;;;;  zjl-hl-find-regexp-goto-end zjl-hl-symbol-region zjl-hl-local-variable-and-parameter-in-func-region
;;;;;;  zjl-hl-firstscreen-hl-toggle zjl-hl-numberofscreen-to-hl-each-time
;;;;;;  zjl-hl-toobig-not-update-size zjl-hl-toobig-size zjl-hl-normal-size
;;;;;;  zjl-hl-c++-mode-enable-flag zjl-hl-c-mode-enable-flag zjl-hl-make-fun-call-notable)
;;;;;;  "zjl-hl" "zjl-hl.el" (21051 1545 46039 494000))
;;; Generated autoloads from zjl-hl.el

(defvar zjl-hl-make-fun-call-notable t "\
enlarge font of called function, so that become notable")

(custom-autoload 'zjl-hl-make-fun-call-notable "zjl-hl" t)

(defvar zjl-hl-c-mode-enable-flag t "\
Enable c mode highlight when zjl-hl-enable-global-all is called")

(custom-autoload 'zjl-hl-c-mode-enable-flag "zjl-hl" t)

(defvar zjl-hl-c++-mode-enable-flag nil "\
Enable c++ mode highlight when zjl-hl-enable-global-all is called.
Currently only c style file but named as *.cpp is supported")

(custom-autoload 'zjl-hl-c++-mode-enable-flag "zjl-hl" t)

(defvar zjl-hl-normal-size 40000 "\
The size of erea that zjl-hl can highlight without any delay.
You can improve this if your computer has enough performance.")

(custom-autoload 'zjl-hl-normal-size "zjl-hl" t)

(defvar zjl-hl-toobig-size 10000000 "\
The threshold size of function that zjl-hl will stop to highlight since it is too big. The size corresponds to the largest function found in current screen and
+-zjl-hl-numberofscreen-to-hl-each-time screens")

(custom-autoload 'zjl-hl-toobig-size "zjl-hl" t)

(defvar zjl-hl-toobig-not-update-size 1000000 "\
The size of function that zjl-chl will stop to  highlight when the function is modified.
the function means those that inculded in current screen and +-zjl-hl-numberofscreen-to-hl-each-time
screens")

(custom-autoload 'zjl-hl-toobig-not-update-size "zjl-hl" t)

(defvar zjl-hl-numberofscreen-to-hl-each-time 2 "\
The number of screens around current screen to highlight every time.
This variable is define for:
I use idle timer delay to begin highlight current screen when user stop to scroll screen
\(so as to have no delay when scroll),but this cause the highlight happen delay 0.5sec
after we stop scroll screen, and this not feels so good. The way to void this(in some degree)
is highlighting [-zjl-hl-numberofscreen-to-hl-each-time +zjl-hl-numberofscreen-to-hl-each-time]
screens for each time zjl-hl work")

(custom-autoload 'zjl-hl-numberofscreen-to-hl-each-time "zjl-hl" t)

(defvar zjl-hl-firstscreen-hl-toggle nil "\
When not nil and when you open a new buffer, hl buffer before it shown on window.
this will cause delay that feel uncomfortable.Don't enable this unless your computer has
enough performance.")

(custom-autoload 'zjl-hl-firstscreen-hl-toggle "zjl-hl" t)

(autoload 'zjl-hl-local-variable-and-parameter-in-func-region "zjl-hl" "\


\(fn START END)" nil nil)

(autoload 'zjl-hl-symbol-region "zjl-hl" "\


\(fn START END SYMBOL-EXP SYMBOL-FACE OVERRIDE-C-MODE OVERRIDE-MY OVERRIDE-NIL)" nil nil)

(autoload 'zjl-hl-find-regexp-goto-end "zjl-hl" "\


\(fn START END REGEXP)" nil nil)

(autoload 'zjl-hl-local-variable-and-parameter-region "zjl-hl" "\


\(fn START END)" nil nil)

(autoload 'zjl-hl-what-face "zjl-hl" "\


\(fn)" nil nil)

(autoload 'zjl-hl-func-too-big-stop-reset "zjl-hl" "\


\(fn THISBUFFER)" nil nil)

(autoload 'zjl-hl-timer-do-every-time "zjl-hl" "\


\(fn THISBUFFER)" nil nil)

(autoload 'zjl-hl-window-scroll-hook "zjl-hl" "\


\(fn PAR1 PAR2)" nil nil)

(autoload 'zjl-hl-init "zjl-hl" "\


\(fn)" nil nil)

(autoload 'zjl-hl-semantic-after-partial-cache-change-hook "zjl-hl" "\


\(fn UPDATED-TAGS)" nil nil)

(autoload 'zjl-hl-enable-global-all-modes "zjl-hl" "\


\(fn)" t nil)

(autoload 'zjl-hl-disable-global-all-modes "zjl-hl" "\


\(fn)" t nil)

(autoload 'zjl-hl-enable-global "zjl-hl" "\


\(fn MODE)" nil nil)

(autoload 'zjl-hl-disable-global "zjl-hl" "\


\(fn MODE)" nil nil)

(autoload 'zjl-hl-get-body-begin-c "zjl-hl" "\


\(fn START END)" nil nil)

(autoload 'zjl-hl-get-body-begin-elisp "zjl-hl" "\


\(fn START END)" nil nil)

(autoload 'zjl-hl-find-hl-var-arg-regions-c "zjl-hl" "\


\(fn START END)" nil nil)

(autoload 'zjl-hl-find-hl-var-arg-regions-elisp "zjl-hl" "\


\(fn START END)" nil nil)

(autoload 'zjl-hl-next-comment-pos-c "zjl-hl" "\


\(fn START END)" nil nil)

(autoload 'zjl-hl-next-comment-pos-elisp "zjl-hl" "\


\(fn START END)" nil nil)

;;;***

;;;### (autoloads nil nil ("zjl-hl-pkg.el") (21051 1545 53096 462000))

;;;***

(provide 'zjl-hl-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; zjl-hl-autoloads.el ends here
