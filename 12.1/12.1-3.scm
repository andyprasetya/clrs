(require-extension syntax-case check)
(require '../12.1/section)
(import section-12.1)
(check (bt-inorder-tree-map/iterative bt-node-datum exercise-12.1)
       => '(21 17 16 10 5 4 1))
