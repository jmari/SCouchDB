documents
documentPut: jsonObject
	|uuid|

	uuid :=  self uuidProvider discoverIdFor: jsonObject.
			
	^ uuid 
			ifNil: [ 
				uuid := self serializer uuidProvider getUUIDFor: jsonObject.
				self documentAt:uuid put: jsonObject]
			ifNotNil: [ self documentAt: uuid update: jsonObject  ]
