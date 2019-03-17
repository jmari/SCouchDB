serializing
plainSerializer
	^ plainSerializer ifNil:[ plainSerializer := SCSerializer new serializeAllCollectionsAsArrays ]