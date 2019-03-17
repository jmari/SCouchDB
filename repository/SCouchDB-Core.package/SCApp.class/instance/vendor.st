accessing
vendor
	^ self at:'vendor' ifAbsentPut:[SCJsonObject new]