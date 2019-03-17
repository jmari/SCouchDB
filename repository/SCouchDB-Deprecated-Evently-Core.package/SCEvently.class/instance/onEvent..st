accessing
onEvent:anEventlyEvent
	((anEventlyEvent at:1 )~=$_) ifTrue:[self events add:anEventlyEvent].
	^self at:anEventlyEvent 