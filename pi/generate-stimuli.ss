;;TO DO
(library (pi generate-stimuli)
         (export generate-static-stimulus gen-data)
         (import (except (rnrs) string-hash string-ci-hash)
                 (only (ikarus) set-car! set-cdr!)
                 (_srfi :1)
                 (church readable-scheme)
                 (church external py-pickle)
                 (only (srfi :13) string-join)
                 (util)
                 (system)
                 (pi abstract)
                 (pi trees drawing))

         (define training-size 10)
         (define test-size 1)
         (define stimuli-size 5)

         ;;this version ensures no null trees
         (define (gen-data concept amount)
           (sexp-replace '() '(a) (repeat amount concept)))

         
         ;; (define models (list prototype multiple-recursion))

         ;; (define (generate-animated-stimulus concept directory)
         ;;   (let* ([training-data (gen-data concept training-size)]
         ;;          [test-data ((uniform-draw models))])
         ;;     (map animate-tree training-data (training-filenames directory))
         ;;     (animate-tree test-data (testing-filename directory))))

         (define (generate-static-stimulus concept amount fname)
           (let* ([data (gen-data concept amount)])
             (draw-trees (pair fname data))))
         

         (define (testing-filename directory)
           (string-join (list directory "testing") ""))
         
         (define (training-filenames directory)
           (map (lambda (x) (string-join (list directory "training" (number->string x)) "")) (range 0 (- training-size 1))))

         ;; (define (generate-stimuli concept)
         ;;   (map (curry generate-stimulus concept) (directory-names))
         ;;   (map remove-pngs (directory-names)))

         (define (directory-names)
           (let* ([names (map (lambda (x) (string-join (list "stimuli" "/" (number->string x) "/") "")) (range 0 (- stimuli-size 1)))])
             (map (lambda (x) (system (string-join (list "mkdir" x)))) names)
             names))

         ;;pngs created during animation
         (define (remove-pngs directory)
           (system (string-join (list "rm " directory "*.png") "")))

         ;;(generate-stimuli prototype)
         ;;(generate-static-stimulus trunk-two-branches 2 "stimuli/trunk-two-branches/set1.png")

         ;;(generate-static-stimulus line-recursion 3 "stimuli/line-recursion/testing.png")
         ;;-generate test example (randomly from either from true model or different
         ;;-change concepts so that the first node is always generated
         ;;-store training and test examples in unique folder for stimuli, name should reflect whether the test example is true or not?
         ;;-make prototype stimuli
         )