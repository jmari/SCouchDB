as yet unclassified
readFromString: aString
	"materializes as a Dictionary nor a Smalltalk class"
	| aStream |
	
	aStream :=ReadStream on:aString.
	^ self new readFrom: aStream.