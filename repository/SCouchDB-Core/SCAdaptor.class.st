Class {
	#name : #SCAdaptor,
	#superclass : #Object,
	#instVars : [
		'host',
		'port',
		'resolvedHost',
		'httpResponseClass',
		'user',
		'password',
		'cookieAuthentication',
		'showProgress',
		'client',
		'uuidsPile',
		'serializer',
		'materializer'
	],
	#classInstVars : [
		'authStrings',
		'defaultAdaptor',
		'defaultDatabase',
		'testAdaptor'
	],
	#category : 'SCouchDB-Core'
}

{ #category : #'as yet unclassified' }
SCAdaptor class >> defaultAdaptor [
	^ defaultAdaptor ifNil:[ SCError signal:'No adaptor in singleton mode']
]

{ #category : #'as yet unclassified' }
SCAdaptor class >> defaultAdaptor: anAdaptor [
	defaultAdaptor := anAdaptor
]

{ #category : #'as yet unclassified' }
SCAdaptor class >> maxUUIDsInMemory [
	^ 100
]

{ #category : #'as yet unclassified' }
SCAdaptor class >> testAdaptor [
	^ testAdaptor ifNil:[ testAdaptor := self new. testAdaptor host:testAdaptor defaultHost ]
]

{ #category : #'server-level' }
SCAdaptor >> activeTasks [

	^ self get: '_active_tasks'
]

{ #category : #authentication }
SCAdaptor >> authenticatedRequest [
	^ ((user notNil) and:[ password notNil])
]

{ #category : #private }
SCAdaptor >> buildAuthString [

^	'name=', self user,
	'&password=', self password.
		

]

{ #category : #'server-config' }
SCAdaptor >> config [

	^ self get: '_config'
]

{ #category : #'http api' }
SCAdaptor >> copy: path to:aDest [


	| response result |
	response:=	self znClient
							addPath:path;
							method:#COPY;
							headerAt:'Destination' put:aDest;
							execute;
							response.
	result := 	self materializer materialize: response contents.
	^ self znClient isSuccess 
						ifTrue:[result]
						ifFalse: [ self couchDBError:result ]
						
	
]

{ #category : #'error handling' }
SCAdaptor >> couchDBError: jobject [ 
	^ SCError new 
		object:jobject;
		signal: 
		'Error: ', (jobject at: 'error') , ' reason: ', (jobject at: 'reason')
]

{ #category : #'db api' }
SCAdaptor >> createDatabase: aName [

	aName do: [ :c | ('abcdefghijklmnopqrstuvwxyz0123456789_$()+-/`' includes: c)  
		ifFalse: [ ^ self error: 'Invalid database name' ]].

 	self put:aName.
	^ self database name: aName	
	
]

{ #category : #'db api' }
SCAdaptor >> database [
	"Answer a new instance of couch database wrapper"
	^ SCDatabase new adaptor: self
]

{ #category : #'server-level' }
SCAdaptor >> databases [

	^ self get: '_all_dbs'.
	

]

{ #category : #'server-level' }
SCAdaptor >> databasesUpdates [

	"@to-do it doesnt work... "
	^ self get: '_db_updates'.
	

]

{ #category : #accessing }
SCAdaptor >> defaultHost [
	^ 	'localhost'
]

{ #category : #accessing }
SCAdaptor >> defaultPort [
	^ 	5984
]

{ #category : #'http api' }
SCAdaptor >> delete: path [ 
	
	| response result |
	
	self resetZnClientPath.
	response := self znClient
							addPath:path;
							method:#DELETE;
							execute;
							response.
	self resetZnClientUrl.
	
	result := 	self materializer materialize: response contents.
	^ self znClient isSuccess 
						ifTrue:[result]
						ifFalse: [ self couchDBError:result ]		
	
	
]

{ #category : #'db api' }
SCAdaptor >> deleteDatabase: aName [

	^ self delete:aName.



]

{ #category : #'db api' }
SCAdaptor >> ensureDatabase: aName [
	"Either create new or answer an existing database."

	^ (self hasDatabase: aName) 
			ifFalse: [ self createDatabase: aName ]
			ifTrue:[ self database name: aName ]
]

{ #category : #'http api' }
SCAdaptor >> get: path [ 
	| response result |
	
	self resetZnClientPath.
	response:= self znClient
							addPath:path;
							get;
							response.	
	self resetZnClientUrl.											
	result := self materializer materialize: response contents.
	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self  couchDBError: result ]
	
]

{ #category : #'db api' }
SCAdaptor >> hasDatabase: aName [
	
	^self databases includes: aName
]

{ #category : #'http api' }
SCAdaptor >> head: path [ 
	self resetZnClientPath.
	self znClient 
		host:self host;
		port: self port; 
		addPath:path;
		head.
	self resetZnClientUrl.
	^ self znClient response			
	
	
]

{ #category : #accessing }
SCAdaptor >> host [
	^ host
]

{ #category : #accessing }
SCAdaptor >> host: aHost [
	^ self host: aHost port: self defaultPort
]

{ #category : #authentication }
SCAdaptor >> host: aHost port: aPort [
	host := aHost.
	port := aPort.
	resolvedHost := nil.
]

{ #category : #authentication }
SCAdaptor >> host: aHost port: aPort userName:aUserName password:aPassword [

	self host:aHost port:aPort.
	self user:aUserName.
	self password: aPassword.
	resolvedHost := nil.
	
	self session
]

{ #category : #'server-level' }
SCAdaptor >> info [

	^ self get: ''
]

{ #category : #initialization }
SCAdaptor >> initialize [ 
	
	showProgress:=false
]

{ #category : #'server-config' }
SCAdaptor >> log [

	^ self get: '_log'
]

{ #category : #authentication }
SCAdaptor >> logout [
	"read a single resposnse for deletion of document"
	^ self delete: '_session'.
	
]

{ #category : #serialization }
SCAdaptor >> materializer [
	^ materializer ifNil:[materializer := SCMaterializer new]
]

{ #category : #'server-config' }
SCAdaptor >> membership [

	^ self get: '_membership'
]

{ #category : #accessing }
SCAdaptor >> newUUID [
	^ (self uuids at: 'uuids') at: 1
]

{ #category : #accessing }
SCAdaptor >> newUUIDs: aNumber [
	^ (self uuids: aNumber) at: 'uuids'
]

{ #category : #'server-level' }
SCAdaptor >> nextUUID [
	| uuid |
	[uuid := self uuidsPile pop] 
	on:CollectionIsEmpty 
	do:[
		( self newUUIDs: (self class maxUUIDsInMemory + 1)) do:[:each| self uuidsPile push:each].
		uuid := self uuidsPile pop].
	
	^ uuid
]

{ #category : #authentication }
SCAdaptor >> password [
	^ password
]

{ #category : #authentication }
SCAdaptor >> password: anObject [
	password := anObject
]

{ #category : #'http api' }
SCAdaptor >> plainGet: path [ 
	| response |
	
	self resetZnClientPath.
	response:= self znClient
							addPath:path;
							get;
							response.	
	self resetZnClientUrl.											

	^ response isSuccess 
						ifTrue: [ response contents ]
						ifFalse: [ self  couchDBError: response contents]
	
]

{ #category : #accessing }
SCAdaptor >> port [
	^ 	port
]

{ #category : #'http api' }
SCAdaptor >> post: path [ 
	^ self post: path content:nil type: nil
]

{ #category : #'http api' }
SCAdaptor >> post: path content: aContent [
	^ self post: path content:aContent type: ZnMimeType applicationJson 
]

{ #category : #'http api' }
SCAdaptor >> post: path content: aContent type:aContentType [
	| response result |
	self  resetZnClientPath.
	self znClient addPath:path.
	aContent ifNotNil:[	
			self znClient 
					entity: (ZnEntity 
						readFrom: aContent readStream
						usingType: aContentType 
						andLength: aContent size)].
	response := self znClient post;response.
	self  resetZnClientUrl.
	result := self materializer readFromString: response contents.

	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	
]

{ #category : #'http api' }
SCAdaptor >> post: path entity: anEntity [
	| response result |
	self  resetZnClientPath.
	response:= self znClient 
						addPath:path;
						entity: anEntity;
						post;
						response.
	self  resetZnClientUrl.

	result := self materializer materialize: response contents.	
	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	
]

{ #category : #'http api' }
SCAdaptor >> put: path [ 
	^ self put: path content:nil type: nil
]

{ #category : #'http api' }
SCAdaptor >> put: path content: aContent [
	^ self put: path content:aContent type: ZnMimeType applicationJson 
]

{ #category : #'http api' }
SCAdaptor >> put: path content: aContent type:aContentType [
	| response result |
	self  resetZnClientPath.
	self znClient addPath:path.
	aContent ifNotNil:[	
			self znClient 
					entity: (ZnEntity 
						readFrom: aContent readStream
						usingType: aContentType 
						andLength: aContent size)].
	response := self znClient put;response.
	self  resetZnClientUrl.
	result := self materializer readFromString: response contents.

	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	
]

{ #category : #'http api' }
SCAdaptor >> put: path entity: anEntity [
	| response result |
	self  resetZnClientPath.
	response:= self znClient 
						addPath:path;
						entity: anEntity;
						put;
						response.
	self  resetZnClientUrl.

	result := self materializer materialize: response contents.	
	^ response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	
]

{ #category : #private }
SCAdaptor >> readETagFrom: response [	
	| result |
	 ('*application/json*' match: response contentType) ifFalse: [
		self error: 'response is not json'.
		].
	
	result := self materializer materializeFromStream: response readStream.
	^ result
]

{ #category : #'server-config' }
SCAdaptor >> replicate [

	^ self post: '_replicate'
]

{ #category : #'http api' }
SCAdaptor >> resetZnClientPath [
	|url|
	url := self znClient request url.
	self znClient url: ''.
	url hasQuery ifTrue:[self znClient request url queryAddAll: url query]

]

{ #category : #'http api' }
SCAdaptor >> resetZnClientUrl [	
	self znClient url: ''.


]

{ #category : #private }
SCAdaptor >> resolvedHost [ 

	^ resolvedHost ifNil: [
		resolvedHost := (NetNameResolver addressForName: self host) ]
]

{ #category : #'server-config' }
SCAdaptor >> restart [

	^ self post: '_restart'
]

{ #category : #serialization }
SCAdaptor >> serializer [
	"Serializer uses the adaptor to obtain the UUID"
	^ serializer ifNil:[serializer := SCSerializer on:self]
]

{ #category : #authentication }
SCAdaptor >> session [

	| contents result |

	contents:= self 
						post: '_session' 
						content: self buildAuthString 
						type:ZnMimeType applicationFormUrlEncoded.
		

	result := self materializer readFromString:  contents.
	self znClient response isSuccess 
						ifTrue: [ result ]
						ifFalse: [ self couchDBError: result ]
	
]

{ #category : #authentication }
SCAdaptor >> sessionInfo [

	^ self get: '_session'.

	
	 
	

]

{ #category : #'server-level' }
SCAdaptor >> statistics [
	self deprecated: 'Statistics depend on node API'.

	^ self get: '_stats'
]

{ #category : #'server-level' }
SCAdaptor >> statistics:node [
	
	^ self get: (Array with:'_node' with:node with: '_stats')
]

{ #category : #authentication }
SCAdaptor >> user [
	^ user
]

{ #category : #authentication }
SCAdaptor >> user: anObject [
	user := anObject
]

{ #category : #authentication }
SCAdaptor >> users [
	
	^ self get: '_users'.

]

{ #category : #'server-level' }
SCAdaptor >> uuids [

	^ self get: '_uuids'
]

{ #category : #'server-level' }
SCAdaptor >> uuids: aNumber [

	self znClient
				host:self host;
				port: self port; 
				queryAt:'count' put: aNumber asString.
	^ self get:'_uuids'.	
	

	
]

{ #category : #private }
SCAdaptor >> uuidsPile [
	^ uuidsPile ifNil:[
			uuidsPile:= Stack new.
			self uuids: self class maxUUIDsInMemory. 
			uuidsPile
			]
]

{ #category : #'http api' }
SCAdaptor >> znClient [
	^ client ifNil:[
			SCAdaptor defaultAdaptor: self.
			client := (ZnClient new 		
											autoResetEntityMethods: #(HEAD DELETE GET);
											host:self host;
											port: self port)]

]
