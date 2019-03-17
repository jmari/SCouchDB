tests
testStoringConvertedDocuments
	| db doc i|
	db := self createDB.
	i:=1.
	self objectsAsDocuments keysAndValuesDo: [:k :v| 
		"save object into couch db"
		db documentAt: i asString put: v.	
		"dict test fails by now"
		doc := db  documentAt:i asString.
		self assert: doc equals: v.
		i := i +1.
	].

	db adaptor deleteDatabase: db name.
	