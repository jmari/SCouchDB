accessing
query
	^ self at:'query' ifAbsentPut: [ SCEventlyQuery new ]