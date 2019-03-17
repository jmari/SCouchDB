accessing
lib
	^ self at:'lib' ifAbsentPut:[ SCJsonObject new]