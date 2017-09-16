accessing
mustache: aMustacheTemplate
	(aMustacheTemplate isKindOf:MustacheTemplate)
		ifTrue:[self at:'mustache' put: aMustacheTemplate render]
		ifFalse:[self at:'mustache' put: aMustacheTemplate asString]