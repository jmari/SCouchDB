Class {
	#name : #SCDatabase,
	#superclass : #Object,
	#instVars : [
		'adaptor',
		'name',
		'allOrNothing',
		'newEdits',
		'serializer',
		'plainSerializer',
		'materializer'
	],
	#category : 'SCouchDB-Core'
}

{ #category : #accessing }
SCDatabase >> adaptor [
	"Answer the value of adaptor"

	^ adaptor
]

{ #category : #accessing }
SCDatabase >> adaptor: anObject [
	"Set the value of adaptor"

	adaptor := anObject
]

{ #category : #private }
SCDatabase >> addMultipartAttachments:  attachmentsDictionary entity:entity [
	| stream type length|
	attachmentsDictionary values do: [:value|
		stream := value stream ifNil:[ReadStream on:value data].
		type := value contentType.
		length := value contentLength.
		entity addPart:(ZnStreamingEntity readFrom: stream usingType: type andLength: length)]
	
]

{ #category : #database }
SCDatabase >> all [
	| result |
	
	self includeDocs.
	result:= self adaptor get: (self 
											arrayWith:self name
											with: '_all_docs').

	^(result at: 'rows') collect: [:row | row at: 'doc']
]

{ #category : #applications }
SCDatabase >> applicationAt: appName [
	^ (self documentAt: ( Array with:'_design' with:appName asLowercase )) asSCApp database: self
		
]

{ #category : #'helper methods' }
SCDatabase >> arrayWith: anString with: anStringOrArray [
	^ (anStringOrArray isKindOf:String) 
				ifTrue:[	Array with:anString with: anStringOrArray]
				ifFalse:[ self arrayWith:anString withAll: anStringOrArray]

]

{ #category : #'helper methods' }
SCDatabase >> arrayWith: anString with: anStringOrArray with: a2String [
	^ self arrayWith: anString with:anStringOrArray with:a2String

]

{ #category : #'helper methods' }
SCDatabase >> arrayWith: anObject withAll: aCollection [

	| newArray |
	newArray := Array new: aCollection size + 1.
	newArray at: 1 put: anObject.
	newArray
		replaceFrom: 2
		to: newArray size
		with: aCollection.
	^newArray
]

{ #category : #'helper methods' }
SCDatabase >> arrayWithAll: aCollection with: anObject [

	| newArray |
	newArray := self new: aCollection size + 1.
	newArray
		replaceFrom: 1
		to: newArray size -1
		with: aCollection.
	newArray at: newArray size put: anObject.
	^newArray
]

{ #category : #private }
SCDatabase >> assureId:uuid cachedFor:jsonObject [
	SCObjectsCache instance at: uuid put:jsonObject

]

{ #category : #query }
SCDatabase >> batch [
	"batchs the operation, it will be in memory until is is commited by Couchdb"
	self adaptor znClient queryAt: 'batch' put: true.
	
]

{ #category : #documents }
SCDatabase >> bulkDocs:jsonObject [
	"Request JSON Object: docs (array) – List of documents objects"
	| result jsonEntity |

	jsonEntity:= ((ZnStringEntity text:(self serializer 
												serialize:	(SCJsonObject new at:'docs' put:jsonObject;yourself)))
												contentType: ZnMimeType applicationJson ).
	
	result:= self adaptor 
								post:	(self arrayWith: self name with:'_bulk_docs')
								entity: jsonEntity.


	^ result
					

]

{ #category : #documents }
SCDatabase >> bulkRemoveDocs: anObjectArray [
	^ self bulkDocs:(
			(anObjectArray 	collect:[:aObject| aObject asSCDocument markAsDeleted])) 
	
												
]

{ #category : #database }
SCDatabase >> changes [
	^ self changes: Dictionary new
]

{ #category : #database }
SCDatabase >> changes:jsonObject [

	| jsonEntity|
	
	jsonEntity:= ((ZnStringEntity text:(self serializer serialize:jsonObject))
												contentType: ZnMimeType applicationJson ).

	^ self adaptor 
				post: (self arrayWith: self name with: '_changes')	
				entity: jsonEntity.

]

{ #category : #database }
SCDatabase >> compact [
	^ self getDatabasePath: '_compact'

]

{ #category : #query }
SCDatabase >> conflicts [
	" Includes conflicts information in response. Ignored if include_docs isn’t true. Default is false"
	self adaptor znClient queryAt: 'conflicts' put: true.
	
]

{ #category : #database }
SCDatabase >> delete [

	self adaptor deleteDatabase: self name
]

{ #category : #'documents-attachment' }
SCDatabase >> deleteAt: id attachname: attName [
	^ self deleteAt: id attachname: attName rev: (self documentCurrentRevAt:id)
]

{ #category : #'documents-attachment' }
SCDatabase >> deleteAt: id attachname: attName rev: aRev [

	self adaptor znClient queryAt:'rev' put: aRev.
	^ self adaptor delete: (self self arrayWith: self name with: id with: attName).
					
]

{ #category : #documents }
SCDatabase >> deleteDocument: id [ 

	^ self deleteDocument: id  revision: (self documentCurrentRevAt: id) asString
]

{ #category : #documents }
SCDatabase >> deleteDocument: id revision: aRev [

	self adaptor znClient queryAt:'rev' put: aRev.
	^ self adaptor delete:(self arrayWith: self name with: id).
				
]

{ #category : #documents }
SCDatabase >> documentAt: id [

	"read a single json document"
	
	^ 	self adaptor get: (self arrayWith: self name with: id)		

]

{ #category : #'documents-attachment' }
SCDatabase >> documentAt: id attach: fileReference [
	^ self documentAt: id attach: fileReference rev:(self documentCurrentRevAt: id).
]

{ #category : #'documents-attachment' }
SCDatabase >> documentAt: id attach: fileReference rev:oldDocRev [
	|stream type length|
	
	stream := ZnFileSystemUtils fileStreamFor: fileReference.
	stream binary.
	type := ZnMimeType forFilenameExtension: (ZnFileSystemUtils extensionFor: fileReference).
	length := ZnFileSystemUtils fileSizeFor: fileReference.

	self adaptor znClient queryAt:'rev' put: oldDocRev.
	^ self adaptor put: (self self arrayWith:self name with:id  with:fileReference fullName)
					 entity:(ZnStreamingEntity readFrom: stream usingType: type andLength: length).



]

{ #category : #documents }
SCDatabase >> documentAt: id ifAbsent: aBlock [
	^ [self documentAt: id] on:Error do:[aBlock value]
]

{ #category : #documents }
SCDatabase >> documentAt: id ifAbsentPut: aBlockWithJsonObject [
	^ self documentAt: id ifAbsent:[ self documentAt: id put: aBlockWithJsonObject value].

]

{ #category : #documents }
SCDatabase >> documentAt: id put: jsonObject [
	| uuid |
	uuid := id.
	uuid ifNil:[	uuid := self uuidProvider discoverIdFor: jsonObject].
	uuid ifNotNil:[ self assureId:uuid cachedFor:jsonObject].
	^ self documentAt: uuid put: jsonObject forcePost: false

]

{ #category : #documents }
SCDatabase >> documentAt: id put: jsonObject forcePost:forcePost [
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

]

{ #category : #documents }
SCDatabase >> documentAt: id rev: rev [

	
	self adaptor znClient queryAt:'rev' put: rev.
	^ self adaptor get:(self arrayWith:self name with: id)
									

	 
]

{ #category : #documents }
SCDatabase >> documentAt: id update: jsonObject [
	| uuid |
	uuid := id.
	uuid ifNil:[	uuid := self uuidProvider discoverIdFor: jsonObject].
	uuid ifNotNil:[ 
		self assureId:uuid cachedFor: jsonObject.
		SCObjectsCache instance at:id putRevision: (self documentCurrentRevAt:uuid)].
	self documentAt:uuid put: jsonObject.  

	
	
	
	

	

]

{ #category : #documents }
SCDatabase >> documentCurrentRevAt: id [ 

	| response etag |
	id ifNil:[ self adaptor couchDBError:( 
										SCJsonObject new 
											at:'reason' put: 'id is Nil';
											at:'error' put: '000';
											yourself)].

	response := self adaptor head:(self arrayWith:self name with: id).
				
	etag :=  response headers at:'Etag' ifAbsent:[nil].
	^ etag ifNotNil:[ etag withoutQuoting ]
		
]

{ #category : #private }
SCDatabase >> documentMultipartAt: id put: jsonObject [
	| entity jsonEntity |

	jsonEntity:= ((ZnStringEntity text:(self serializer serialize:jsonObject))
												contentType: ZnMimeType applicationJson ).
							
	entity:=  (SCMultiPartRelatedEntity new).
	entity addPart: jsonEntity.
	(jsonObject at:'_attachments') ifNotNil: [self addMultipartAttachments: (jsonObject at:'_attachments') entity:entity].
	
	self adaptor znClient timeout:100000.
	^ self adaptor put: (self arrayWith:self name with: id) entity: entity

]

{ #category : #documents }
SCDatabase >> documentPut: jsonObject [
	|uuid|

	uuid :=  self uuidProvider discoverIdFor: jsonObject.
			
	^ uuid 
			ifNil: [ 
				uuid := self serializer uuidProvider getUUIDFor: jsonObject.
				self documentAt:uuid put: jsonObject]
			ifNotNil: [ self documentAt: uuid update: jsonObject  ]

]

{ #category : #documents }
SCDatabase >> documentRevisionsAt: id [ 

	self adaptor znClient queryAt:'revs' put: 'true'.
	^ self adaptor get: (self arrayWith: self name with: id ).
									
]

{ #category : #documents }
SCDatabase >> documentRevsInfoAt: id [ 

	self adaptor znClient queryAt:'revs_info' put: 'true'.
	^ self adaptor get: (self arrayWith: self name with: id ).

]

{ #category : #database }
SCDatabase >> documents [
	^ self all.

]

{ #category : #database }
SCDatabase >> ensure [

	self adaptor ensureDatabase: self name
]

{ #category : #index }
SCDatabase >> explain [
	^ SCExplain onDatabase: self 
]

{ #category : #database }
SCDatabase >> getDatabasePath: aPath [

	^ self adaptor get: (self arrayWith: self name with: aPath).

]

{ #category : #documents }
SCDatabase >> hasAttachments: anObject [
	^ ((anObject isKindOf:SCDocument) and:[
	(anObject hasAttachments) ]) 

]

{ #category : #documents }
SCDatabase >> includeDocs [
	"Include the full content of the documents in the return. Default is false"
	self adaptor znClient queryAt: 'include_docs' put: true.
	
]

{ #category : #index }
SCDatabase >> index [
	^ SCIndex onDatabase: self 
]

{ #category : #database }
SCDatabase >> info [
	"retrieve my info from server"
	^ self getDatabasePath:''
]

{ #category : #lists }
SCDatabase >> listAt: app named: nameOfList appliedTo: aView [
	| path |
	path := Array with:'_design' with:app with:'_list' with:nameOfList with:aView.
	^ self plainDocumentAt: path
]

{ #category : #lists }
SCDatabase >> listAt: app named: nameOfList appliedTo: aView inApp:anotherApp [
	| path |
	path := Array with:'_design' with:app with:'_list' with:nameOfList with: anotherApp with:aView.
	^ self plainDocumentAt: path 
]

{ #category : #accessing }
SCDatabase >> mangoQuery [
	^ SCMangoQuery onDatabase: self 
]

{ #category : #serializing }
SCDatabase >> materializer [
	^ materializer ifNil:[materializer := SCMaterializer new]
]

{ #category : #accessing }
SCDatabase >> name [
	^ name
]

{ #category : #accessing }
SCDatabase >> name: aString [
	name := aString
]

{ #category : #documents }
SCDatabase >> plainDocumentAt: id [

	^ self adaptor plainGet: (self arrayWith: self name with: id ).
]

{ #category : #serializing }
SCDatabase >> plainSerializer [
	^ plainSerializer ifNil:[ plainSerializer := SCSerializer new serializeAllCollectionsAsArrays ]
]

{ #category : #database }
SCDatabase >> security [
	^ self getDatabasePath:'_security'
	
]

{ #category : #serializing }
SCDatabase >> serializer [
	^ serializer ifNil:[ serializer := SCSerializer on:self adaptor]
]

{ #category : #shows }
SCDatabase >> showAt: app named: nameOfShow [
	| path |
	path := Array with:'_design' with:app with:'_show' with:nameOfShow.
	^ self plainDocumentAt: path
]

{ #category : #shows }
SCDatabase >> showAt: app named: nameOfShow appliedTo:aDocId [
	| path |
	path := Array with:'_design' with:app with:'_show' with: nameOfShow with:aDocId.
	^ self plainDocumentAt: path
]

{ #category : #updates }
SCDatabase >> updateFunctionAt: app named: updateFunction [
	| path |
	path := Array with:'_design' with:app with:'_update' with: updateFunction. 
	^ self documentAt: path put:Dictionary new forcePost:true.
]

{ #category : #updates }
SCDatabase >> updateFunctionAt: app named: updateFunction for:aDocumentId [
	| path |
	path := Array with:'_design' with:app with:'_update' with: updateFunction with:aDocumentId. 
	^ self documentAt: path put:Dictionary new.
]

{ #category : #updates }
SCDatabase >> updateFunctionAt: app named: updateFunction for:aDocumentId passing:aJsonDoc [
	| path |
	path := Array with:'_design' with:app with:'_update' with: updateFunction with:aDocumentId. 
	^ self documentAt: path put:aJsonDoc.
]

{ #category : #updates }
SCDatabase >> updateFunctionAt: app named: updateFunction passing:aJsonDoc [
	| path |
	path := Array with:'_design' with:app with:'_update' with: updateFunction. 
	^ self documentAt: path put:aJsonDoc forcePost:true.
]

{ #category : #query }
SCDatabase >> updateSeq [
	" Response includes an update_seq value indicating which sequence id of the underlying database the view reflects. Default is false"
	self adaptor znClient queryAt: 'update_seq' put: true.
	
]

{ #category : #accessing }
SCDatabase >> uuidProvider [
	^ self serializer uuidProvider
]

{ #category : #views }
SCDatabase >> viewAt: app named: nameOfView [
	| path result response |

	path := Array with: self name with:'_design' with:app with:'_view' with:nameOfView.

	result := self adaptor get: path.
	
	^  	result at: 'rows'

]
