as yet unclassified
materializeFromString: aString
	"materializes as a Dictionary nor a Smalltalk class"
	| aStream |
	
	aStream :=ReadStream on:aString.
	^ self new materializeFromStream: aStream.