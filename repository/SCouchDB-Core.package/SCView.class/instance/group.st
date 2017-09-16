query
group
	"group rows by its key"
	self adaptor znClient queryAt: 'group' put: true.
	