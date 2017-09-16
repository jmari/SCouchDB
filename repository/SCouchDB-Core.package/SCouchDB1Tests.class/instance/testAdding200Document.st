tests
testAdding200Document
	
	| db doc time|
	
	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0  } asDictionary.
	time:=[1 to:20 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;copy )]] timeToRun .
	
	self assert:  (db documents size) equals: 20 .

	db adaptor deleteDatabase: db name.
	
