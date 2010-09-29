(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;(setq iswitchb-mode t)
;(setq erlang-root-dir "/home/omnibus/erlang/otp_src_R11B-2")

(set-frame-height (selected-frame) 56)
(set-frame-width (selected-frame) 202) 

;; (add-to-list 'load-path "~/slime/")
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/matlab-emacs/")
(add-to-list 'load-path "~/.emacs.d/rhtml/")
;; (add-to-list 'load-path "~/.emacs.d/clojure-mode/")
(add-to-list 'load-path "~/el/")
(add-to-list 'load-path "~/sclang/editors/scel/el/")
;; (add-to-list 'load-path "~/dogmanboat/el/")


(load "~/Downloads/nxml-mode-20041004/rng-auto.el")
(require 'actionscript-mode)
(require 'nxml-mode)
(require 'rhtml-mode)
;; (require 'clojure-mode)
(require 'haml-mode)
(require 'sclang)
(require 'osc)
(require 'haxe-mode)
;; (require 'sccollab)

(add-to-list 'load-path "~/src/emacs-jabber-0.8.0")
(load "jabber-autoloads")


;; matlab / -----------------------
(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)

;; org mode -----------------------
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; futzing with indentation ---------------------------------------------------
(setq c-basic-offset 4)
(setq c-indent-level 4)
(setq tab-width 4)
(setq make-backup-files nil)

(set-default 'indent-tabs-mode nil)

;; slime setup ----------------------------------------
;; (require 'slime)
;; (slime-setup '(slime-repl))

;; (add-hook 'slime-load-hook (lambda () (require 'slime-fuzzy)))
;; (add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
;; (add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))

;; (setq inferior-lisp-program "/usr/local/bin/sbcl"
;;       lisp-indent-function 'common-lisp-indent-function
;;       slime-complete-symbol-function 'slime-fuzzy-complete-symbol
;;       common-lisp-hyperspec-root "/Users/rspangler/HyperSpec/")

;; javascript setup ------------------------------------
;; (autoload 'js2-mode "js2" nil t)
;; (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;; js2 ------------------------------------------------------

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(autoload 'espresso-mode "espresso")

(defun my-js2-indent-function ()
 (interactive)
 (save-restriction
   (widen)
   (let* ((inhibit-point-motion-hooks t)
          (parse-status (save-excursion (syntax-ppss (point-at-bol))))
          (offset (- (current-column) (current-indentation)))
          (indentation (espresso--proper-indentation parse-status))
          node)

     (save-excursion

       ;; I like to indent case and labels to half of the tab width
       (back-to-indentation)
       (if (looking-at "case\\s-")
           (setq indentation (+ indentation (/ espresso-indent-level 2))))

       ;; consecutive declarations in a var statement are nice if
       ;; properly aligned, i.e:
       ;;
       ;; var foo = "bar",
       ;;     bar = "foo";
       (setq node (js2-node-at-point))
       (when (and node
                  (= js2-NAME (js2-node-type node))
                  (= js2-VAR (js2-node-type (js2-node-parent node))))
         (setq indentation (+ 4 indentation))))

     (indent-line-to indentation)
     (when (> offset 0) (forward-char offset)))))

(defun my-indent-sexp ()
 (interactive)
 (save-restriction
   (save-excursion
     (widen)
     (let* ((inhibit-point-motion-hooks t)
            (parse-status (syntax-ppss (point)))
            (beg (nth 1 parse-status))
            (end-marker (make-marker))
            (end (progn (goto-char beg) (forward-list) (point)))
            (ovl (make-overlay beg end)))
       (set-marker end-marker end)
       (overlay-put ovl 'face 'highlight)
       (goto-char beg)
       (while (< (point) (marker-position end-marker))
         ;; don't reindent blank lines so we don't set the "buffer
         ;; modified" property for nothing
         (beginning-of-line)
         (unless (looking-at "\\s-*$")
           (indent-according-to-mode))
         (forward-line))
       (run-with-timer 0.5 nil '(lambda(ovl)
                                  (delete-overlay ovl)) ovl)))))
(defun my-js2-mode-hook ()
 (require 'espresso)
 (setq espresso-indent-level 4
       indent-tabs-mode nil
       c-basic-offset 8)
 (c-toggle-auto-state 0)
 (c-toggle-hungry-state 1)
 (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
 (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
 (define-key js2-mode-map [(meta control \;)]
   '(lambda()
      (interactive)
      (insert "/* -----[ ")
      (save-excursion
        (insert " ]----- */"))
      ))
 (define-key js2-mode-map [(return)] 'newline-and-indent)
 (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
 (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
 (define-key js2-mode-map [(control meta q)] 'my-indent-sexp)
 (if (featurep 'js2-highlight-vars)
   (js2-highlight-vars-mode))
 (message "My JS2 hook"))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)


;; factor setup -----------------------------------------------------
(load-file "/Users/rspangler/factor/misc/factor.el")
(setq factor-binary "/Users/rspangler/factor/factor")
(setq factor-image "/Users/rspangler/factor/factor.image")

;; forth setup --------------------------------------------------
(autoload 'forth-mode "gforth.el")
(setq auto-mode-alist (cons '("\\.fs\\'" . forth-mode)
			    auto-mode-alist))
(autoload 'forth-block-mode "gforth.el")
(setq auto-mode-alist (cons '("\\.fb\\'" . forth-block-mode)
			    auto-mode-alist))
(add-hook 'forth-mode-hook (function (lambda ()
   ;; customize variables here:
   (setq forth-indent-level 4)
   (setq forth-minor-indent-level 2)
   (setq forth-hilight-level 3)
   ;;; ...
)))

;; (autoload 'longlines-mode "longlines.el" "minor mode for editing long text lines" t)
;; (add-hook 'text-mode-hook 'longlines-mode)

(add-to-list 'auto-mode-alist '("\\.as\\'" . actionscript-mode))
;; (setq auto-mode-alist (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.\\(abbrev\\)\\'" . lisp-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.\\(rhtml\\|liquid\\|erb\\)\\'" . rhtml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.\\(rake\\|treetop\\)\\'" . ruby-mode) auto-mode-alist))
;; (setq auto-mode-alist (cons '("\\.\\(clj\\)\\'" . clojure-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.\\(haml\\)\\'" . haml-mode) auto-mode-alist))

;(autoload 'erlang-mode "erlang-mode" nil t)
;(setq auto-mode-alist (append '(("\\.erl$" . erlang-mode))
;			      auto-mode-alist))
;; (autoload 'javascript-mode "javascript" nil t)
;; (setq auto-mode-alist (append '(("\\.js$" . javascript-mode))
;; 			      auto-mode-alist))
(autoload 'chuck-mode "chuck-mode" nil t)
(setq auto-mode-alist (append '(("\\.ck$" . chuck-mode))
			      auto-mode-alist))

(load "netlogo-mode.el")

;(setq inferior-lisp-program "/usr/bin/cmucl")
;(add-to-list 'load-path "/home/omnibus/lisp/slime-2.0")
;(require 'slime)
;(slime-setup)

;(global-font-lock-mode)
(show-paren-mode)
;(set-background-color "#345")
;;;;;(set-background-color "#222222")
;;;;;(set-foreground-color "#eee")

(set-background-color "#111")
(set-foreground-color "#eee")

;(set-background-color "#eee")
;(set-foreground-color "#111")

;(merry-go-round)
;(default-color)
;(smoke-mirror)
;(grey-tower)
;(lost-ocean)
;(spring-crypt)

;(madness-octopus)
;(monkey-spoke)
;(alagharana-pee)
;(dramatic-terminal)
;(desert-trek)
;(martian-oval)
;(crystal-zoom)
;(arbitrary-malleable)

;(neutral-sawdust)
;(after-flower)
;(sand-turn)
;(pewter-vine)
;(mandrake-elevator)

(setq tramp-syntax 'url)
(require 'tramp)

(defun fc-eval-and-replace ()
  (interactive)
  (backward-kill-sexp)
  (prin1 (eval (read (current-kill 0)))
	 (current-buffer)))

(defun shell-command-replace ()
  (interactive)
  (backward-kill-sentence)
  (shell-command (current-kill 0) (point)))

(global-set-key (kbd "C-c e") 'fc-eval-and-replace)
(global-set-key (kbd "C-!") 'shell-command-replace)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-c m") 'pop-global-mark)

(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)

(global-set-key (kbd "M-s") 'isearch-forward-regexp)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)

(global-set-key (kbd "C-z") 'cyclebuffer-forward)
(global-set-key (kbd "M-z") 'cyclebuffer-backward)

(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
(global-set-key (kbd "C-c i") 'indent-region)

(global-set-key (kbd "M-m") 'bookmark-set)
(global-set-key (kbd "M-j") 'bookmark-jump)

(global-set-key (kbd "C-,") 'other-window)
(global-set-key (kbd "C-'") 'next-buffer)

(defun move-line (n)
  (interactive "p")
  (let ((col (current-column))
	start
	end)
    (beginning-of-line)
    (setq start (point))
    (end-of-line)
    (forward-char)
    (setq end (point))
    (let ((line-text (delete-and-extract-region start end)))
      (forward-line n)
      (insert line-text)
      (forward-line -1)
      (forward-char col))))


(defun move-line-up (n)
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key [(meta up)] 'move-line-up)
(global-set-key [(meta down)] 'move-line-down)

;;; abbreviations

(setq abbrev-mode t)
(cond ((file-exists-p "~/.abbrev")
       (read-abbrev-file "~/.abbrev")))
(setq dabbrev-case-replace nil)
(setq save-abbrevs t)


;; (add-to-list 'load-path "~/src/emacs-w3m-1.4.4/")

;; (require 'w3m-load)
;; (require 'w3m-bookmark)
;; (setq w3m-home-page "http://www.google.com")

;; (defun w3m-goto-bookmark (bookmark)
;;   (interactive "sgoto bookmark: ")
;;   (w3m-copy-buffer)
;;   (w3m-bookmark-view)
;;   (search-forward bookmark)
;;   (backward-char)
;;   (w3m-view-this-url (w3m-url-at-point)))

;; (add-hook 'w3m-mode-hook
;; 	  '(lambda ()
;; 	     (define-key w3m-mode-map "\S-f" 'w3m-view-next-page)
;; 	     (define-key w3m-mode-map "\S-n" 'w3m-copy-buffer)
;; 	     (define-key w3m-mode-map (kbd "M-`") 'w3m-goto-bookmark)))

;; (setq *w3m-default-display-inline-images* t)

;; (global-set-key (kbd "M-`") 'w3m-goto-bookmark)

;; (defun open-bookmark-file ()
;;   (interactive)
;;   (switch-to-buffer (w3m-bookmark-buffer)))


;(global-set-key (kbd "C-t") 'indent-for-tab-command)

;(set-default-font       "-adobe-courier-bold-r-normal--17-120-100-100-m-100-iso8859-13")
;(x-list-fonts "*")



; ------------------------------  attempt to be awesome

;; (defun expand-link ()
;;   (interactive))

;; (defun expand-form-item ()
;;   (interactive)
;;   (backward-kill-word 1)
;;   (let ((type (current-kill 0)))
;;     (progn
;;       (insert (concat "<Synthetic name=\"layout\">\n <Str name=\"type\">\n"
;; 		      type
;; 		      "\n </Str>\n</Synthetic>\n"))
;;       (let ((func (concat "(expand-" type ")")))
;; 		(eval (read func))))))

; ------------------------------------------


(defun reload-emacs ()
  (interactive)
  (load-file "~/.emacs")
  (load-file "~/.emacs"))

(global-set-key (kbd "C-c z") 'reload-emacs)

;; (setf slime-translate-to-lisp-filename-function
;;       (lambda (filename)
;;         (subseq filename (length "/ssh:rspangler@madness:")))
;;       slime-translate-from-lisp-filename-function
;;       (lambda (filename)
;;         (concat "/ssh:rspangler@madness:" filename)))

;(require 'ipython)

;(defun py-uncomment-region (beg end &optional arg)
;  (interactive "r\nP")
;  (py-comment-region (point) (mark) '(4)) (mark))

;(define-key py-mode-map "\C-c$" 'py-uncomment-region)


;erc stuff

;(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT"))
;(add-hook 'erc-after-connect '(lambda (server nick)
;				(erc-message "PRIVMSG" "NickServ identify ord9949")))

;(require 'erc-autojoin)
;(erc-autojoin-mode 1)
;(setq erc-autojoin-channels-alist
;	  `(("freenode.net" "#emacs" "#erlang" "#chuck" "#lisp" "#python")))

;(require 'erc-match)
;(setq erc-keywords '("patchwork"))
;(erc-match-mode)

;(require 'erc-ring)
;(erc-ring-mode t)

;(require 'erc-netsplit)
;(erc-netsplit-mode t)

;(defun erc-connect ()
;  (interactive)
;  (erc-select :server "irc.freenode.net" :port 6667 :nick 'patchwork))
;(global-set-key (kbd "C-c q") 'erc-connect)


(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)




(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(jabber-account-list (quote (("ryan.spangler@gmail.com/Home" (:password . "ord_9949") (:network-server . "talk.google.com") (:port . 5223) (:connection-type . ssl)))))
 '(sclang-help-directory "/Users/rspangler/sclang/Help")
 '(sclang-help-path (quote ("@PKG_DATA_DIR@/Help" "/Users/rspangler/sclang/Help")))
 '(sclang-library-configuration-file "")
 '(sclang-program "/Users/rspangler/sclang/sclang")
 '(sclang-runtime-directory "/Users/rspangler/sclang")
 '(sclang-source-directory "/Users/rspangler/sclang/SCClassLibrary")
 '(tab-width 4))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (min-colors 88) (background dark)) (:foreground "OrangeRed1"))))
 '(font-lock-constant-face ((((class color) (min-colors 88) (background dark)) (:foreground "DeepSkyBlue1"))))
 '(font-lock-function-name-face ((((class color) (min-colors 88) (background dark)) (:foreground "MediumPurple2"))))
 '(font-lock-keyword-face ((((class color) (min-colors 88) (background dark)) (:foreground "LightSeaGreen"))))
 '(font-lock-string-face ((((class color) (min-colors 88) (background dark)) (:foreground "IndianRed1"))))
 '(font-lock-type-face ((((class color) (min-colors 88) (background dark)) (:foreground "SpringGreen1"))))
 '(font-lock-variable-name-face ((((class color) (min-colors 88) (background dark)) (:foreground "gold1")))))




;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
