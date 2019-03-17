http api
get: path 
	| response result |
	
	self resetZnClientPath.
	response:= self znClient
							addPath:path;
							get;
							response.	
	self resetZnClientUrl.											
	result := self materializer materialize: response contents.
	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self  couchDBError: result ]
	