"
Used to render Shows, and Lists 

    Instance Variables
	chunks:		<Object>
	gotRow:		<Object>
	html:		<Object>
	lastRow:		<Object>
	mime:		<Object>
	serializer:		<Object>
	server:		<Object>
	startResp:		<Object>
	xml:		<Object>


    Implementation Points
"
Class {
	#name : #SCRenderer,
	#superclass : #Object,
	#instVars : [
		'chunks',
		'startResp',
		'mime',
		'lastRow',
		'gotRow',
		'html',
		'xml',
		'server',
		'serializer'
	],
	#category : 'SCouchDB-ViewServer'
}

{ #category : #'as yet unclassified' }
SCRenderer class >> on:aViewServer [
"We need to know the server instance to send print messages"
| a |
super initialize.
a:=self new.
a server:aViewServer.
^a

]

{ #category : #runner }
SCRenderer >> applyContentType:resp mime:responseContentType [

	resp at:'headers' ifAbsentPut:[SCJsonObject new].
	responseContentType ifNotNil:[
		(resp at:'headers') at:'Content-Type' put: responseContentType.
	].
	^ resp
]

{ #category : #runner }
SCRenderer >> blowChunks [
	self blowChunks:nil

]

{ #category : #runner }
SCRenderer >> blowChunks:label [

	label 
		ifNil:[ self respond: (Array with:'chunks' with:chunks)] 
		ifNotNil:[ self respond: (Array with:label asString with:chunks) ].
	chunks isEmpty ifFalse: [chunks pop]

]

{ #category : #runner }
SCRenderer >> doNotReturnAnything [
	^ nil
]

{ #category : #public }
SCRenderer >> getRow [
	| json |
	lastRow ifTrue:[^nil].
	gotRow 
		ifFalse:[
			gotRow:=true.
			self sendStart]
		ifTrue:[	self blowChunks].	
	json:=server readJsonFromCommStream.

	json ifNil:[SCRenderException signal:'Unabled to read a row'].
	^ ((json at:1) = 'list_end')
		ifTrue:[
				lastRow:=true.
				nil]
		ifFalse:[
			((json at:1) = 'list_row') 
				ifFalse:[SCListException signal:'not a row "' , (json at:1) , '"' ]
				ifTrue:[json at:2]]
	
]

{ #category : #accessing }
SCRenderer >> gotRow [
	^ gotRow ifNil:[ gotRow :=false ]
]

{ #category : #accessing }
SCRenderer >> gotRow: anObject [
	gotRow := anObject
]

{ #category : #builders }
SCRenderer >> htmlCanvas [
	|a|
	a:=Smalltalk at:#WAHtmlCanvas ifAbsent:[^nil].
	^ a builder
]

{ #category : #runner }
SCRenderer >> initialize [
	super initialize.
	chunks:=Stack new.
	lastRow:=false.
	gotRow:=false.
	html:=self htmlCanvas.
	xml:=self xmlCanvas.


]

{ #category : #runner }
SCRenderer >> isDocRequestPath:info [
	|path|
	path:=info at:'path'.
	^ (path size >5)

]

{ #category : #public }
SCRenderer >> lastRow [
	^ lastRow
]

{ #category : #accessing }
SCRenderer >> lastRow: anObject [
	lastRow := anObject
]

{ #category : #runner }
SCRenderer >> maybeWrapResponse:resp [

^ (resp isKindOf:String) 
		ifTrue:[ SCJsonObject new
										at:'body' put:resp;
										yourself]
		ifFalse:[ resp]
]

{ #category : #runner }
SCRenderer >> resetList [
	self gotRow:false.
	self lastRow:false.
	chunks :=Stack new.
	startResp:= SCJsonObject new


]

{ #category : #runner }
SCRenderer >> respond:aJsonObj [
	"test function"
	server println:(self serializer  serialize: aJsonObj)
]

{ #category : #runner }
SCRenderer >> runList:fun ddoc:ddoc args:args [
	|tail head req|
	self resetList.
	mime := ddoc mime.
	mime resetProvides.
	head:=args at:1.
	req:=args at:2.
	tail:= fun valueWithEnoughArguments:args.
	(mime providesUsed) ifTrue:[ tail:= ((mime runProvides:(args at:2)) valueWithEnoughArguments:args )].
	self gotRow ifFalse:[self getRow].
	tail ifNotNil:[ ((tail isKindOf:SCApp) or:[(tail isKindOf:SCRenderer)]) ifFalse:[chunks push:tail]].
	self blowChunks:'end'.
	^ self doNotReturnAnything 
]

{ #category : #runner }
SCRenderer >> runShow:fun ddoc:ddoc args:args [
|resp providedResp req b str|
[
	self resetList.
	mime:= ddoc mime.
	mime resetProvides.
	resp:= fun valueWithEnoughArguments:args.

	resp ifNil:[resp:=SCJsonObject new].
	resp:=self maybeWrapResponse:resp.
	
	"handle list style API"
	(chunks size>0)
	ifTrue:[
		(resp at:'headers') ifNotNil:[
			(resp at:'headers') do:[:header|
				(resp at:'headers') at:header put: (startResp at:header) ]]].
	
	(chunks size > 0)
	ifTrue:[	
		b:= (String new join:chunks).
		resp at:'body' put: ( b,(resp at:'body'))]
	ifFalse:[	
		resp at:'body' put: (resp at:'body')].
	self resetList.
	(mime providesUsed) 
	ifTrue:[
		req:=args at:2.
		providedResp:= ((mime runProvides: req) valueWithEnoughArguments:args).
		providedResp ifNil:[providedResp:=SCJsonObject new].
		str := WriteStream on:String new.
		str 
			nextPutAll: (resp at:'body' ifAbsent:'');
			nextPutAll: (String new join:chunks);
			nextPutAll:	(providedResp at:'body' ifAbsent:'').
		resp at:'body' put: str contents.
		resp:= self applyContentType:resp mime: (mime responseContentType).
		self resetList.
		].
	
	((resp isKindOf:String) or:[resp isKindOf: SCJsonObject ]) 
	ifTrue:[
		self respond: (Array with:'resp' with:(self maybeWrapResponse:resp)).
		]
	ifFalse:[
		^ self serializer  serialize:(Array with:'error' with:'render_error' with:'Undefined response from show function').
		]
	] on:Error do:[:err|
		server debug: ('[SCouchDBRender] runShow: ', err asString).
		^ self serializer  serialize:(Array with:'error' with:'render_error' with:err description)]	.
	^nil
	
	
]

{ #category : #runner }
SCRenderer >> runUpdate:fun ddoc:ddoc args:args [
|method result doc resp |
[
	method:=(args at:2) method.
	"for analytics logging applications you might want to remove the next line"
	"(method = 'GET') ifTrue:[^ self serializer serialize: (Array with:'error' with:'method not allowed' with:'Update method do not allow GET')]."
	result := fun valueWithEnoughArguments:args.
	doc := result at:1.
	resp := result at:2.
	
	((resp isKindOf:String) or:[resp isKindOf: SCJsonObject ]) 
	 ifTrue:[
		self respond: (Array 
			with:'up' 
			with:doc 
			with: ( self maybeWrapResponse:resp))
	]
	ifFalse:[
		SCRenderException signal]
	] on:Error do:[:err|
		server debug: ('[SCouchDBRender] runUpdate: ', err asString).
		^ self serializer  serialize:(Array with:'error' with:'render_error' with:err description)
]
]

{ #category : #public }
SCRenderer >> send: chunk [
	"pushes a chunk, it will be sended each time you get a row with getRow or al the end of the List blok execution in #runList"
	chunks push: chunk asString
]

{ #category : #public }
SCRenderer >> sendOnCanvas: aBlock [
	|chunk|
	chunk:= html render:aBlock.
	chunks push: chunk asString
]

{ #category : #runner }
SCRenderer >> sendStart [

	startResp:= self applyContentType: startResp mime: (mime responseContentType).

	self respond:(Array 
		with: 'start'
		with: chunks
		with: startResp).
	chunks:= Stack new.
	startResp:= SCJsonObject new
		
]

{ #category : #'as yet unclassified' }
SCRenderer >> serializer [
	^ serializer ifNil:[ serializer := SCSerializer new serializeAllCollectionsAsArrays ]
]

{ #category : #accessing }
SCRenderer >> server [
	^ server
]

{ #category : #accessing }
SCRenderer >> server: anObject [
	server := anObject
]

{ #category : #runner }
SCRenderer >> start [
	startResp:=SCJsonObject new
]

{ #category : #runner }
SCRenderer >> start: resp [
	startResp:=resp
]

{ #category : #runner }
SCRenderer >> typeOf:value [
	(value isKindOf: Array ) 
				ifTrue:[^'array']
				ifFalse:[^'null'].


]

{ #category : #builders }
SCRenderer >> xmlCanvas [
	|a|
	a:=Smalltalk at:#WAXmlCanvas ifAbsent:[^nil].
	^ a builder
]
