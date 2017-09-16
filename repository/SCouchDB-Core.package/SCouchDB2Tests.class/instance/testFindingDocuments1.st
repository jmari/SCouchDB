tests
testFindingDocuments1
	
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
	
