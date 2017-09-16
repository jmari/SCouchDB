query
inclusiveEnd
	"Specifies whether the specified end key should be included in the result. Default is true."
	self adaptor znClient queryAt: 'inclusive_end' put: true.
	