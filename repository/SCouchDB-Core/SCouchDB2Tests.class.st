Class {
	#name : #SCouchDB2Tests,
	#superclass : #SCouchDBTests,
	#category : 'SCouchDB-Core-Tests'
}

{ #category : #tests }
SCouchDB2Tests >> testFindingDocuments1 [
	
	| db doc query result |
	
	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0  } asDictionary.
	1 to:20 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;deepCopy )].

	query := {  
    'selector'-> {'val' -> {'$gt'-> 10} asDictionary } asDictionary .
    'fields' -> #('_id'  '_rev'  'val').
    'sort' -> {{'_id' -> 'asc'} asDictionary}.
    'limit'-> 100.
    'skip'-> 0} asDictionary .	
	result := db mangoQuery query: query;execute.

	self assert:  result size equals: 10 .

	db adaptor deleteDatabase: db name.
	

]

{ #category : #tests }
SCouchDB2Tests >> testFindingDocuments2 [
	
	| db doc result |
	
	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0  } asDictionary.
	1 to:20 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;deepCopy )].
	
	result := db mangoQuery selector: [:a| a val < 11 ];execute.


	self assert:  result size equals: 10 .

	db adaptor deleteDatabase: db name.

]

{ #category : #tests }
SCouchDB2Tests >> testFindingDocuments3 [
	
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
	

]

{ #category : #tests }
SCouchDB2Tests >> testFindingDocuments3WithIndex [
	
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
	

]

{ #category : #tests }
SCouchDB2Tests >> testFindingDocuments4 [
	
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
	


]

{ #category : #tests }
SCouchDB2Tests >> testFindingDocuments5 [
	
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
	


]

{ #category : #'as yet unclassified' }
SCouchDB2Tests >> testRendering [

	| cosa |
	cosa:= [ :each|( each name = 'john') & (each orders > 10) ] asMangoQuery.
	
	cosa inspect
]
