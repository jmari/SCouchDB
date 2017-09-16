query
endKeyDocId: anObject
	"Stop returning records when the specified document ID is reached. Optional"
	self adaptor znClient queryAt: 'endkey_doc_id' put: anObject.
	