query
limit: anInteger
	"Limit the number of the returned documents to the specified number. Optional"
	self adaptor znClient queryAt: 'limit' put: anInteger.
