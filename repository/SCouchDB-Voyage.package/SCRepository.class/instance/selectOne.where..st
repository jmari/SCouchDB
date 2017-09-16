persistence
selectOne: aClass where: aWhereBlock	
	| arr |
	arr:=(self selectMany: aClass where: aWhereBlock sortBy: #() limit: 1).
	^ arr size > 0
		ifTrue:[ arr at:1]
		ifFalse: [nil]