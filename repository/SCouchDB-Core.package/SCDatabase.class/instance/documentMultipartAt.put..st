private
documentMultipartAt: id put: jsonObject
	| entity jsonEntity |

	jsonEntity:= ((ZnStringEntity text:(self serializer serialize:jsonObject))
												contentType: ZnMimeType applicationJson ).
							
	entity:=  (SCMultiPartRelatedEntity new).
	entity addPart: jsonEntity.
	(jsonObject at:'_attachments') ifNotNil: [self addMultipartAttachments: (jsonObject at:'_attachments') entity:entity].
	
	self adaptor znClient timeout:100000.
	^ self adaptor put: (self arrayWith:self name with: id) entity: entity
