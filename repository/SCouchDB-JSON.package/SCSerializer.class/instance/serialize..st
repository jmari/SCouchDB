serializing
serialize: anObject 
	| str |
	self pool removeAll.
	str := WriteStream on:String new.
	anObject class isVoyageRoot ifTrue:[str nextPut:$[].
	self serialize:anObject to: str.
	anObject class isVoyageRoot ifTrue:[str nextPut:$]].
	^ str contents	

