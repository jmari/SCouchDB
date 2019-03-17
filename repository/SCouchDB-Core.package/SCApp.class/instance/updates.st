accessing
updates
	"updates node for CouchDB update functions"
	^ self at:'updates' ifAbsentPut: [SCJsonObject new].
