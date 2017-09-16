serialization
serializer
	^ serializer ifNil:[ serializer := SCSerializer new serializeAllCollectionsAsArrays ]