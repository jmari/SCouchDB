instance creation
fromAssociations: collectionOfAssociations

	| result |
	result := self new.
	
	collectionOfAssociations do: [:each |
		result at: each key  put: (
				self pool at: each value 
					ifPresent:[self pool at: each value]
					ifAbsentPut:[ each value asSCJsonObject ])
		].
	^ result