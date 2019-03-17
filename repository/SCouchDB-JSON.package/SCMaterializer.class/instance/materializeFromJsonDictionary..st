materializer
materializeFromJsonDictionary: jsonDictionary
	"materializes a json object (not in string form) as an Smalltalk Object"

	^ self imaterialize: jsonDictionary