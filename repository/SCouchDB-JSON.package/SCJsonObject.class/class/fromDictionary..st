as yet unclassified
fromDictionary: aDictionary

	| result |
	result := self new.
	
	aDictionary keys do: [:each |
		result at: each  put:( aDictionary  at:each) ].
	^ result