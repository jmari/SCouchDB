tests
testLogout
	
	| db si i|
	
	db := self createDB.
	i:=db adaptor sessionInfo.
	db adaptor deleteDatabase: db name.
	si:=db adaptor logout.
		
	self assert:  (si at: 'ok') = true .
	
