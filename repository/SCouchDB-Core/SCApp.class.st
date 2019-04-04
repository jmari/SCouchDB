Class {
	#name : #SCApp,
	#superclass : #SCAppContext,
	#instVars : [
		'database',
		'appName',
		'adaptor'
	],
	#category : 'SCouchDB-Core-Application'
}

{ #category : #deprecated }
SCApp >> addEvently:evently [
	self  deprecated: 'evently is no longer supported'. 
	self at:'evently' put:evently
]

{ #category : #accessing }
SCApp >> appName [

	^ appName ifNil:[
			self at:'_id' 
		  		ifPresent:[ appName :=  ((self at:'_id') findTokens: $/) at:2]
		  		ifAbsent:[ appName := self className asLowercase ]]
	
]

{ #category : #accessing }
SCApp >> appName: anObject [
	appName := anObject.
	self at:'_id' put: '_design/' , self appName .
]

{ #category : #initialization }
SCApp >> connectTo:aHost port:aPort userName:aUserName password:aPassword [

	adaptor:=SCAdaptor new host: aHost port: aPort userName:aUserName password:aPassword



	
]

{ #category : #accessing }
SCApp >> database [
	^ database 
]

{ #category : #accessing }
SCApp >> database: anObject [
	database := anObject
]

{ #category : #deprecated }
SCApp >> evently [
	self  deprecated: 'evently is no longer supported'. 
	^ self at:'evently' ifAbsentPut:[SCEvently new]
]

{ #category : #filters }
SCApp >> filterAt:name put:aFilter [

	self filters at:name put: aFilter .
]

{ #category : #accessing }
SCApp >> filters [
	^ self at:'filters' ifAbsentPut:[SCJsonObject new]
]

{ #category : #accessing }
SCApp >> id [
	^ Array with:'_design' with: self appName 
]

{ #category : #deprecated }
SCApp >> importEventlyFilesFrom:aFolderPath [ 
	self  deprecated: 'evently is no longer supported'. 
	self importVendorFilesFrom:aFolderPath relPath:'' stack: self evently
]

{ #category : #private }
SCApp >> importEventlyFilesFrom:aFolderPath relPath:relPath stack:currentJsonObject [
	| dir elements fileName aStream content |
	dir:= (aFolderPath , relPath) asFileReference.
	elements :=dir entries.
	elements do:[:entry|
	entry isDirectory 
		ifTrue:[
			currentJsonObject at: entry name put: SCJsonObject new.
			self 	importEventlyFilesFrom:aFolderPath 
					relPath:(relPath , DiskStore activeClass delimiter asString, entry name)
					stack:(currentJsonObject at: entry name)]
		ifFalse:[
			aStream := entry readStream.	
			content := [self materializer materializeFromStream: aStream]
							on:Exception 
							do:[nil].
			content ifNotNil:[
				fileName := entry name copyFrom:1 to:((entry name indexOf:$.) - 1).
				currentJsonObject at: fileName put: content]
		]
	]
]

{ #category : #import }
SCApp >> importTemplatesFrom:aFolderPath [ 
	self importTemplatesFrom: aFolderPath relPath: '' 
]

{ #category : #private }
SCApp >> importTemplatesFrom:aFolderPath relPath:relPath [
	| dir elements attchPath fileName aStream |

	dir:= (aFolderPath , relPath) asFileReference.
	elements :=dir entries.
	elements do:[:entry|
		entry isDirectory 
		ifTrue:[
			(relPath='') 
				ifTrue:[	self importTemplatesFrom:aFolderPath relPath:(entry name)]
				ifFalse:[	self importTemplatesFrom:aFolderPath relPath:(relPath , DiskStore activeClass delimiter asString, entry name)]]
		ifFalse:[
			fileName:= entry name copyFrom:1 to:((entry name indexOf:$.) - 1). 
			(relPath='') 
				ifFalse:[
					attchPath:=(relPath , DiskStore activeClass delimiter asString, fileName).
					attchPath:= attchPath copyReplaceAll: '\' with: '/'.
					aStream :=  entry readStream.	
					self partials at: attchPath put: (aStream contents)]
				ifTrue:[
					attchPath:= fileName.
					aStream := entry readStream.	
					[self templates at: attchPath put: (aStream contents)] on:Error do:[Transcript show:entry name ,' is not a valid utf8 stream']]
		]
	]
]

{ #category : #import }
SCApp >> importVendorFilesFrom:aFolderPath [ 
	self importVendorFilesFrom:aFolderPath relPath:'' stack: self vendor
]

{ #category : #private }
SCApp >> importVendorFilesFrom:aFolderPath relPath:relPath stack:currentJsonObject [
	| dir elements  aStream  |

	dir:= (aFolderPath , relPath) asFileReference.
	elements :=dir entries.
	elements do:[:entry|
	entry isDirectory 
		ifTrue:[
			(entry name = '_attachments') 
			ifTrue:[
				self importAttachmentsFrom: (aFolderPath , relPath ,DiskStore activeClass delimiter asString, entry name , DiskStore activeClass delimiter asString) relPath:'' prefix: (('vendor',relPath,'/' ) copyReplaceAll: '\' with: '/').
			]
			ifFalse:[
				(entry name = 'evently') 
					ifTrue:[
						self importEventlyFilesFrom: (aFolderPath , relPath ,DiskStore activeClass delimiter asString, entry name , DiskStore activeClass delimiter asString) relPath:'' stack: (currentJsonObject at: entry name put: SCJsonObject new)]
					ifFalse:[
						currentJsonObject at: entry name put: SCJsonObject new.
						self importVendorFilesFrom:aFolderPath 
							relPath:(relPath , DiskStore activeClass delimiter asString, entry name)
							stack:(currentJsonObject at: entry name).]]]
		ifFalse:[
			aStream :=  entry readStream.	
			[currentJsonObject at: entry name put: aStream contents] on:Error do:[Transcript show:entry name ,' is not a valid utf8 stream']
		]
	]
]

{ #category : #initialization }
SCApp >> initialize:size [
	super initialize:size.
	self language:'smalltalk'.
	self at:'_id' ifAbsentPut:[ '_design/' , self className asLowercase  ].
	self initialize

]

{ #category : #accessing }
SCApp >> language [
	^self at:'language'
]

{ #category : #accessing }
SCApp >> language: anObject [
	self at:'language' put: anObject
]

{ #category : #accessing }
SCApp >> lib [
	^ self at:'lib' ifAbsentPut:[ SCJsonObject new]
]

{ #category : #accessing }
SCApp >> lib: anObject [
	self at:'lib' put: anObject
]

{ #category : #lists }
SCApp >> list [
	^ SCList new 
			app:self;
			database: self database
			
]

{ #category : #lists }
SCApp >> listAt: aList [ 
	^ self lists at: aList 
]

{ #category : #lists }
SCApp >> listAt:name put:aList [
	self lists at:name put: aList .
]

{ #category : #accessing }
SCApp >> lists [
	^ self at:'lists' ifAbsentPut:[SCJsonObject new]
]

{ #category : #deprecated }
SCApp >> mergeEventlyNode:evently [
	self  deprecated: 'evently is no longer supported'. 
	self evently addAll: evently
]

{ #category : #nodes }
SCApp >> mustacheAt: templateName put: aTemplateInAString partials: dictionaryOfPartials [
	"imports a Mustache  template "

	self templates at: templateName put: aTemplateInAString.
	self partials addAll: dictionaryOfPartials.

]

{ #category : #accessing }
SCApp >> partials [
	| templates |
	templates:= self at:'templates' ifAbsentPut:[SCJsonObject new].
	^ templates at:'partials' ifAbsentPut:[SCJsonObject new]
]

{ #category : #accessing }
SCApp >> path [
 ^ self at:'_id' ifAbsentPut:[ Array with:'_design' with: self appName  ]
]

{ #category : #filters }
SCApp >> removeFilter:aFilter [

	self filters removeKey:aFilter.
]

{ #category : #lists }
SCApp >> removeList:aList [

	self lists removeKey:aList.
]

{ #category : #shows }
SCApp >> removeShow:aShow [
	self shows removeKey:aShow
]

{ #category : #nodes }
SCApp >> removeSignature:aSignature [
	self signatures removeKey:aSignature
]

{ #category : #updateHandlers }
SCApp >> removeUpdateFunction:anUpdater [

	self updates removeKey:anUpdater.
]

{ #category : #views }
SCApp >> removeView:aView [
	self views removeKey:aView.
]

{ #category : #shows }
SCApp >> show [
	^ SCShow new 
			app:self;
			database: self database
			
]

{ #category : #shows }
SCApp >> showAt: aShow [ 
	^ self shows at: aShow 
]

{ #category : #shows }
SCApp >> showAt:name put:aShow [

	self shows at:name put: aShow.
]

{ #category : #private }
SCApp >> shows [
	"shows node for CouchDB show functions"
	^ self at:'shows' ifAbsentPut:[SCJsonObject new]
]

{ #category : #nodes }
SCApp >> signatureAt:name put:aSignature [
	self signatures at:name put:aSignature.
]

{ #category : #accessing }
SCApp >> signatures [
^ self at:'signatures' ifAbsentPut:[SCJsonObject new]
]

{ #category : #accessing }
SCApp >> templates [
"updates node for Mustache Templates"
^ self at:'templates' ifAbsentPut:[SCJsonObject new]
]

{ #category : #updateHandlers }
SCApp >> updateHandlerAt:name put:anUpdater [

	self updates at:name put: anUpdater.
]

{ #category : #accessing }
SCApp >> updates [
	"updates node for CouchDB update functions"
	^ self at:'updates' ifAbsentPut: [SCJsonObject new].

]

{ #category : #initialization }
SCApp >> upload [
	|db|
	"Upload the application and put the compiled block inside the application cache"
	adaptor ifNil:[SCError signal:'No adaptor. Send connect before upload'].

	(self language = 'smalltalk') ifTrue:[
		"include the app in the CouchViewServer cache (only for smalltalk language)"
		SCViewServer servers do:[:aServer| 
			(aServer designDocs at: (self at:'_id'))  ifNotNil:[
				(aServer designDocs at:(self at:'_id')) 
					indexers do:[:anIndexer|anIndexer stop]].
			"aServer designDocs at:('/_design/', self appName) put:self "]
		].	
	db:=adaptor ensureDatabase: self appName.
	db documentPut:self.	
	self database:db
]

{ #category : #accessing }
SCApp >> validateDocUpdate [
	^ self at:'validate_doc_update' ifAbsentPut:['[]']
]

{ #category : #accessing }
SCApp >> validateDocUpdate: anObject [
	self at:'validate_doc_update' put: anObject 
]

{ #category : #accessing }
SCApp >> vendor [
	^ self at:'vendor' ifAbsentPut:[SCJsonObject new]
]

{ #category : #views }
SCApp >> view [
	^ SCView new 
			app:self;
			database: self database
			
]

{ #category : #views }
SCApp >> viewAt: aViewName [
	^ self views at: aViewName
]

{ #category : #views }
SCApp >> viewAt:name put:aView [

	self viewAt:name put:aView  reduce:nil
]

{ #category : #views }
SCApp >> viewAt:name put:aView reduce:aReduceFunction [
	|v aViewCode aReduceCode|

	v:=SCJsonObject new.
	aViewCode:= (aView isKindOf: BlockClosure) 
						ifTrue:[aView]
						ifFalse:[aView asString ].

	v map:(aViewCode).

	aReduceCode:= (aReduceFunction isKindOf: BlockClosure) 
						ifTrue:[aReduceFunction]
						ifFalse:[aReduceFunction asString ].
	aReduceFunction ifNotNil:[v at:'reduce' put:(aReduceCode)].
	self views at:name put:v.

]

{ #category : #accessing }
SCApp >> views [
^ self at:'views' ifAbsentPut:[SCJsonObject new]
]
