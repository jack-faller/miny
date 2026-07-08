(define-module (xyz jackfaller miny)
  #:export (miny)

  #:use-module (gnu packages gl)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix channels utils))

(define miny
  (package
    (name "miny")
    (version "0.6.0")
    (source (relative-file "../../.." name #:recursive? #t #:select? git-source-file?))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases #~(modify-phases %standard-phases
                   (delete 'configure)
		   (replace 'install
		     (lambda* (#:key outputs #:allow-other-keys)
		       (let* ((out (assoc-ref outputs "out"))
			      (bin (string-append out "/bin")))
			 (install-file "miny" bin)))))
      #:tests? #f))
    (inputs (list freeglut))
    (home-page "https://github.com/spacecamper/miny")
    (synopsis "Minesweeper")
    (description "A simple Minesweeper clone that supports scoreboards, arbitrary board sizes, various game statistics, and saves replays of completed games.")
    (license license:expat)))
