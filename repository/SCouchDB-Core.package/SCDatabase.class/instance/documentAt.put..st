documents
documentAt: id put: jsonObject
	| uuid |
	uuid := id.
	uuid ifNil:[	uuid := self uuidProvider discoverIdFor: jsonObject].
	uuid ifNotNil:[ self assureId:uuid cachedFor:jsonObject].
	^ self documentAt: uuid put: jsonObject forcePost: false
