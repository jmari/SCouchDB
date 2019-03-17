documents
documentRevsInfoAt: id 

	self adaptor znClient queryAt:'revs_info' put: 'true'.
	^ self adaptor get: (self arrayWith: self name with: id ).
