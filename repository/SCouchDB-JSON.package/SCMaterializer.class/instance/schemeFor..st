private
schemeFor:aClass
	|scheme|
	scheme := self schemes at: aClass ifAbsent:[ self schemeFor:aClass superclass ].
	^scheme