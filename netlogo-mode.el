;; define several class of keywords
(defvar netlogo-keywords
  '(
    "to" "to-report" "report" "if" "ifelse" "end" 
    "globals" "breed" "turtles" "patches" "-own" 
    "extensions"
    )
  "Netlogo primitives & keywords.")

(defvar netlogo-types
  '("none-yet")
  "Netlogo types.")

(defvar netlogo-constants
  '(
    "who" "color" "size" "heading" "xcor" "ycor"
    )
  "Netlogo constants.")

(defvar netlogo-events
  '("test")
  "Netlogo events.")

(defvar netlogo-functions
  '(
    "foreach" "repeat" "forever" "setfont" "settextsize"
    "make" "have" "bye" "macro"
    "output" "stop" "print" "oneof" "kindof"
    "exist" "talkto" "class" "endclass" 
    "and" "or" "not"
    "ask" "let" "show" "set" "random" "diffuse" 
    "right" "left" "forward"
    "setup" "setup-" "setxy" "pen-down"
    "in-radius" "log"
    "clear-all"
    )
  "Netlogo library functions.") 


;; create the regex string for each class of keywords
(defvar netlogo-keywords-regexp (regexp-opt netlogo-keywords 'words))
(defvar netlogo-type-regexp (regexp-opt netlogo-types 'words))
(defvar netlogo-constant-regexp (regexp-opt netlogo-constants 'words))
(defvar netlogo-event-regexp (regexp-opt netlogo-events 'words))
(defvar netlogo-functions-regexp (regexp-opt netlogo-functions 'words)) 
(defvar netlogo-comment-regexp ".*;.*")
(defvar netlogo-var-regexp ":[a-z0-9\\.\\_]*")
(defvar netlogo-func-regexp "\\<\\(help\\)\\>")
(defvar netlogo-quote-regexp "\\\"[a-z0-9\\.\\_]*")

;; clear memory
(setq netlogo-keywords nil)
(setq netlogo-types nil)
(setq netlogo-constants nil)
(setq netlogo-events nil)
(setq netlogo-functions nil)

(setq netlogo-case-fold "true")

;; create the list for font-lock.
;; each class of keyword is given a particular face
(setq netlogo-font-lock-keywords
  `(
    (,netlogo-comment-regexp . font-lock-comment-face)
    (,netlogo-type-regexp . font-lock-type-face)
    (,netlogo-constant-regexp . font-lock-variable-name-face)
    (,netlogo-event-regexp . font-lock-builtin-face)
    (,netlogo-functions-regexp . font-lock-function-name-face)
    (,netlogo-keywords-regexp . font-lock-keyword-face)
    (,netlogo-var-regexp . font-lock-constant-face)
    (,netlogo-func-regexp . font-lock-function-name-face)
    ;; note: order above matters. “netlogo-keywords-regexp” goes last because
    ;; otherwise the keyword “state” in the function “state_entry”
    ;; would be highlighted.
)) 

;; define the mode
(define-derived-mode netlogo-mode text-mode
  "Netlogo"
  "Major mode for editing Netlogo..."
  ;; ...

  ;; code for syntax highlighting
  (setq font-lock-defaults '((netlogo-font-lock-keywords) nil netlogo-case-fold))

  ;; clear memory
  (setq netlogo-keywords-regexp nil)
  (setq netlogo-types-regexp nil)
  (setq netlogo-constants-regexp nil)
  (setq netlogo-events-regexp nil)
  (setq netlogo-functions-regexp nil)

  ;; ...
) 

(add-to-list 'auto-mode-alist '("\\.\\(lg\\|nlogo\\)\\'" . netlogo-mode))
