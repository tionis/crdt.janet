(setdyn :doc "Simple binary tree implementation with array abstraction. Tree is specialized for CRDTs and has an ignored implicit root as well as no real deletion, flagging deleted nodes instead.")

(defn new
  "Create new tree with optionally prefilled root"
  [&opt root]
  (default root @{})
  (put root :children @[nil nil])
  @[root])

(defn to-arr [tree &named ind ret up-to]
  (default ret @[])
  (default ind 0)
  (if-let [child (get-in tree [ind :children 0])] (to-arr tree :ind child
                                                               :ret ret
                                                               :up-to up-to))
  (unless (and up-to (= up-to (length ret)))
    (unless (get-in tree [ind :deleted])
      (array/push ret ind))
    (if-let [child (get-in tree [ind :children 1])] (to-arr tree :ind child 
                                                                 :ret ret
                                                                 :up-to up-to)))
  ret)

(defn- get-in-tree-in-order [tree arr-index &opt tree-ind cur-arr-index]
  (default tree-ind 0)
  (default cur-arr-index @[0])
  (label found
    (if-let [child (get-in tree [tree-ind :children 0])
             result (get-in-tree-in-order tree arr-index child cur-arr-index)]
      (return found result))
    (if (= arr-index (cur-arr-index 0)) (return found tree-ind))
    (unless (get-in tree [tree-ind :deleted])
      (+= (cur-arr-index 0) 1))
    (if-let [child (get-in tree [tree-ind :children 1])
             result (get-in-tree-in-order tree arr-index child cur-arr-index)]
      (return found result))
    (return found nil)))

(defn index-emplace
  "Emplace a table at a specified index of virtual array, returns an [item-index parent-index side] tuple"
  [tree index item]
  (def right-parent (get-in-tree-in-order tree index))
  (def [parent side]
    (if (get-in tree [right-parent :children 0])
      (label found
        (var parent (get-in tree [right-parent :children 0]))
        (forever
          (if (get-in tree [parent :children 1])
            (set parent (get-in tree [parent :children 1]))
            (return found [parent :right])))
        (return found nil))
      [right-parent :left]))
  (def item-index (length tree))
  (put-in tree [parent :children (case side :left 0 :right 1)] item-index)
  (array/push tree (merge-into @{:parent-ind parent :side side :item-index item-index :children @[nil nil]} item))
  [item-index parent side])

(defn index-insert
  "Insert an element at a specified index of virtual array, returns an [item-index parent-index side] tuple"
  [tree index item]
  (index-emplace tree index @{:value item}))

(defn index-delete [tree index]
  (put-in tree [(get-in-tree-in-order tree index) :deleted] true))

(defn get-parent [tree ind])

(defn is-child [tree parent child])

(defn index-get [tree index] (get-in tree [(get-in-tree-in-order tree index)]))

(defn index-get-value [tree index] (get-in tree [(get-in-tree-in-order tree index) :value]))
