query
key: anObject
	" Return only documents that match the specified key. Optional"
	self adaptor znClient queryAt: 'key' put: (self database plainSerializer serialize:anObject).
	