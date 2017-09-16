persistence
selectAll: aClass
	^ self selectMany: aClass where: nil sortBy: #() limit: self maxObjectsInMem
						  