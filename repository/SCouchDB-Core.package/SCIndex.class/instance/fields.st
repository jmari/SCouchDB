accessing
fields
	^ self at:'index' ifPresent:[ (self at:'index') at:#fields ifAbsent:[nil]]