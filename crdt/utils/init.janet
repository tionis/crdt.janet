(import spork/randgen)
(import ./tree :export true)

(defn log [& xs] (eprintf "%M" xs))

(def chars (array ;(range 48 58) ;(range 65 90) ;(range 97 122))) # Only ascii nums and letters
(defn gen-rand-id [] (string/from-bytes ;(seq [i :range [0 10]] (chars (randgen/rand-index chars)))))
