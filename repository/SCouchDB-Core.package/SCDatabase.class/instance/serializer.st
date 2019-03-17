serializing
serializer
	^ serializer ifNil:[ serializer := SCSerializer on:self adaptor]