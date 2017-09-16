http api
post: path entity: anEntity
	| response result |
	self  resetZnClientPath.
	response:= self znClient 
						addPath:path;
						entity: anEntity;
						post;
						response.
	self  resetZnClientUrl.

	result := self materializer materialize: response contents.	
	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	