materializer
materializeFromStream: jsonStream
	"materializes a json object serialized in a stream as an Smalltalk Object"
	
	^ self imaterialize: ( self readFrom: jsonStream)