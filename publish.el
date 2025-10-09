(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-refresh-contents)

(unless (package-installed-p 'htmlize)
  (package-install 'htmlize))

(unless (package-installed-p 'plantuml-mode)
  (package-install 'plantuml-mode))

(require 'ox-publish)

(setq org-html-metadata-timestamp-format "%d %B %Y")
(setq org-html-validation-link nil)
(setq org-export-default-language "ru")
(setq org-export-time-stamp-file nil)

(setq org-html-preamble (with-temp-buffer
			  (insert-file-contents "templates/preamble.html")
			  (buffer-string)))

(setq org-html-head (with-temp-buffer
			  (insert-file-contents "templates/head.html")
			  (buffer-string)))

(defun blog/org-publish-org-sitemap-format-entry (entry style project)
  (format "%s - [[file:%s][%s]]"
	  (format-time-string "%F" (org-publish-find-date entry project))
	  entry
	  (org-publish-find-title entry project)))

(setq org-publish-project-alist
      '(("posts"
         :base-directory "pages/"
	 :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "public/"
         :section-numbers nil
	 :recursive t
	 :auto-sitemap t
	 :sitemap-sort-files anti-chronologically
	 :sitemap-format-entry blog/org-publish-org-sitemap-format-entry
	 :sitemap-title "Содержание"
	 :sitemap-filename "index.org"
	 :sitemap-style list
	 :author "Никита Рукин"
	 :email "nikita-rukin@yandex.ru"
	 :with-toc nil
	 :with-author nil
	 :with-date t)
	("css"
	 :base-directory "css/"
	 :base-extension "css"
	 :publishing-directory "public/css"
	 :publishing-function org-publish-attachment
	 :recursive t)
	("about"
         :base-directory "about/"
         :base-extension "org"
         :recursive nil
         :publishing-function org-html-publish-to-html
         :publishing-directory "public/"
	 :with-toc nil
	 :with-author nil
	 :section-numbers nil)
	("static"
         :base-directory "static/"
	 :base-extension any
         :publishing-directory "public/static"
         :publishing-function org-publish-attachment
         :recursive t)
	("all" :components ("posts" "css" "about" "static"))))

