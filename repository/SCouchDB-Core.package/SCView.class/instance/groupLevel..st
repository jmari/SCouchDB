query
groupLevel: anInteger
	"group rows by its key"
	self adaptor znClient queryAt: 'group_level' put: anInteger asString.
	