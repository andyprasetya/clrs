(define (memoized-activity-selector activities)
  (let* ((n (length activities))
         (dim `(0 ,n)))
    (let ((compatibles (make-array '#(#f) dim dim))
          (choices (make-array '#(#f) dim dim)))
      (let* ((compatible-activities
              (rec (compatible-activities i j)
                   (let ((fi (cdr (list-ref activities i)))
                         (sj (car (list-ref activities j))))
                     (filter (lambda (activity)
                               (let ((sk (car activity))
                                     (fk (cdr activity)))
                                 (and (<= fi sk)
                                      (< sk fk)
                                      (<= fk sj))))
                             activities))))
             (lookup-compatible
              (rec (lookup-compatible i j)
                   (let ((compatible (array-ref compatibles i j)))
                     (if compatible
                         compatible
                         (let ((compatible-activities
                                (compatible-activities i j)))
                           (array-set! compatibles 0 i j)
                           (if (not (null? compatible-activities))
                               (loop ((for k (up-from i (to j))))
                                     (if (member (list-ref activities k) compatible-activities)
                                         (let ((q (+ (lookup-compatible i k)
                                                     (lookup-compatible k j)
                                                     1)))
                                           (if (> q (array-ref compatibles i j))
                                               (begin (array-set! compatibles q i j)
                                                      (array-set! choices k i j)))))))
                           (array-ref compatibles i j)))))))
        (lookup-compatible 0 (- n 1))
        (values compatibles choices)))))

(define (sort-by-finishing-time activities)
  (sort activities < cdr))

(define (choices->activities choices)
  (delete-duplicates
   (array-fold
    (lambda (activities k)
      (if k (cons k activities) activities))
    '()
    choices)))
