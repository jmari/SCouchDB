persistence
selectMany: aClass where: aBlock
	^ self selectMany: aClass where: aBlock sortBy: #() limit: self maxObjectsInMem