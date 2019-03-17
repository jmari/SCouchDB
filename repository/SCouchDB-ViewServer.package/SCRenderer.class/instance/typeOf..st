runner
typeOf:value
	(value isKindOf: Array ) 
				ifTrue:[^'array']
				ifFalse:[^'null'].

