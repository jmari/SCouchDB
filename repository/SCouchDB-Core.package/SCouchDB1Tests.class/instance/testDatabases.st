tests
testDatabases
	
	| db r |
	
	db := self createDB.
	r := db adaptor databases.
	self assert: r size > 0.
	db adaptor deleteDatabase: db name.
	
