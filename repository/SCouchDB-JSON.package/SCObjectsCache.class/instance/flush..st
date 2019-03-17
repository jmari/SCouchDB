removing
flush: anObject
	| oid o |
	self mutex critical: [ 
		oid := (self keyAtValue: anObject).
		o := self at:oid.
		(o = #deleted ) ifTrue:[
			objects removeKey: oid ifAbsent: [].
			reversedObjects removeKey: anObject ifAbsent: [].
			versions removeKey: oid ifAbsent: [] ]]