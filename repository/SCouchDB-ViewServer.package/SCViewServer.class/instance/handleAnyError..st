error handling
handleAnyError: e
	| response |
	
	response := (self serializer serialize: 
												(Array 
													with:'error' 
													with: e signaler asString
													with: e description )).
	self debug: response.


	