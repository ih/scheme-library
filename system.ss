(library (system)
         (export system)
         (import (except (rnrs) string-hash string-ci-hash)
                 (church external py-pickle))

         (define system
           (py-pickle-script "~/Code/scheme/lib/system.py")))

         )
                 