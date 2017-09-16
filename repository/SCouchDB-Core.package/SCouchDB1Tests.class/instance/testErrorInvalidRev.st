tests
testErrorInvalidRev

	| db re revList|
	
	db := self createFreshDB.

	db documentAt: '1' put: ( { 'name'->'Test'  } asDictionary   ).
	re:=db documentCurrentRevAt: '1'.
	self should: [ db documentAt: '1' rev: '99-97db6034a0321a88c96c592d870d01bc' ] raise: SCError.
	self assert:  ((db documentAt: '1' rev:re) at: 'name') = 'Test' .
	revList:=db documentRevisionsAt:'1'.
	revList:=db documentRevsInfoAt:'1'.
	
	
	db adaptor deleteDatabase: db name

