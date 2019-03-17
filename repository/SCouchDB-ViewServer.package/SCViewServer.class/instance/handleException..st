error handling
handleException: e
	| response |
	
	response := (self serializer serialize: 
												(Array 
													with:'error' 
													with: e errorType 
													with: e description )).
	self debug: response.
	self println: response

	