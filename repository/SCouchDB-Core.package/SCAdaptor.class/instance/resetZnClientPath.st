http api
resetZnClientPath
	|url|
	url := self znClient request url.
	self znClient url: ''.
	url hasQuery ifTrue:[self znClient request url queryAddAll: url query]
