persistence
selectMany: aClass where: aWhereBlock sortBy: sortBlockOrArray limit: limit
	^ self selectMany: aClass where: aWhereBlock  sortBy: sortBlockOrArray limit: limit offset: 0 