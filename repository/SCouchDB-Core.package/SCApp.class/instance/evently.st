deprecated
evently
	self  deprecated: 'evently is no longer supported'. 
	^ self at:'evently' ifAbsentPut:[SCEvently new]