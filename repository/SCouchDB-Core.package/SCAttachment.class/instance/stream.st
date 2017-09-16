as yet unclassified
stream
	|a|
	"stream is only setted when the instance creation is done with fromStream:withName:"
	stream ifNotNil: [^stream reset].
	a:=StandardFileStream readOnlyFileNamed:fileName .
	a binary.
	^a

