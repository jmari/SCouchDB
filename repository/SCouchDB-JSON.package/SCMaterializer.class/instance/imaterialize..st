private
imaterialize: json

	| className binding objectCached |

	objectCached := json copy.
	(json isKindOf:Dictionary) ifTrue:[
		objectCached := SCObjectsCache instance at:(json at:self idField ifAbsent:[nil]) ifAbsent:[nil].		
		objectCached ifNil:[
			className := json at: '#instanceOf' ifAbsent:[self defaultMapClass asString].
			"we're intentionally avoid using any globals here, such as Smalltalk"
			binding := (self class environment bindingOf: className asSymbol)
								ifNil: [ 
									"try to materialize in the Default class"
									self class environment bindingOf:self defaultMapClass asString asSymbol ].
			objectCached :=binding value new]].

	^ self injectValuesFrom: json into: objectCached. 
	