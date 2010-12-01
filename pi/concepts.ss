(library (pi concepts)
         (export node prototype parameterized-parts single-recursion multiple-recursion gen-data trunk-two-branches line-recursion)
         (import (except (rnrs) string-hash string-ci-hash)
                 (only (ikarus) set-car! set-cdr!)
                 (_srfi :1)
                 (util)
                 (church readable-scheme))

         (define a 'a)
         (define b 'b)
         (define c 'c)
         (define d 'd)
         (define e 'e)

         (define growth-noise .00)
         (define label-noise .00)
         (define labels '(a b c d e))

         (define root '(a))

         (define (node x . subtrees)
           (if (flip (- 1 growth-noise))
               (delete '() (pair (noisy-label x) subtrees))
               '()))

         (define (noisy-label x)
           (if (flip (- 1 label-noise))
               x
               (uniform-draw labels)))

         ;;concept definitions         
         (define (prototype) (node 'a (node 'b (node 'c (node 'd) (node 'd)))))
         
         (define (parameterized-parts)
           (define (part x)
             (node 'a x (node 'a x (node 'a x (node 'a x x) x) x) x))
           (part (if (flip .5)
                     (node 'b)
                     (node 'c))))

         (define (trunk-two-branches)
           (define concepts (list prototype single-recursion parameterized-parts))
           ;;(define concepts (list multiple-recursion))
           (define branch ((uniform-draw concepts)))
           (define (trunk length label-generator)
             (if (= length 0)
                 (apply node (list (label-generator) branch branch))
                 (node (label-generator) (trunk (- length 1) label-generator))))
           (define (all-a) 'a)
           (define (random-label) (uniform-draw '(a b c d e f)))
           (define label-generators (list all-a random-label))
           (define lengths (range 1 10))
           (trunk (uniform-draw lengths) (uniform-draw label-generators)))

         (define (line-recursion)
           (define (line length color)
             (if (= length 0)
                 '()
                 (node color (line (- length 1) color))))

           (define (all-x x) x)
           (define lengths (range 1 10))
           ;;training
           (define colors (range 1 10))
           ;;test
           ;;(define colors (range 10 20))
           (line (uniform-draw lengths) (uniform-draw colors)))
   

         (define (single-recursion)
           (define (part)
             (node 'a
                   (if (flip .8)
                       (node 'b (part) (node c))
                       (node 'd))))
           (node b (node b (node c) (node c)) (part)))
         
         (define (multiple-recursion)
           (define (part)
             (node 'a
                   (if (flip .5)
                       (part)
                       (node 'a))
                   (if (flip .5)
                       (part)
                       (node 'b))))
           (node 'c (node 'b (node 'd (part))) (part)))

         ;;this version ensures no null trees
         (define (gen-data concept amount)
           (sexp-replace '() '(a) (repeat amount concept)))

         )
