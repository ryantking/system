;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! string-inflection :pin "50ad54970b3cc79b6b83979bde9889ad9a9e1a9c")
(package! info-colors :pin "2e237c301ba62f0e0286a27c1abe48c4c8441143")
(package! org-appear :recipe (:host github :repo "awth13/org-appear")
  :pin "81eba5d7a5b74cdb1bad091d85667e836f16b997")
(package! ob-http :pin "b1428ea2a63bcb510e7382a1bf5fe82b19c104a7")
(package! denote :pin "eec60330fb0971db7693ee21d4c8324f4c467656")
(package! consult-denote :pin "decdaa3935aa79b23f8ceab5768b248ee15e65fd")
;; (package! claude-shell
;;   :recipe (:host github :repo "arminfriedl/claude-shell"
;;            :files ("claude-shell.el" "claude-shell-fontifier.el")))

;;; $DOOMDIR/packages.el ends here
