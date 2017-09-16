accessing
onEvent:anEvent do:anObject
anObject isArray ifTrue:[triggers addAll: anObject ]
	ifFalse:[self addTriggersFromJSCode:anObject].
	((anEvent at:1 )~=$_) ifTrue:[self events add:anEvent].
self at:anEvent put:anObject.
^self at:anEvent 