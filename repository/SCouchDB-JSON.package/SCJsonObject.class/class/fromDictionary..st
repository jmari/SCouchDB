instance creation
fromDictionary: aDictionary

	| result |
	result := self new.
	
	aDictionary keysAndValuesDo: [:k :v|
		result at: k  put: (
				self pool at:k 
					ifPresent:[self pool at:k]
					ifAbsentPut:[ v asSCJsonObject ])
		].
	^ result