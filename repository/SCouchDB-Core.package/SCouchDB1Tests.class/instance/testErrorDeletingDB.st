tests
testErrorDeletingDB


	
	(self couchdb databases includes: self dbname) ifTrue: [
		self couchdb deleteDatabase: self dbname.
		].

	self should: [ self couchdb deleteDatabase: self dbname]  raise: SCError

