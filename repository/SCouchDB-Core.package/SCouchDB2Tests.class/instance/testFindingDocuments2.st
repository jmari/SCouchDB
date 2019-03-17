tests
testFindingDocuments2
	
	| db doc result |
	
	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0  } asDictionary.
	1 to:20 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;deepCopy )].
	
	result := db mangoQuery selector: [:a| a val < 11 ];execute.


	self assert:  result size equals: 10 .

	db adaptor deleteDatabase: db name.
