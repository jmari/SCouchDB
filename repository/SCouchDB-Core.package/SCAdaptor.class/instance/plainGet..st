http api
plainGet: path 
	| response |
	
	self resetZnClientPath.
	response:= self znClient
							addPath:path;
							get;
							response.	
	self resetZnClientUrl.											

	^ response isSuccess 
						ifTrue: [ response contents ]
						ifFalse: [ self  couchDBError: response contents]
	