(defun print-elements-of-list (list)
  (while list
    (print (car list))
    (setq list (cdr list))))

(let* ((root default-directory)
       (posts-dir (expand-file-name "posts" root))
       (posts (directory-files posts-dir nil "\\.org$"))
       (index-file (expand-file-name "index.html" root))
       (post-info nil))
  (when (file-exists-p index-file)
    (delete-file index-file))
  (make-empty-file index-file)
  (dolist (post posts)
    (message "%s" post)
    (with-temp-buffer
      (insert-file-contents (expand-file-name post posts-dir))
      (let* ((title-regex "\\(^#\\+TITLE: \\)\\(.*$\\)")
	     (title (if (string-match-p title-regex (buffer-string))
			(progn
			  (string-match title-regex (buffer-string))
			  (match-string 2 (buffer-string)))
		      nil))
	     (date-regex "\\(^#\\+DATE: \\)\\(.*$\\)")
	     (date (if (string-match-p date-regex (buffer-string))
		       (progn
			 (string-match date-regex (buffer-string))
			 (match-string 2 (buffer-string)))
		     nil)))
	(when (and title date)
	  (push (cons post (list title date)) post-info)))))
  (sort post-info (lambda (a b)
		    (let ((a-date (car (date-to-time (nth 2 a))))
			  (b-date (car (date-to-time (nth 2 b)))))
		      (if (= a-date b-date)
			  t
			(> a-date b-date))))))
		    
			  
