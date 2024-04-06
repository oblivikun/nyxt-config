
(define-configuration (input-buffer) ((default-modes (remove-if (lambda (nyxt::m) (find (symbol-name nyxt::m) '("EMACS-MODE" "VI-NORMAL-MODE" "VI-INSERT-MODE") :test #'string=)) %slot-value%)))) 
(defvar gruv-theme
 (make-instance 'theme:theme
 :dark-p nil
 :background-color "#fbf1c7"
 :background-color+ "#f2e5bc"
 :on-background-color "#3c3836"

 :primary-color "#cc241d"
 :primary-color+ "#9d0006"
 :on-primary-color "#fdf4c1"

 :secondary-color "#98971a"
 :secondary-color+ "#79740e"
 :on-secondary-color "#fdf4c1"

 :action-color "#d79921"
 :action-color+ "#b57614"
 :on-action-color "#fdf4c1"

 :success-color "#b8bb26"
 :success-color+ "#83a598"
 :on-success-color "#fdf4c1"

 :highlight-color "#b16286"
 :highlight-color+ "#d3869b"
 :on-highlight-color "#fdf4c1"

 :warning-color "#fabd2f"
 :warning-color+ "#fabd2f"
 :on-warning-color "#fdf4c1"

 :codeblock-color "#689d6a"
 :codeblock-color+ "#8ec07c"
 :on-codeblock-color "#fdf4c1"))


(define-configuration browser
    ((theme gruv-theme)))

(define-configuration status-buffer
    ((style (str:concat %slot-value%
                        (theme:themed-css (theme *browser*))))))

(defvar *my-search-engines*
 (list
   '("google" "https://google.com/search?q=~a" "https://google.com")
   '("doi" "https://dx.doi.org/~a" "https://dx.doi.org/")
   '("duckduckgo" "https://duckduckgo.com/?q=~a" "https://duckduckgo.com/"))
 "List of search engines.")






(define-configuration context-buffer
  "Go through the search engines above and make-search-engine out of them."
  ((search-engines
    (append %slot-default%
            (mapcar
             (lambda (engine) (apply 'make-search-engine engine))
             *my-search-engines*)))))
(defmacro alter-keyscheme (keyscheme scheme-name &body bindings)
  #+nyxt-2
  `(let ((scheme ,keyscheme))
     (keymap:define-key (gethash ,scheme-name scheme)
       ,@bindings)
     scheme)
  #+nyxt-3
  `(keymaps:define-keyscheme-map "custom" (list :import ,keyscheme)
     ,scheme-name
     (list ,@bindings)))

(define-mode cruise-control-mode-emacs-map
  nil
  "Custom mode for cruise control bindings."
  ((keyscheme-map
    (alter-keyscheme %slot-value%
                     nyxt/keyscheme:emacs
                     "C-c v" 'velocity-zero
                     "C-c +" 'velocity-incf
                     "C-c =" 'velocity-decf
                     "M-c" 'cruise-control-mode))))





(define-configuration base-mode
    ((keyscheme-map
      (alter-keyscheme %slot-value%
		       nyxt/keyscheme:emacs
		       "M-s s" 'search-buffers
		       "M-h h" 'history-tree
		       "M-h l b"  'list-bookmarks 
		       "M-h b" 'buffer-history-tree

		       ))))
(define-configuration :status-buffer
  "Display modes as short glyphs."
  ((glyph-mode-presentation-p t)))

(define-configuration status-buffer
    ((style (str:concat
             %slot-value%
             (theme:themed-css (theme *browser*)
			       `("#controls,#actions"
				 :display none !important))))))

(defmethod format-status-load-status ((status status-buffer))
  "A fancier load status."
  (spinneret:with-html-string
      (:span (if (and (current-buffer)
                      (web-buffer-p (current-buffer)))
		 (case (slot-value (current-buffer) 'nyxt::status)
                   (:unloaded "∅")
                   (:loading "∞")
                   (:finished ""))
		 ))))
(define-configuration input-buffer
 ((default-modes
    (append
      (remove-if (lambda (nyxt::m) (find (symbol-name nyxt::m) '("EMACS-MODE" "VI-NORMAL-MODE" "VI-INSERT-MODE") :test #'string=)) %slot-value%)
      (list 'nyxt/mode/emacs:emacs-mode 'cruise-control-mode-emacs-map)))))
