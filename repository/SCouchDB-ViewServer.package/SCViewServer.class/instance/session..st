accessing
session: anObject
	"session could be the StandardFileStream stdout or a TCP session depending on the kind of connection"
	^ session := anObject