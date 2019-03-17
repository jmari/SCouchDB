private
shows
	"shows node for CouchDB show functions"
	^ self at:'shows' ifAbsentPut:[SCJsonObject new]