tests
testAddingDocumentWithUUID	
	| db docID |
	
	db := self createDB.
	docID := db adaptor nextUUID.
	
	db documentAt: docID put: ( { 'name'->'Test'  }  asDictionary ).	
	self assert:  ((db documentAt: docID) at: 'name') = 'Test' .
	db adaptor deleteDatabase: db name.