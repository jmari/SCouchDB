instance creation
fromCollection: collection

	| result |
	((collection size >= 1) and:[collection first isKindOf: Association ]) ifTrue:[^self fromAssociations:collection].
	result := Array new: collection size.
	
	collection doWithIndex: [:each :index |
		result at: index put:  (
				self pool at: each 
					ifPresent:[self pool at:each]
					ifAbsentPut:[ each asSCJsonObject ])
		].
	^ result