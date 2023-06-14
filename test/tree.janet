(import ../crdt/utils/tree)

(def t (tree/new))

(tree/index-insert t 0 "1")
(tree/index-insert t 0 "0")
(tree/index-insert t 2 "3")
(tree/index-insert t 2 "2")

(assert (deep= (map |(get-in t [$0 :value]) (tree/to-arr t))
               @["0" "1" "2" "3" nil]))
(tree/index-delete t 1)
(assert (deep= (map |(get-in t [$0 :value]) (tree/to-arr t))
               @["0" "2" "3" nil]))
