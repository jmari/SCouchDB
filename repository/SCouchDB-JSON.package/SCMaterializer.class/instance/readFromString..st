parsing
readFromString: aString
	
	self stream: (ReadStream on: aString).
	^ self readAny