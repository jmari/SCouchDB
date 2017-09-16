accessing
at: anUUID put: anObject 
	anUUID isArray ifTrue: [^ self at: ((anUUID at:1),'/',(anUUID at:2)) put: anObject ].
	self compactIfNeeded.
	self mutex critical: [ 
		reversedObjects at: anObject ifAbsent:[
					objects at: anUUID put: anObject.
					reversedObjects at: anObject put:anUUID.
					versions removeKey: anUUID ifAbsent:[nil]]]