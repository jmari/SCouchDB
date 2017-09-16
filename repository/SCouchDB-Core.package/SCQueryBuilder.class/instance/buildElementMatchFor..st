building
buildElementMatchFor: aBlock
	^ self newGenerator visit: (aBlock value: self newElementMatch)