tests
testFindingDocuments5
	
	| db doc result |
	
	db := self createDB.
	doc := { 'name'->'Test'. 
				'val'->0. 
				'foo'->#('bar')  } asDictionary.
	1 to:20 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;copy )].
	
	result := db mangoQuery 
						selector: [:a| a foo includesAll: #('bar') ];
						selector: [:a| a val = 15];
						limit:5;
						fields: #(#_id #val);
						sort: #(#_id );
						execute.

	self assert:  result size equals: 1.

	db adaptor deleteDatabase: db name.
	

