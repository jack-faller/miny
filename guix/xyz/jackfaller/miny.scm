(define-module (xyz jackfaller miny)
  #:export (miny)

  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages gl)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 popen))


(define (git-tree-file? file stat)
  (define root
    (let* ((pipe (open-pipe* OPEN_READ "git" "rev-parse" "--show-toplevel"))
           (root (read-line pipe)))
      (close-pipe pipe)
      root))
  (define old-cwd (getcwd))
  (chdir root)
  (define keep?
    (or (not (string=? file (string-append root "/.git")))
        (= 1 (status:exit-val (system* "git" "check-ignore" file)))))
  (chdir old-cwd)
  keep?)

(define miny
  (package
    (name "miny")
    (version "0.6.0")
    (source (local-file "." name #:recursive? #t #:select? git-tree-file?))
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
    (description "Minesweeper")
    (license license:expat)))
miny
