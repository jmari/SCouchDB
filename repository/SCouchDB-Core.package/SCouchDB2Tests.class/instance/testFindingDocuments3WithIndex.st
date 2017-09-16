tests
testFindingDocuments3WithIndex
	
	| db doc result index |
	
	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0  } asDictionary.
	1 to:20 do:[: i |
				db documentAt: i asString put: ( doc at:'val' put:i;copy )].
	index :=db index 
			name:#byVal;
			fields: #(#val);
			new.

	result := db mangoQuery 
						selector: [:a| a val <= 11 ];
						limit:5;
						fields: #(#_id #val);
						sort: #(#val );
						skip:4;
						useIndex: index;
						execute.
						
	self assert:  result size equals: 5.
	index :=db index delete: index.
	db adaptor deleteDatabase: db name.
	
