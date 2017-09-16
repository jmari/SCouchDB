tests
testSessionInfo
	
	| db si |
	
	db := self createDB.
	si:=db adaptor sessionInfo.
	self assert:  (si at: 'ok') = true .
		
	db adaptor deleteDatabase: db name.
	db adaptor logout