;; disable splash screen and startup message
(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)

;; Initialize which-key
(which-key-mode)

;; org mode config
;; Export headlines as links to self (useful for sharing anchor URLs) 
;; (setq org-html-self-link-headlines t)
(require 'org-id)
(setq org-id-link-to-org-use-id t)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Use a builtin theme
(load-theme 'adwaita)

;; Set up evil for VIM-in-Emacs
;; (evil-mode 1)
;;;; Setup evil-org to have vim keybindings in Org mode
;; (require 'evil-org)
;; (add-hook 'org-mode-hook 'evil-org-mode)
;; (evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading))


;;;; Auto-export org files to html when saved 
;;(defun org-mode-export-hook()
;;  "Auto export html"
;;  (when (eq major-mode 'org-mode)
;;    (org-html-export-to-html)))

;; (add-hook 'after-save-hook 'org-mode-export-hook)

;; active Babel languages
(org-babel-do-load-languages
  'org-babel-load-languages
  '((dot . t)
    (plantuml . t)
    (ditaa . t)))

;; Do not ask before evaluating a code block
(setq org-confirm-babel-evaluate nil)
;; (add-to-list org-babel-after-execute org-redisplay-inline-images)

;; Fix for including SVGs
;; (org-latex-pdf-process
;;   '("%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
;;     "bibtex %b"
;;     "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
;;     "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"))




