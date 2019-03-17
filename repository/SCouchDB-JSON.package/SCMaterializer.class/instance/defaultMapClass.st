accessing
defaultMapClass
	"SCJsonObject or SCDocument or Dictionary or..."
	^ defaultMapClass ifNil:[defaultMapClass := SCJsonObject ]