http api
put: path entity: anEntity
	| response result |
	self  resetZnClientPath.
	response:= self znClient 
						addPath:path;
						entity: anEntity;
						put;
						response.
	self  resetZnClientUrl.

	result := self materializer materialize: response contents.	
	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	