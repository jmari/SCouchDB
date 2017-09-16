as yet unclassified
serializer
	^ serializer ifNil:[ serializer := SCSerializer new serializeAllCollectionsAsArrays ]