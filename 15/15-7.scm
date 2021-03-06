(require-extension syntax-case array-lib srfi-11 check)
(require '../15/chapter)
(import chapter-15)
(let ((j0 (make-job 0 4 3 1))
      (j1 (make-job 1 7 2 3))
      (j2 (make-job 2 13 7 15))
      (j3 (make-job 3 15 4 12)))
  (let ((jobs (sort-by-deadline (list j0 j1 j2 j3))))
    (let-values (((p r) (schedule-max jobs)))
      (let* ((n (length jobs))
             (job-specs (make-schedule jobs p r (- n 1) (- (* n n) 1))))
        ;; Job spec consists of number, start, end, profit
        (check (map job-spec->list job-specs) =>
               '((3 12 15 30)
                 (2 5 11 18)
                 (1 3 4 3)
                 (0 0 2 0)))))))
