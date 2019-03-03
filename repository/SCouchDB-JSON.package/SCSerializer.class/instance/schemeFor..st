private
schemeFor:aClass

	^ aClass isVoyageRoot 
						ifTrue:[ self blockForRootObjects]
						ifFalse:[	self schemes at: aClass ifAbsent:[ self schemeFor:aClass superclass ]].
	
