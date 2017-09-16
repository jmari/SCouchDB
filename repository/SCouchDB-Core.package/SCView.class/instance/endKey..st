query
endKey: anObject
	"Stop returning records when the specified key is reached. Optional"
	self adaptor znClient queryAt: 'endkey' put: (self database plainSerializer serialize:anObject).
	