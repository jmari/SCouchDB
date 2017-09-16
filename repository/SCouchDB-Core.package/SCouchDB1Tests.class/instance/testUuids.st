tests
testUuids
	
	| db i|
	
	db := self createDB.
	i:=db adaptor uuids.
	db adaptor deleteDatabase: db name.
	self assert:  (i includesKey: 'uuids').
	db adaptor logout.
