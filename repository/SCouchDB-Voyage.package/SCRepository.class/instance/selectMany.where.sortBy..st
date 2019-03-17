persistence
selectMany: aClass where: aWhereBlock sortBy: sortBlockOrArray
	^ self selectMany: aClass where: aWhereBlock sortBy: sortBlockOrArray limit: self maxObjectsInMem