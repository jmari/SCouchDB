query
startKey: anObject
	"Return records starting with the specified key. Optional"
	self adaptor znClient queryAt: 'startkey' put: (self database plainSerializer serialize:anObject).
	