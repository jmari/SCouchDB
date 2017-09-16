utils
createFreshDB

	(self couchdb databases includes: self dbname) ifTrue: [
		self couchdb deleteDatabase: self dbname. ].
	^ self couchdb  createDatabase: self dbname