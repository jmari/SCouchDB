accessing
maxObjectsInMem
	^ maxObjectsInMem ifNil:[maxObjectsInMem := 65536]