tests
testFindingDocuments3
	
	| db doc query |
	
	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0  } asDictionary.
	1 to:20 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;copy )].
	
	query := db mangoQuery 
						selector: [:a| a val <= 11 ];
						limit:5;
						fields: #(#_id #val);
						sort: #(#val );
						skip:4.
	self should: [ query execute ] raise: SCError.

	db adaptor deleteDatabase: db name.
	
