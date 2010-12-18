;;TO DO
;;-stall animate until treedraw is finished
(library (pi trees drawing)
         (export draw-trees animate-tree)
         (import (except (rnrs) string-hash string-ci-hash)
                 (church external py-pickle)
                 (util)
                 (only (ikarus) set-car! set-cdr!)
                 (church readable-scheme)
                 (_srfi :1))


         (define draw-trees
           (py-pickle-script "~/Code/scheme/lib/pi/trees/treedraw.py"))

         (define animate
           (py-pickle-script "~/Code/scheme/lib/pi/trees/animate.py"))

         (define (animate-tree tree fname)
           (let* ([growth-sequence (tree-growth tree)]
                  [num-of-images (length growth-sequence)])
             (draw-sequence fname growth-sequence)
             ;;a bad hack to pause computation until draw-sequence completes
             (repeat 100000 (lambda () (+ 2 2))) 
             (animate (list fname num-of-images))))

         (define (draw-sequence fname tree-lst)
           (map (lambda (x y) (draw-trees (pair (string-append fname (number->string y) ".png") (list x)))) tree-lst (range 1 (length tree-lst))))


         (define (tree-growth tree)
           (let* ([max-depth (depth tree)]
                  [all-depths (range 0 max-depth)])
             (rest (map (lambda (x) (take-tree x tree)) all-depths)))) 

         (define (take-tree depth tree)
           (if (null? tree)
               '()
               (if (= depth 0)
                   '()
                   (append (list (first tree)) (delete '() (map (curry take-tree (- depth 1)) (rest tree)))))))
         )
         
;;(animate-tree '(a (b (q) (r (s (t (c (d)))))) (c (d (f))) (b (d))) "images/trees")

;;(animate (list "images/tree" 5))