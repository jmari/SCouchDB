query
conflicts
	" Includes conflicts information in response. Ignored if include_docs isn’t true. Default is false"
	self adaptor znClient queryAt: 'conflicts' put: true.
	