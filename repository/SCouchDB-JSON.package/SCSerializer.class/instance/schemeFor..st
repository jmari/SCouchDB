private
schemeFor:aClass

	^  self schemes at: aClass ifAbsent:[ self schemeFor:aClass superclass ].
	
