query
descending
	"Return the documents in descending by key order. Default is false"
	self adaptor znClient queryAt: 'descending' put: true.
	