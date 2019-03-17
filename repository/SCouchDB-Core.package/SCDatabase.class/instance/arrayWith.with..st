helper methods
arrayWith: anString with: anStringOrArray
	^ (anStringOrArray isKindOf:String) 
				ifTrue:[	Array with:anString with: anStringOrArray]
				ifFalse:[ self arrayWith:anString withAll: anStringOrArray]
