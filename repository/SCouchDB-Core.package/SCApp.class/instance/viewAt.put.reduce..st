views
viewAt:name put:aView reduce:aReduceFunction
	|v aViewCode aReduceCode|

	v:=SCJsonObject new.
	aViewCode:= (aView isKindOf: BlockClosure) 
						ifTrue:[aView]
						ifFalse:[aView asString ].

	v map:(aViewCode).

	aReduceCode:= (aReduceFunction isKindOf: BlockClosure) 
						ifTrue:[aReduceFunction]
						ifFalse:[aReduceFunction asString ].
	aReduceFunction ifNotNil:[v at:'reduce' put:(aReduceCode)].
	self views at:name put:v.
