documents
documentAt: id ifAbsentPut: aBlockWithJsonObject
	^ self documentAt: id ifAbsent:[ self documentAt: id put: aBlockWithJsonObject value].
