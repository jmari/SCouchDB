http api
post: path content: aContent type:aContentType
	| response result |
	self  resetZnClientPath.
	self znClient addPath:path.
	aContent ifNotNil:[	
			self znClient 
					entity: (ZnEntity 
						readFrom: aContent readStream
						usingType: aContentType 
						andLength: aContent size)].
	response := self znClient post;response.
	self  resetZnClientUrl.
	result := self materializer readFromString: response contents.

	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	