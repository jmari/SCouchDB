tests
testStatistics

	| adaptor stats |
	
	adaptor := self couchdb.

	stats := adaptor statistics:'couchdb@localhost'.
	stats inspect.
	self assert: (stats includesKey: 'couchdb')