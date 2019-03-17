db api
ensureDatabase: aName
	"Either create new or answer an existing database."

	^ (self hasDatabase: aName) 
			ifFalse: [ self createDatabase: aName ]
			ifTrue:[ self database name: aName ]