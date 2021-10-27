
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq inhibit-startup-message t)
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq org-todo-keyword-faces '(("TODO" . "green")
							   ("DOING" . (:background "yellow" :foreground "black" :weight bold))
							   ("PENDING" . "red")
							   ("DONE" . "grey")
							   ("CANCEL" . "grey")))
(setq org-enforce-todo-dependencies t)
(setq org-plantuml-jar-path
 (expand-file-name "~/.emacs.d/scripts/plantuml.jar"))
(setq org-ditaa-jar-path (expand-file-name "~/.emacs.d/scripts/ditaa0_9.jar"))
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
	 (plantuml . t)
	 (ditaa . t)
	 (python . t)))

;; trust all code as being safe
(setq org-confirm-babel-evaluate nil)
;; automatically show the resulting image
(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)
; make babel results blocks lowercase
(defun bh/display-inline-images ()
 (condition-case nil
  (org-display-inline-images)
  (error nil)))
;; diary for chinese birthday
(require 'cal-china)
(defun my-diary-chinese-anniversary (lunar-month lunar-day &optional year mark)
	(if year
		(let* ((calendar-date-style 'american)
			   (d-date (diary-make-date lunar-month lunar-day year))
			   (a-date (calendar-absolute-from-gregorian d-date))
			   (c-date (calendar-chinese-from-absolute a-date))
			   (cycle (car c-date))
			   (yy (cadr c-date))
			   (y (+ (* 100 cycle) yy)))
		  (diary-chinese-anniversary lunar-month lunar-day y mark))
	  (diary-chinese-anniversary lunar-month lunar-day year mark)))
(setq package-archives '(("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; org-capture setting
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-home-dir (or (getenv "ORG_HOME") "~/.org"))
(setq org-default-notes-file (concat (file-name-as-directory org-home-dir) "plan/after-hours/after-hours-2021.org"))
(setq org-capture-templates
      `(("t" "Work Todo" entry (file ,(concat (file-name-as-directory org-home-dir) "plan/work/work-2021.org")) "* TODO %?\n Create at %U\n %a")
	("h" "After hours Todo" entry (file ,(concat (file-name-as-directory org-home-dir) "plan/after-hours/after-hours-2021.org")) "* TODO %?\n Create at %U\n %a")))
