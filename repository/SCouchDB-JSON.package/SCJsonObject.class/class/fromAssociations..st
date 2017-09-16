as yet unclassified
fromAssociations: collectionOfAssociations

	| result |
	result := self new.
	
	collectionOfAssociations do: [:each |
		result at: each key put: each value ].
	^ result