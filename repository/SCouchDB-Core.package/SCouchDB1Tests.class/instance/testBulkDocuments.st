tests
testBulkDocuments
	
	| db arr time |
	db := self createDB.	
	
	arr := self largeObject. 				
	time := [db bulkDocs: arr] timeToRun.
	Transcript show: time asString.
	self assert:  db documents size equals: 500.
	
	db bulkRemoveDocs: arr.
	self assert:  db documents size equals: 0.	

	self couchdb deleteDatabase: db name.
				
