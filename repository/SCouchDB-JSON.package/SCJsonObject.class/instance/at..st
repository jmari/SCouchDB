accessing
at: aKey

	"make it work more like javascript objects"
	^ self at: aKey ifAbsent: [nil]