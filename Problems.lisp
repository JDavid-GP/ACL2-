
Please, notice the use of equal and lexorder instead of = and <=. 
The former, though less efficient, are more general and enjoy nicer properties.

Boolean constants:
	nil  t
Boolean operations:
	not  and  or  implies  equal
Predicates:
	equal  lexorder  atom
Arithmetic:
	+  min(minimum)
Pair and list primitives:
	cons  list  first  second  rest  append(concatenation)  len(length)
Control:
	if  let


;Searching

1. Define the function in. 
(in x y) returns t when x is an element of list y, otherwise, nil.
Buscar en una lista y un elemento x
 (defun in (x y)
  		(if (atom y) 
  			nil      
  			(or (equal x (first y))
  			(in x (rest y)))))  

Some tests:

(assert-event (not (in 0 nil)))
(assert-event (not (in 0 0)))
(assert-event (in 0 '(0)))
(assert-event (in 0 '(0 1)))
(assert-event (in 0 '(1 2 3 0)))

2. Prove that x is in the concatenation of y and z iff x is in y or x is in z.
   Hint: You may use equal for iff (if, and only if).
    (defthm concatenation-in
   	(iff (in x (append y z))
   		(or (in x y) (in x z))))


;Counting

1. Define the function how-many.
(how-many x y) returns how many times x appears in list y.

(defun how-many (x y)
	(if (atom y)
		0
		(if (equal x (first y))
			(+ 1 (how-many x (rest y)))
			(how-many x (rest y)))))

Some tests:

(assert-event (equal (how-many 1 nil) 0))
(assert-event (equal (how-many 1 1) 0))
(assert-event (equal (how-many 1 '(1)) 1))
(assert-event (equal (how-many 1 '(1 2 1)) 2))
(assert-event (equal (how-many 4 '(1 2 3)) 0))


2. Prove that the number of occurrences of x in the concatenation of y and z
 is just the sum of the number of occurrences in y and z.
(defthm concatenation-how-many
	(equal (how-many x (append y z))
		(+ (how-many x y)(how-many x z))))


;Order and transitivity

1. Define the function none-less-than.
(none-less-than x y) returns t when no element of x is less than y, otherwise, nil. Y>X

(defun none-less-than (x y)
	if (atom x)
	t
	(and (lexorder y (first x))
		(none-less-than (rest x) y)))

Some tests:

(assert-event (none-less-than nil 0))
(assert-event (none-less-than '(0 1 2) 0))
(assert-event (not (none-less-than '(0 1 2) 1)))

2. Prove that if no element of x is less than y and y is not less than z,
   then no element of x is less than z.

(defthm order-and-transitivity
	(implies (and (none-less-than x y) (lexorder z y))
		(none-less-than x z)))


;Zipping

1. Define the function zipper.
(zipper x y) returns the association list with keys from x and values from y, i.e., 
a list of dotted pairs formed by the successive elements of x and y whenever both such 
elements exist.

(defun zipper (x y)
	(if (or (atom x) (atom y))
		nil
		(cons (cons (first x)(first y)); el cons interior pone puntitos en medio, el primer cons lo mete en una lista
			(zipper (rest x) (rest y)))))

Some tests:

(assert-event (equal (zipper nil nil) nil))
(assert-event (equal (zipper '(a b c) '(1 2 3)) '((a . 1) (b . 2) (c . 3))))
(assert-event (equal (zipper '(a b) '(1 2 3)) '((a . 1) (b . 2))))
(assert-event (equal (zipper '(a b c) '(1 2)) '((a . 1) (b . 2))))

2. Prove that the length of the zipped list is the minimum of the lengths of the input lists.

(defthm min-size-zipper
	(equal (len (zipper x y)) (min (len x) (len y))))

;Unzipping

1. Define the function unzipper.
(unzipper x) returns two lists with the keys and values, respectively, 
of the elements in x, which is an a-list, i.e., an association list.
(defun unzipper (x)
	(if (atom x)
		(list nil nil)
	(let ((y (first x)) 
		(z (unzipper (rest x))))
	(list (cons (first y) (first z))
		(cons (rest y) (second z))))))


Some tests:

(assert-event (equal (unzipper nil) '(nil nil)))
(assert-event (equal (unzipper 0) '(nil nil)))
(assert-event (equal (unzipper '((a . 1) (b . 2) (c . 3))) '((a b c) (1 2 3))))
2. Prove that the lengths of the unzipped lists are the same.
(defthm same-size-unzipper
	(equal (len (first (unzipper x))) (len (second (unzipper x)))))


;Duplicates off

1. Define the function unique.
(unique x) returns the list of elements of x without duplications.
(defun unique (x)
	(if (atom x)
		nil
	(if (in (first x) (rest x))
		(unique (rest x))
		(cons (first x) (unique (rest x))))))



Some tests:

(assert-event (equal (unique nil) nil))
(assert-event (equal (unique '(0)) '(0)))
(assert-event (equal (unique '(0 0 0)) '(0)))
(assert-event (equal (unique '(0 0 1)) '(0 1)))
(assert-event (equal (unique '(0 1 2 0 1 2 0 0 1)) '(2 0 1)))

2. Prove that unique is idempotent.
(defthm idemp-unique
	(equal (unique (unique x)) (unique x)))

;Getting common elements

1. Define function common.
(common x y) returns the list of elements common to x and y.
(defun common (x y)
	(if (or (atom x) (atom y))
		nil
	(if (in (first x) y)
		(cons (first x) (common (rest x) y))
		(common (rest x) (rest y)))))
Some tests:

(assert-event (equal (common nil '(1 2 3)) nil))
(assert-event (equal (common '(0 2 4) '(1 3 5)) nil))
(assert-event (equal (common '(0 2 4) '(1 2 3)) '(2)))
(assert-event (equal (common '(0 0) '(0 1 0 2)) '(0 0)))
