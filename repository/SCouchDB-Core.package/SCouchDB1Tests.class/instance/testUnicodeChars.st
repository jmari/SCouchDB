tests
testUnicodeChars
	| db string |
	
	db := self createDB.
	string := {'unicode'->'♥'} asDictionary.
	db documentAt:'17' put: string.
	self assert:  ((db documentAt: '17') at:'unicode') equals: (string at:'unicode').
	db adaptor deleteDatabase: db name.
