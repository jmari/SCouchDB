query
keys: anObject
	"Return only documents that match the specified keys. Optional"
	self adaptor znClient queryAt: 'keys' put: (self database plainSerializer serialize:anObject).
	