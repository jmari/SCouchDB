accessing
lists
	^ self at:'lists' ifAbsentPut:[SCJsonObject new]