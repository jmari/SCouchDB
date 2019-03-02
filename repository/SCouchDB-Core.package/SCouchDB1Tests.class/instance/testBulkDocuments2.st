tests
testBulkDocuments2
	
	| db arr time |
	db := self createDB.	
	
	arr := self veryLargeObject. 				
	time := [db bulkDocs: arr] timeToRun.
	Transcript show: time asString.	
	time := [db bulkRemoveDocs: arr].

	Transcript show: time asString.
	"self couchdb deleteDatabase: db name."
				
