accessing
database
	^ database ifNil:[ self database:	self defaultDatabaseName. database].