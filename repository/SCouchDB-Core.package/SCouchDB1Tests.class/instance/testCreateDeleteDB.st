tests
testCreateDeleteDB


	
	(self couchdb databases includes: self dbname) ifTrue: [
		self couchdb deleteDatabase: self dbname.
		].
	self assert: (self couchdb databases includes: self dbname) not.

	self couchdb createDatabase: self dbname.
	
	self assert: (self couchdb databases includes: self dbname).
	self couchdb deleteDatabase: self dbname.
	
