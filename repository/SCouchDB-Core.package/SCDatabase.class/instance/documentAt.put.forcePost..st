documents
documentAt: id put: jsonObject forcePost:forcePost
	| result jsonString entity |
	(jsonObject isKindOf:SCApp) ifTrue:[jsonObject database:self].
	(self hasAttachments:jsonObject) 
				ifTrue:[^ self documentMultipartAt:id put:jsonObject].
				
	jsonString :=self serializer serialize:jsonObject .
	entity := (ZnStringEntity text:jsonString) contentType: ZnMimeType applicationJson.
	

	result:=	id ifNil:[self adaptor 
							post: self name
							entity: entity.]
					ifNotNil:[forcePost 
								ifTrue:[ self adaptor 
													post:( self arrayWith:self name with: id)
													entity:entity]
								ifFalse:[  self adaptor 
													put:( self arrayWith:self name with: id)
													entity:entity]].

	^result.
