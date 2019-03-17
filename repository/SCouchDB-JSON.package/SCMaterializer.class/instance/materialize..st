materializer
materialize: jsonString
	"materializes a json object serialized in a string as an Smalltalk Object"
	| aStream |

	aStream := ReadStream on: jsonString.
	^ self imaterialize: ( self readFrom: aStream)