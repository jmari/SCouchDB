authentication
host: aHost port: aPort userName:aUserName password:aPassword

	self host:aHost port:aPort.
	self user:aUserName.
	self password: aPassword.
	resolvedHost := nil.
	
	self session