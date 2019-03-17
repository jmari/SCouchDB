tests
testErrorInvalidDocid

	| db |
	
	db := self createFreshDB.

	self should: [ db documentAt: '2' ] raise: SCError.
	
	db adaptor deleteDatabase: db name

