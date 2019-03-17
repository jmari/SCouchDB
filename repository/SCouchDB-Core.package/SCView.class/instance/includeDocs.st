query
includeDocs
	"Include the full content of the documents in the return. Default is false"
	self adaptor znClient queryAt: 'include_docs' put: true.
	