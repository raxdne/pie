;;
;; update legacy markup of PIE text (p) 2022 by Alexander Tenbusch
;;

; (query-replace-regexp "\\(0000[0-9]+\\) \\([^ ]+\\) \\. " "\nR/\\2\\1/P1Y ")

(defun pie-markup-update ()
  ""
  (interactive)
			  
  (setq
   case-fold-search nil
   tag-list '(
	      ("#begin_of_script" . "<script>") ("#end_of_script" . "</script>")
	      ("#begin_of_csv" . "<csv>")       ("#end_of_csv" . "</csv>")
	      ("#begin_of_cxp" . "<make>")      ("#end_of_cxp" . "</make>")
	      ;; ("#begin_of_pre" . "<pre>")       ("#end_of_pre" . "</pre>")
	      )
   tag-list-i tag-list
   )
  
  (while tag-list-i
    (beginning-of-buffer)
    (query-replace (car (car tag-list-i)) (cdr (car tag-list-i)))
    (setq tag-list-i (cdr tag-list-i))
    )

					;(save-buffer)
					;(kill-buffer nil)
  )

(global-set-key [S-f5] 'pie-markup-update)

