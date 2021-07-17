;; 
;; 1998-2008,2016 (p) A. Tenbusch
;; 
;; 
;; pie-mode
;; pie-xml-mode
;; configuration imenu
;; 
;; emacs -q -l ~/develop/cxproc/contrib/pie/elisp/pie.el /tmp/test.txt &

;; external programs: xsltproc, cxproc, ...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; pie global settings
;;;

(unless (getenv "CXP_PATH")
  (setenv "CXP_PATH" (concat (file-name-directory (buffer-file-name)) "..//"))
  )

(set-language-environment 'utf-8)

(if window-system
    (progn
      ;;(global-font-lock-mode t)
      (require 'imenu)
      (require 'speedbar)
      (speedbar-add-supported-extension ".txt")
      (speedbar-add-supported-extension ".pie")
      (require 'goto-addr)
      )
  )

(require 'time-stamp)
(add-hook 'write-file-hooks 'time-stamp)
(setq time-stamp-start "Speicherung[ \t]+\\\\?[\"<]+")
(setq time-stamp-format "%f %:d.%:m.%:y %02H:%02M:%02S %u")
;;

;(speedbar-frame-mode 1)


;  (local-set-key    [print] 'txt2x-ps-print)

;  (local-set-key    [S-f4]  'txt2x-wcount-on-region)
;  (local-set-key      [f4]  'txt2x-wcount-paragraph)

;  (local-set-key      [f6]  'txt2x-search-current-word)
;  (local-set-key      [C-f6]  'txt2x-search-in-buffer-file)
;  (local-set-key      [S-f6]  'txt2x-search)

;  (local-set-key    [f8] 'hide-body)
;  (local-set-key    [f9] 'show-subtree)


;; (setq auto-mode-alist
;;       (append
;;        (list
;; 	'("\\.cxp" . xml-mode)
;; 	)
;;        auto-mode-alist))


(define-minor-mode pie-minor-mode
  "This is the global minor mode for PIE."
  :lighter " PIE" :global nil

  ;;     (define-key-after
  ;;       'mode-line-mode-menu
  ;;       (pie-plain-minor-mode menu-item "PIE"  :button pie-plain-minor-mode
  ;; 		      (:toggle bound-and-true-p outline-minor-mode))  
  ;;       )

  (if (buffer-file-name)
      (if (string= (file-name-extension (buffer-file-name)) "txt")
	  (pie-plain-minor-mode)
	(if (string= (file-name-extension (buffer-file-name)) "pie")
	    (pie-xml-minor-mode)
	  (message "Unknown extension")
	  )
	)
    (pie-plain-minor-mode)
    )

  (local-set-key "\e1"
		 (lambda () ""
		   (interactive)
		   (insert "[]()")
		   (backward-char 3)))

  (local-set-key "\e2"
		 (lambda () ""
		   (interactive)
		   (let ((begin-region (mark))
			 (end-region (point)))
		     (if (> (- end-region begin-region) 0)
			 (progn
			   (goto-char begin-region)
			   (insert "“")
			   (goto-char (+ end-region 1))
			   (insert "”")
					;(goto-char end-region)
			   )
		       (progn
			 (insert "“”")
			 (backward-char 1)
			 )
		       )
		     )
		   )
		 )
  ;;
  )

(add-hook 'text-mode-hook 'pie-minor-mode)
;(add-hook 'text-mode-hook 'outline-minor-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; pie plain
;;;

(defvar pie-plain-imenu-generic-expression
  '(
    ("Sections" "^[*%]+.*" 0)
    ("TODO"     "^\\(TODO|TEST|BUG|TARGET|REQ\\):.*"   0)
    ("Remarks"  "^[;]+.*"  0)
    ("Markups"  "^[#]+.*"   0)
    ("Figures"  "^Abb\\.\\s-+\\([-A-Za-z0-9_.]+\\)\\s-*:" 1))
  "Imenu generic expression for PIE mode.  See `imenu-generic-expression'.")


(defvar pie-plain-font-lock-keywords
  '(     ; Reihenfolge ist wichtig
   ;; section
   ("^ *[\*%]+.*$" . font-lock-function-name-face)
   ;; CPP-Anweisungen
   ("^[ ;]*#+.*$" . font-lock-keyword-face)
   ;; Kommentare
   ("^ *;+.*$" . font-lock-comment-face)
					; cite
					;("\\[[a-zA-Z0-9\,\-]*\\]" . font-lock-variable-name-face)
   ;; Todo
   ("TODO:" . font-lock-reference-face)
   ("TEST:" . font-lock-reference-face)
   ("BUG:" . font-lock-reference-face)
   ("TARGET:" . font-lock-reference-face)
   ("REQ:" . font-lock-reference-face)
   ("DONE:" . font-lock-reference-face)
   ;; Abb
   ("[Aa][Bb][Bb][\\.:]" . font-lock-reference-face)
   ("[Ff][Ig][Gg][\\.:]" . font-lock-reference-face)
   ;; Tab
					;("[Tt][Aa][Bb][\\.:]" . font-lock-reference-face)
   ;; Tags
   ("[@#][a-zA-ZäöüÄÖÜß\\-_]+" . font-lock-reference-face)
   ;; Aufzaehlungen
   ("^ *[\-\+]+" . font-lock-variable-name-face)
   ;; quotes
   ("[><]+" . font-lock-variable-name-face)
					; ldots
					;("\\.\\.\\." . font-lock-variable-name-face)
					; i.d.R.
					;("i\\. *d\\. *R\\." . font-lock-variable-name-face)
					; z.B.
					;("z\\. *B\\." . font-lock-variable-name-face)
					; d.h.
					;("d\\. *h\\." . font-lock-variable-name-face)
   )
  "font-lock expressions for PIE mode.  See `'.")


(defun pie-plain-minor-mode ()
  "This is the plain text mode for PIE."

  (interactive)
  ;;
  (auto-fill-mode -1)
  ;(setq fill-column 70)
  ;;
  (line-number-mode 1)
  (column-number-mode 1)
  ;;
  (local-set-key    [S-f1] 'pie-plain-insert-task)
  ;;
  (local-set-key [C-f1] 'pie-plain-toggle-todo)
  (if window-system
      (progn
	;; font-lock
	(font-lock-mode t)
	(setq font-lock-keywords pie-plain-font-lock-keywords)
	(font-lock-fontify-buffer)
	;; BUG: font-lock isnt active first time
	;;
	(goto-address)
	;;  (goto-address-fontify)
	;;
	;; imenu
	;; sonst entsprechend imenu-example--* anpassen
	(set (make-local-variable 'imenu-generic-expression)
	     pie-plain-imenu-generic-expression)
	(setq
	 imenu-case-fold-search nil
	 speedbar-tag-hierarchy-method '(speedbar-trim-words-tag-hierarchy)
	 )
	)
    (progn				; Text-Modus
      )
    )
  (set (make-local-variable 'pie-mode-enabled) t)
  (message "'pie-plain-minor-mode' loaded")
;  (run-mode-hooks 'text-mode-hook)
  )
;; (pie-plain-minor-mode)


(defun pie-plain-toggle-todo ()
  ""
  (interactive)
  (let ((point-origin (point)))
					;(forward-paragraph 1)
    (move-end-of-line 1)
    (let ((point-end (point)))
					;(forward-paragraph -1)
      (move-beginning-of-line 1)
      (let ((point-begin (point)))
	(if (re-search-forward "TODO: " point-end t)
	    (replace-match "DONE: " nil nil)
	  (progn (goto-char point-begin)
		 (if (re-search-forward "DONE: " point-end t)
		     (replace-match "TODO: " nil nil)
		   (progn (goto-char point-begin)
			  (insert "\nTODO: ")))
		 )
	  )
	)
      )
    (goto-char point-origin)
    )
  )
;; (pie-plain-toggle-todo)


(defun pie-plain-insert-task ()
  "insert a task element"
  (interactive)
  ;;
  (setq pie-position (point))
  (setq pie-task-date-str
	(read-from-minibuffer "date: "))
  (setq pie-task-h-str
	(read-from-minibuffer "h: "))
  ;;
  (insert (concat "TODO: "
		  (if (> (length pie-task-date-str) 0)
		      (concat pie-task-date-str " ")
		    )
		  pie-task-h-str " | \n\n")
	  )
					;(goto-char (match-end 0))
  (previous-line 2)
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
(defun pie-alphabet ()
  "writes UTF-8 Alphabet into buffer "Alphabet"."
  (interactive)
  (let ()
    (switch-to-buffer (get-buffer-create "Alphabet"))
    (setq i 0)
    (while (< i 256)
      (insert (format "%3o %3d %3x %3c\n" i i i i))
      (setq i (+ i 1))
      )
    )
  )
;; (pie-alphabet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; pie XML
;;;

(defun pie-xml-minor-mode ()
  ""
  (interactive)

  (setq nxml-sexp-element-flag t)
  ;;
  (setq rng-schema-locating-files (append (list "C:/User/develop/cxproc-build-vc/trunk/xml/schema/schemas.xml") rng-schema-locating-files))

  (setq nxml-section-element-name-regexp "section")
  (setq nxml-heading-element-name-regexp "h")

  (auto-fill-mode -1)
  (setq fill-column 70)
  ;;
  (line-number-mode 1)
  (column-number-mode 1)
  ;;
  ;(local-set-key    [f7] 'browse-url-of-buffer)
  (local-set-key    [S-f1] 'pie-xml-insert-task)

;  (run-mode-hooks 'pie-xml-minor-mode-hook)
  (set (make-local-variable 'pie-mode-enabled) t)
  (message "'pie-xml-minor-mode' loaded")
  )


(defun pie-xml-insert-task ()
  "insert a task element"
  (interactive)
  ;;
  (setq pie-position (point))
  (setq pie-task-date-str
	(read-from-minibuffer "date: "))
  (setq pie-task-h-str
	(read-from-minibuffer "h: "))
  ;;
  (insert (concat "<task>\n"
		  "  <h>"
		  (if (> (length pie-task-date-str) 0)
		      (concat "<date>" pie-task-date-str "</date> ")
		    )
		  pie-task-h-str "</h>\n"
		  "</task>\n")
	  )
  (indent-region pie-position (point) nil)
  (re-search-backward "<date>" nil t)
  (goto-char (match-end 0))
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; pie transform
;;;

(defvar pie-filename-pie
  (concat (getenv "HOME") "/tmp/emacs.pie")
  "")

(defvar pie-cxproc-command
  (concat "cxproc -f")
  "")


(defun pie-plain-to-xml-buffer (&optional buffer)
  "ruft pie auf um den Buffer von pie- in PIE-Syntax zu bringen."

  (interactive)

  (setq pie-cxproc-command
	(read-from-minibuffer "Command: " pie-cxproc-command))
  (shell-command-on-region (point-min) (point-max) pie-cxproc-command
			   "cxproc.pie" nil "cxproc.err" nil)
  (switch-to-buffer "cxproc.pie")
  (nxml-mode)
  ;(find-file pie-filename-pie)
  )
;; (pie-plain-to-xml-buffer)


(defun pie-plain-to-xml-clipboard ()
  "ruft pie auf um den Clipboard von pie- in PIE-Syntax zu bringen."

  (interactive)

  (switch-to-buffer (get-buffer-create "clip.txt"))
  (insert (current-kill 0))
  (pie-plain-to-xml-buffer)
  )
;; (pie-plain-to-xml-clipboard)


(defun pie-plain-to-utf8 ()
  "converts simple markups to single UTF-8 chars"

  (interactive)
  (beginning-of-buffer)
  (query-replace ">>" "„")
  (beginning-of-buffer)
  (query-replace "<<" "“")
  (beginning-of-buffer)
  (query-replace "&" "&amp;")
  (beginning-of-buffer)
  (query-replace "->" "→")
  )
;; (pie-plain-to-utf8)


(defun pie-utf8-to-iso8859-1 ()
  "converts single UTF-8 chars to iso8859-1"

  (interactive)
  (beginning-of-buffer)
  (query-replace "\xc3\xbc" "ü")
  (beginning-of-buffer)
  (query-replace "\xc3\xb6" "ö")
  (beginning-of-buffer)
  (query-replace "\xc3\xa4" "ä")
  )
;; (pie-utf8-to-iso8859-1)


;; (defun pie-parify-buffer ()
;;   "dd"

;;   (interactive)

;;   ;; 
;;   (beginning-of-buffer)
;;   (while (re-search-forward "^\"\t" nil t)
;;     (replace-match "- " nil nil))
;;   ;; 
;;   (beginning-of-buffer)
;;   (while (re-search-forward "^o\t" nil t)
;;     (replace-match "-- " nil nil))
;;   ;; 
;;   (beginning-of-buffer)
;;   (while (re-search-forward "^[0-9]+\\.\t" nil t)
;;     (replace-match "+ " nil nil))
;;   ;; 
;;   (beginning-of-buffer)
;;   (while (search-forward-regexp "\n" nil t)
;;     (insert "\n")
;;     (forward-char 1)
;;     )

;;   ;(beginning-of-buffer)
;;   (pie-piefy-buffer)
;;   )
;; ;; (pie-parify-buffer)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; pie keywords

(defun pie-extract-keys (file-name-all)
  "returns a list of filtered keywords from a text file."

  (let 
      ((list-of-keys "")
       (case-fold-search nil))

    (find-file file-name-all)
    ;(font-lock-mode -1)
    (setq list-of-words (split-string (buffer-string)))
    (kill-this-buffer)

    (while list-of-words
      (if (and
	   (not (string-match (car list-of-words) list-of-keys))
	   (string-match "^[A-Z]" (car list-of-words))
	   )
	  (setq list-of-keys (concat list-of-keys " " (car list-of-words)))
	)
      (setq list-of-words (cdr list-of-words))
      )
					;(setq case-fold-search case-fold-search-saved)
    list-of-keys
    )
  )
;; (pie-extract-keys "/tmp/e.el")
;; (pie-extract-keys "/tmp/e")


(defun pie-toc ()
  ""
  (interactive)

  (let ((list-of-headers nil))
    ;;
    (setq buffer-tmp (get-buffer-create "*pie-el*"))
    (shell-command (concat
		    "xsltproc.exe "
		    "\"" (getenv "HOME") "/Program Files/cxproc/contrib/pie/xsl/plain/LispStruct.xsl\" "
		    (if (string-match "\\.pie$" (buffer-name))
			(buffer-file-name)
		      (concat (getenv "HOME") "/arbeit/tmp/all.xml")
		      )
		    )
		    buffer-tmp nil)
    (eval-buffer buffer-tmp)
    (kill-buffer buffer-tmp)
    ;;
    (if (get-buffer "*pie-toc*")
	(kill-buffer "*pie-toc*"))
    (switch-to-buffer (get-buffer-create "*pie-toc*"))
    ;;
    (dolist (h list-of-headers)
      (setq p (point))
      (insert h "\n")
      (setq overlay-i (make-overlay p (point)))
      (overlay-put overlay-i 'str-to-search h)
      (overlay-put overlay-i 'mouse-face 'highlight)
      )
    (local-set-key [mouse-1] (lambda ()
			       ""
			       (interactive)
			       (pie-search (current-word))
			       ))
    (local-set-key [mouse-2] 'pie-search-overlay)
    (delete-other-windows)
    (beginning-of-buffer)
    )
  )
;; (pie-toc)


(defun pie-search-overlay (event)
  ""

  (interactive "e")

  (save-excursion
    (let ((overlay-i (car (overlays-at (posn-point (event-start event))))))
      ;; search for the string of current text line
      ;(pie-search (overlay-get overlay-i 'str-to-search))
      ;;(pie-search (concat "<H>" (replace-regexp-in-string "^ +" "" (overlay-get overlay-i 'str-to-search)) "</H>"))
      (pie-search (replace-regexp-in-string "^ +" "" (overlay-get overlay-i 'str-to-search)))
      )
    )
  )
;; (pie-search-overlay)


(defun pie-decode-wiki-to-pie ()
  "converts Umlaute etc. into XML entities"

  (interactive)
  (let ((refactor-list '(
					;("\\[\\[\\([^\\[\\|\\]]+\\)\\|\\([^\\[\\|\\]]+\\)\\]\\]" . "\1")
					;("\\[\\[\\([^\\[\\|\\]]+\\)\\]\\]" . "\1")
			 ("\\[\\[" . " ")
			 ("\\]\\]" . " ")
			 ("|" . " ")
			 ;;
			 ("^;" . "\n-")
			 ;;
			 ("^###" . "\n+++")
			 ("^##" . "\n++")
			 ("^#" . "\n+")
			 ;;
			 ("^\\*\\*\\*" . "\n---")
			 ("^\\*\\*" . "\n--")
			 ("^\\*" . "\n-")
			 ;;
			 (" *=+$" . "\n")
			 ("^===" . "\n***")
			 ("^==" . "\n**")
			 ("^=" . "\n*")
			 ;;
			 ("\\b''+" . ">>")
			 ("''+\\b" . "<<")
			 ("„" . ">>")
			 ("“" . "<<")
			 ;;
			 ("\n\n+" . "\n\n")
			 )))
    (while refactor-list
      (setq
       case-fold-search nil
       from-string (car (car refactor-list))
         to-string (cdr (car refactor-list))
       )
      (beginning-of-buffer)
      (query-replace-regexp from-string to-string)
					;(replace-string from-string to-string)
      (setq refactor-list (cdr refactor-list))
      )
    )
  )
;; (pie-decode-wiki-to-pie)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; pie search

(defun pie-search-overlay (event)
  ""

  (interactive "e")

  (save-excursion
    (let ((overlay-i (car (overlays-at (posn-point (event-start event))))))
      ;; search for the string of current text line
      ;(pie-search (overlay-get overlay-i 'str-to-search))
      ;;(pie-search (concat "<H>" (replace-regexp-in-string "^ +" "" (overlay-get overlay-i 'str-to-search)) "</H>"))
      (pie-search (replace-regexp-in-string "^ +" "" (overlay-get overlay-i 'str-to-search)))
      )
    )
  )
;; (pie-search-overlay)


(defun pie-search (&optional muster-i buffer-c)
  "liest das Muster vom Minibuffer und ruft das XSLT/grep auf."

  (interactive)
    
    (if (not muster-i)
	;; Regexp lesen
	(setq muster-i (read-from-minibuffer
			(format "Muster für search.bat: ")))
      )
    ;; replace spaces at muster-i
    ; quotes are different beween text/plain and text/xml
    (setq muster-i (replace-regexp-in-string "^ +" "" (replace-regexp-in-string "[ \\n]+$" "" muster-i)))

    (if (> (length muster-i) 1)
	(progn
	  ;(cd (concat (getenv "MYBASE_DIR") "\\xml"))
	  ;(cd (getenv "MYBASE_DIR"))
	  (setq case-fold-search-old case-fold-search
		case-fold-search nil
		search-command
		(shell-command-to-string
;		 (concat "xsltproc.exe --stringparam pattern \""
;			 muster-i
;			 "\" xsl/ShellSearch.xsl ../config.xml"))
		 (concat "cd " (getenv "MYBASE_DIR") " & " "tmp\\search.bat" (if (string-match "[A-Z]" muster-i) "" " -i") " \"" muster-i "\""))
		)
	  (setq case-fold-search case-fold-search-old)
;	  (message search-command)
	  (grep search-command)
	  (switch-to-buffer "*grep*")
	  (delete-other-windows)
	  )
      (message "! No valid pattern ...")
      )
    )
;; (pie-search "proe")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; pie journal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; pie 

(global-set-key [f5]
		(lambda ()
		  ""
		  (interactive)
		  (shell-command-on-region
		   (point-min)
		   (point-max)
		   (concat "xmllint"
			   " --format --dropdtd -")
		   nil t)
		   )
		  )

;; (global-set-key [C-f5]
;; 		(lambda ()
;; 		  ""
;; 		  (interactive)
;; 		  (if (get-buffer "cxproc.err")
;; 		      (kill-buffer "cxproc.err"))
;; 		  (shell-command
;; 		   (concat "xmllint"
;; 			   " --noout"
;; 			   " --dtdvalid file:///C:/User/develop/cxproc-build-vc/v1.0-patches/xml/pie.dtd "
;; 			   (buffer-file-name))
;; 		   "cxproc.out" "cxproc.err")
;; 		  (switch-to-buffer "cxproc.err" t)
;; 		  (grep-mode)
;; 		  )
;; 		)

(defun pie-export-file (filename &optional confirm)
  "Export current buffer into file FILENAME. derived from 'write-file'"

  (interactive
   (list (if buffer-file-name
	     (read-file-name "Write file: "
			     nil nil nil nil)
	   (read-file-name "Write file: " default-directory
			   (expand-file-name
			    (file-name-nondirectory (buffer-name))
			    default-directory)
			   nil nil))
	 (not current-prefix-arg)))
  (or (null filename) (string-equal filename "")
      (progn
	;; If arg is just a directory,
	;; use the default file name, but in that directory.
	(if (file-directory-p filename)
	    (setq filename (concat (file-name-as-directory filename)
				   (file-name-nondirectory
				    (or buffer-file-name (buffer-name))))))
	(and confirm
	     (file-exists-p filename)
	     (or (y-or-n-p (format "File `%s' exists; overwrite? " filename))
		 (error "Canceled")))))

  ;; TODO: use PieFormat.cxp 

  (cond ((string-match "\\.txt$" filename)
	 (progn
	   (shell-command (concat "cxproc.exe " (buffer-file-name) " pie2txt.xsl > " (file-truename filename)) "cxproc.log")
	   (find-file filename)
	   )
	 )
	((string-match "\\.pie$" filename)
	 (shell-command (concat "cxproc.exe " (buffer-file-name) " > " (file-truename filename)) "cxproc.log")
	 )
	((string-match "\\.html$" filename)
	 (shell-command (concat "cxproc.exe " (buffer-file-name) " pie2html.xsl > " (file-truename filename)) "cxproc.log")
	 (shell-command (concat "explorer.exe " (concat "file:///" (file-truename filename))))
	 )
	((string-match "\\.mm$" filename)
	 (shell-command (concat "cxproc.exe " (buffer-file-name) " pie2mm.xsl > " (file-truename filename)) "cxproc.log")
	 )
	((string-match "\\.xmmap$" filename)
	 (shell-command (concat "cxproc.exe " (buffer-file-name) " pie2mm.xsl mm2xmmap.xsl > " (file-truename filename)) "cxproc.log")
	 )
	)
					;  (save-buffer)
  (message filename)
  )

(define-key-after
  (lookup-key global-map [menu-bar file])
  [current-export-file] '("File export" . pie-export-file)
  t
  )

(define-key-after
  (lookup-key global-map [menu-bar tools])
  [current-insert-done] '("✔" . (lambda ()
				     ""
				     (interactive)
				     (insert " ✔"))
			  )
  t
  )

(define-key-after
  (lookup-key global-map [menu-bar tools])
  [current-insert-reject] '("✘" . (lambda ()
				     ""
				     (interactive)
				     (insert " ✘"))
			  )
  t
  )

(define-key-after
  (lookup-key global-map [menu-bar tools])
  [current-insert-marker] '("Insert Marker" . (lambda ()
				     ""
				     (interactive)
				     (insert "\n\n➽\n\n"))
			  )
  t
  )

(define-key-after
  (lookup-key global-map [menu-bar tools])
  [current-insert-effort] '("Effort" . (lambda ()
				     ""
				     (interactive)
				     (insert " \u258A\u258A\u258A"))
			  )
  t
  )

(provide 'pie)
