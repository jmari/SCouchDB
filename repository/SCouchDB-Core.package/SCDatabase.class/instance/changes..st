database
changes:jsonObject

	| jsonEntity|
	
	jsonEntity:= ((ZnStringEntity text:(self serializer serialize:jsonObject))
												contentType: ZnMimeType applicationJson ).

	^ self adaptor 
				post: (self arrayWith: self name with: '_changes')	
				entity: jsonEntity.
