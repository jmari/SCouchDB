authentication
session

	| contents result |

	contents:= self 
						post: '_session' 
						content: self buildAuthString 
						type:ZnMimeType applicationFormUrlEncoded.
		

	result := self materializer readFromString:  contents.
	self znClient response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	