tests
testAddingDocument
	
	| db doc |
	
	db := self createDB.
	doc := { 'name'->'Test'  } asDictionary.
	db documentAt: '1' put: ( doc  ).

	self assert:  ((db documentAt: '1') at: 'name') equals: 'Test' .
	db adaptor deleteDatabase: db name.
	
