tests
objectsAsDocuments
	| dict |
	dict := Dictionary new.
	dict at: '1' put: 10;
		at: 'foo' put: 'bar';
		at: 'table' put: #(4 5 6);
		at: 'bool' put: true.		

	^ {
		#Array -> #(1 2 3) asOrderedCollection.
		#Point -> (1 @ 2).
		#Set -> #(1 2 3 4 true) asSet.
		"A json limitation: Dictionary keys should be strings"
		#Dictionary ->  dict .
	} asDictionary