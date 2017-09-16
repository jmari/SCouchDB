documents
bulkRemoveDocs: anObjectArray
	^ self bulkDocs:(
			(anObjectArray 	collect:[:aObject| aObject asSCDocument markAsDeleted])) 
	
												