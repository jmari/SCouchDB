execution
execute
	| result jsonString |

	jsonString := self database plainSerializer serialize: self.


	result := self database adaptor post:
						(Array with: self database name with: self command)
						entity: ((ZnStringEntity 
										text:jsonString) contentType: ZnMimeType applicationJson ).
	
	^ result at:'docs'