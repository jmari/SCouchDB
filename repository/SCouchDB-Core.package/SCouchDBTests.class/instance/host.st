utils
host
	^ host ifNil: [ host := DefaultHost ifNil: ['localhost']]