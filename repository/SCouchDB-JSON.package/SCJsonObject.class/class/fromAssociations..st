instance creation
fromAssociations: collectionOfAssociations

	| result |
	result := self new.
	
	collectionOfAssociations do: [:each |
		result at: each key  put: (
				self pool at: each key 
					ifPresent:[self pool at: each key]
					ifAbsentPut:[ each value asSCJsonObject ])
		].
	^ result