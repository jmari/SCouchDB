documents
bulkDocs:jsonObject
	"Request JSON Object: docs (array) – List of documents objects"
	| result jsonEntity |

	jsonEntity:= ((ZnStringEntity text:(self serializer 
												serialize:	(SCJsonObject new at:'docs' put:jsonObject;yourself)))
												contentType: ZnMimeType applicationJson ).
	
	result:= self adaptor 
								post:	(self arrayWith: self name with:'_bulk_docs')
								entity: jsonEntity.


	^ result
					
