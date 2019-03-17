tests
testChanges
	
	|r db doc |
	
	db := self createDB.
	doc := { 'name'->'Test'  } asDictionary.
	db documentAt: '1' put: ( doc  ).

	r := db changes.
	r inspect.
	self assert: r size > 0.

	
