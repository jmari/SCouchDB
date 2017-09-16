query
skip: anInteger
	"Skip this number of records before starting to return the results. Default is 0"
	self adaptor znClient queryAt: 'skip' put: anInteger.

	