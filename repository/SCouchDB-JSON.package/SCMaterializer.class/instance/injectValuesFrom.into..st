private
injectValuesFrom: json into: anObject
	|  mtz|

	mtz := self schemeFor: anObject class.
	^ mtz value:anObject value:json
	