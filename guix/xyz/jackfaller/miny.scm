(define-module (xyz jackfaller miny)
  #:export (miny)

  #:use-module (gnu packages gl)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim))

(define (git-source-file? file stat)
  (or
   (not (= 0 (system* "git" "rev-parse" "--is-inside-work-tree" file)))
   (begin
     (define root
       (let* ((pipe (open-pipe* OPEN_READ "git" "rev-parse" "--show-toplevel"))
              (root (read-line pipe)))
         (unless (= 0 (close-pipe pipe))
           (error "Git failed."))
         root))
     (define old-cwd (getcwd))
     (chdir root)
     (define keep?
       (and (not (string=? (string-append root "/.git") file))
            (= 1 (status:exit-val (system* "git" "check-ignore" file)))))
     (chdir old-cwd)
     keep?)))

(define-syntax relative-file
  (syntax-rules ()
    ((_ path rest ...)
     (local-file
      (string-append
       (if (current-filename)
           (dirname (current-filename))
           (current-source-directory))
       "/" path)
      rest ...))))

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
    (description "Minesweeper")
    (license license:expat)))
