(library (pi concepts)
         (export node prototype parameterized-parts single-recursion multiple-recursion gen-data)
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

         (define growth-noise .05)
         (define label-noise .05)
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
