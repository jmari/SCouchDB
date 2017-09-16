documents
documentAt: id update: jsonObject
	| uuid |
	uuid := id.
	uuid ifNil:[	uuid := self uuidProvider discoverIdFor: jsonObject].
	uuid ifNotNil:[ 
		self assureId:uuid cachedFor: jsonObject.
		SCObjectsCache instance at:id putRevision: (self documentCurrentRevAt:uuid)].
	self documentAt:uuid put: jsonObject.  

	
	
	
	

	
