tests
testFindingDocuments4
	
	| db doc result |
	
	db := self createDB.
	doc := { 'name'->'Test'. 
				'val'->0. 
				'foo'->#('bar')  } asDictionary.
	1 to:20 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;copy )].
	
	result := db mangoQuery 
						selector: [:a| a foo includesAll: #('bar') ];
						limit:5;
						fields: #(#_id #val);
						sort: #(#_id );
						skip:4;
						execute.
	
	self assert:  result size equals: 5.

	db adaptor deleteDatabase: db name.
	

