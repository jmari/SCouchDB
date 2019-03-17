documents
documentAt: id rev: rev

	
	self adaptor znClient queryAt:'rev' put: rev.
	^ self adaptor get:(self arrayWith:self name with: id)
									

	 