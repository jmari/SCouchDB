server-level
uuids: aNumber

	self znClient
				host:self host;
				port: self port; 
				queryAt:'count' put: aNumber asString.
	^ self get:'_uuids'.	
	

	