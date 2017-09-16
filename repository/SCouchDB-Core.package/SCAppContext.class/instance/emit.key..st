views
emit:aJsonDoc key:aKey
	buf ifNil:[buf:= Stack new].
	buf push:( Array with:aKey with: aJsonDoc).
	self filter viewEmit:true.

	
