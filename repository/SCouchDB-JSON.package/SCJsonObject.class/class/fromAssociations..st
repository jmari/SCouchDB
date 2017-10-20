instance creation
fromAssociations: collectionOfAssociations

	| result |
	result := self new.
	
	collectionOfAssociations do: [:each |
		result at: each k  put: (
				self pool at: each k 
					ifPresent:[self pool at: each k]
					ifAbsentPut:[ each v asSCJsonObject ])
		].
	^ result