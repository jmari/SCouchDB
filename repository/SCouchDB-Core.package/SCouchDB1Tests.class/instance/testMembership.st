tests
testMembership
	
	| r |
	
	r := self couchdb membership.
	self assert: r size > 0.

	
