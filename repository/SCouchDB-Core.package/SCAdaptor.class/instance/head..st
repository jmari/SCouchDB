http api
head: path 
	self resetZnClientPath.
	self znClient 
		host:self host;
		port: self port; 
		addPath:path;
		head.
	self resetZnClientUrl.
	^ self znClient response			
	
	