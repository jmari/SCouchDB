http api
delete: path 
	
	| response result |
	
	self resetZnClientPath.
	response := self znClient
							addPath:path;
							method:#DELETE;
							execute;
							response.
	self resetZnClientUrl.
	
	result := 	self materializer materialize: response contents.
	^ self znClient isSuccess 
						ifTrue:[result]
						ifFalse: [ self couchDBError:result ]		
	
	