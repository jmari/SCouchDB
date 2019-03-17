tests
testUsersDatabase
	
	| db i|
	
	db := self createDB.
	i:=db adaptor users.
	db adaptor deleteDatabase: db name.
	self assert:  (i at: 'db_name') = '_users' .
	db adaptor logout.
