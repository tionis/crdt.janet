#!/bin/env janet
(import big)
(print "\n\n\n\n\n\n")
# (defn normal/gcd [x y]
#   (var [a b] [x y])
#   (var r (% a b))
#   (while (not (nan? r))
#     (set a b)
#     (set b r)
#     (pp [a b r])
#     (if (= b big/zero)
#       (set r nil)
#       (set r (% a b))))
#   a)
# (pp [:gcd3 (normal/gcd 24 40)])
(def big/zero (big/int 0))
(def big/one (big/int 1))
(def num1 [(big/int "1")
           (big/int "2")])
(def num2 [(big/int "7")
           (big/int "10")])

(defn big/% [x y]
  (cond
    (= x big/zero) 0
    (= y big/zero) nil
    ((big/divrem x y) 1)))

(defn gcd [x y]
  (var [a b] [x y])
  (var r ((big/divrem a b) 1))
  (while r
    (set a b)
    (set b r)
    (if (= b big/zero)
      (set r nil)
      (set r ((big/divrem a b) 1))))
  a)

(defn simplify [n]
  (def out @[(n 0) (n 1)])
  (var d (gcd (out 0) (out 1)))
  (while (not= d big/one)
    (put out 0 (/ (out 0) d))
    (put out 1 (/ (out 1) d))
    (set d (gcd (out 0) (out 1))))
  out)

(defn mid [x y]
  (simplify [(+ (* (x 0) (y 1))
                (* (y 0) (x 1)))
             (* 2 (x 1) (y 1))]))

(pp (mid num1 num2)) # -> [3 5]
