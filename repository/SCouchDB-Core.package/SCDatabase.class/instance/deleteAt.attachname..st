documents-attachment
deleteAt: id attachname: attName
	^ self deleteAt: id attachname: attName rev: (self documentCurrentRevAt:id)