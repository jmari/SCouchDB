documents
deleteDocument: id revision: aRev

	self adaptor znClient queryAt:'rev' put: aRev.
	^ self adaptor delete:(self arrayWith: self name with: id).
				