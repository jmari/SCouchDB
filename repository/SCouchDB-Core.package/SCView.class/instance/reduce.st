query
reduce
	"group rows by its key"
	self adaptor znClient queryAt: 'reduce' put: true.
	