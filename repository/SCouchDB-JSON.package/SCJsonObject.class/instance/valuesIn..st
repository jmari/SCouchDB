accessing
valuesIn: anArrayOfSymbol
	|values|
	values :=Array new: anArrayOfSymbol size.
	anArrayOfSymbol doWithIndex: [ :k :i |
		values at:i put:(self at:k) asString
		].
	^ values