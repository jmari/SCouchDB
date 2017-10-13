instance creation
fromCollection: collection

	| result |
	result := Array new: collection size.
	
	collection doWithIndex: [:each :index |
		result at: index put: each asSCJsonObject  ].
	^ result