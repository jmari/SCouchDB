private
selectors
	^ self at:'selectors' ifAbsent:[self at:'selectors' put:(SCJsonObject new)].