building
buildAllMatchFor: aBlock
	^ self newGenerator visit: (aBlock value: self newAllMatch)