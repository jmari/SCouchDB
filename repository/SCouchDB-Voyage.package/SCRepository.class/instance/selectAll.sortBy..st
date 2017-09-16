persistence
selectAll: aClass sortBy: sortBlockOrArray
	^ self selectMany: aClass where: nil sortBy: sortBlockOrArray limit: self maxObjectsInMem