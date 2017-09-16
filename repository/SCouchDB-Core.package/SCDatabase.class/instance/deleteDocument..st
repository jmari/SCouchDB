documents
deleteDocument: id 

	^ self deleteDocument: id  revision: (self documentCurrentRevAt: id) asString