utils
createDB
	^ self couchdb ensureDatabase: self dbname.
