documents
documentRevisionsAt: id 

	self adaptor znClient queryAt:'revs' put: 'true'.
	^ self adaptor get: (self arrayWith: self name with: id ).
									