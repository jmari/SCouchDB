query
startKeyDocId: anObject
	"Return records starting with the specified document ID. Optional"
	self adaptor znClient queryAt: 'startkey_doc_id' put: anObject.
	