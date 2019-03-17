accessing
fields: anArrayOfStrings
	self at:'index' put: (Dictionary new at:#fields put:anArrayOfStrings;yourself)