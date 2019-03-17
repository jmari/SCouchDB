accessing
filters
	^ self at:'filters' ifAbsentPut:[SCJsonObject new]