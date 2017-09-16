as yet unclassified
database: databaseString
	|repo|
	repo :=self
				host: self defaultHost 
				port: self defaultPort.
		
	repo database: (repo adaptor ensureDatabase: databaseString).

	^ repo
	