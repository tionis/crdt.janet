(use ./utils)

(def List
  @{:insert (fn [x index element]
              (def item @{:id [(x :node-id) (x :counter)] :value element})
              (+= (x :counter) 1)
              (def [item-ind parent-ind side] (tree/index-emplace (x :data) index item))
              (:push-event x :insert [(item :value)
                                      (item :id)
                                      (get-in x [:data parent-ind :id])
                                      side])
              item)
    :push-event (fn [x command args] (array/push (x :log) [command args]))
    :log @[]
    :view (fn [x] (freeze (map |(get-in (x :data) [$0 :value]) (slice (tree/to-arr (x :data)) 0 -2))))
    :delete (fn [x index] (tree/index-delete (x :data) index))
    :get (fn [x index] (tree/index-get-value (x :data) index))})

(defn new []
  (table/setproto
    @{:data (tree/new @{:id (gen-rand-id)})
      :counter 0
      :node-id (gen-rand-id)}
    List))
