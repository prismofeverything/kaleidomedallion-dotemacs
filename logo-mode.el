;; define several class of keywords
(defvar logo-keywords
  '(
    "to" "to-report" "report" "if" "ifelse" "end" 
    "show" "globals" "set" "random" 
    "ask" "breed" "turtles" "patches" "diffuse" "-own" 
    "who" "rt" "color" 
    )
  "Logo primitives & keywords.")

;(defun multiply-by-seven (number)
;  "Multiply NUMBER by seven."
;  (* 7 number))

(defvar logo-types
  '("none-yet")
  "Logo types.")

(defvar logo-constants
  '("\"TRUE" "\"FALSE")
  "Logo constants.")

(defvar logo-events
  '("test")
  "Logo events.")

(defvar logo-functions
  '("foreach" "repeat" "forever" "setfont" "settextsize"
    "make" "have" "bye" "macro"
    "output" "stop" "print" "oneof" "kindof"
    "exist" "talkto" "class" "endclass" 
    )
  "Logo library functions.") 


;; create the regex string for each class of keywords
(defvar logo-keywords-regexp (regexp-opt logo-keywords 'words))
(defvar logo-type-regexp (regexp-opt logo-types 'words))
(defvar logo-constant-regexp (regexp-opt logo-constants 'words))
(defvar logo-event-regexp (regexp-opt logo-events 'words))
(defvar logo-functions-regexp (regexp-opt logo-functions 'words)) 
(defvar logo-comment-regexp ".*;.*")
(defvar logo-var-regexp ":[a-z0-9\\.\\_]*")
(defvar logo-func-regexp "\\<\\(help\\)\\>")
(defvar logo-quote-regexp "\\\"[a-z0-9\\.\\_]*")
;(info "(elisp)Regexp Functions")

;; clear memory
(setq logo-keywords nil)
(setq logo-types nil)
(setq logo-constants nil)
(setq logo-events nil)
(setq logo-functions nil)

(setq logo-case-fold "true")

;; create the list for font-lock.
;; each class of keyword is given a particular face
(setq logo-font-lock-keywords
  `(
    (,logo-comment-regexp . font-lock-comment-face)
    (,logo-type-regexp . font-lock-type-face)
    (,logo-constant-regexp . font-lock-constant-face)
    (,logo-event-regexp . font-lock-builtin-face)
    (,logo-functions-regexp . font-lock-function-name-face)
    (,logo-keywords-regexp . font-lock-keyword-face)
    (,logo-var-regexp . font-lock-constant-face)
    (,logo-func-regexp . font-lock-function-name-face)
    ;; note: order above matters. “logo-keywords-regexp” goes last because
    ;; otherwise the keyword “state” in the function “state_entry”
    ;; would be highlighted.
)) 

;; define the mode
(define-derived-mode logo-mode text-mode
  "Berkeley Logo"
  "Major mode for editing Berkeley Logo..."
  ;; ...

  ;; code for syntax highlighting
  (setq font-lock-defaults '((logo-font-lock-keywords) nil logo-case-fold))

  ;; clear memory
  (setq logo-keywords-regexp nil)
  (setq logo-types-regexp nil)
  (setq logo-constants-regexp nil)
  (setq logo-events-regexp nil)
  (setq logo-functions-regexp nil)

  ;; ...
) 

(add-to-list 'auto-mode-alist '("\\.\\(lg\\|nlogo\\)\\'" . logo-mode))
