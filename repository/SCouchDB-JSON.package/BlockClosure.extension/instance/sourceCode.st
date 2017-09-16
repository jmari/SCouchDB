*SCouchDB-JSON
sourceCode
	|sc|

	sc:= (self respondsTo: 'decompile') 
								ifTrue:[ self decompile asString]
								ifFalse:[ self asString ].
((sc at:1) = ${) ifTrue:[
	^ sc copyFrom:2 to: (sc size - 1)
	].
^ sc