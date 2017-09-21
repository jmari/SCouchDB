tests
testAdding2000DocumentWithoutID
	
	| db doc time |

	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0 . 'user'->'popo' } asDictionary.
	time:=[1 to:20 do:[:i|
				db documentPut: ( doc at:'val' put:i;yourself )]] timeToRun .
	
	self assert:  (db documents size) equals: 1 .
	self assert:  time < (Time seconds:130).

	db adaptor deleteDatabase: db name.
	
