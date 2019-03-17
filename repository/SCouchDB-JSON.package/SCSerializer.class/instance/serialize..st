serializing
serialize: anObject 
	| str |
	self pool removeAll.
	str := WriteStream on:String new.
	self serialize:anObject to: str.
	^ str contents	

