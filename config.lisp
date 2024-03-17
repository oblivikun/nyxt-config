(define-configuration (input-buffer) ((default-modes (remove-if (lambda (nyxt::m) (find (symbol-name nyxt::m) '("EMACS-MODE" "VI-NORMAL-MODE" "VI-INSERT-MODE") :test #'string=)) %slot-value%)))) (define-configuration (input-buffer) ((default-modes (pushnew 'nyxt/mode/emacs:emacs-mode %slot-value%))))
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

