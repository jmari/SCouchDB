Class {
	#name : #SCViewServer,
	#superclass : #Object,
	#instVars : [
		'lib',
		'exit',
		'debug',
		'session',
		'port',
		'ip',
		'aServer',
		'socket',
		'funs',
		'runner',
		'designDocs',
		'lastPrinted',
		'commStream',
		'materializer',
		'serializer'
	],
	#classInstVars : [
		'servers',
		'debug'
	],
	#category : 'SCouchDB-ViewServer'
}

{ #category : #accessing }
SCViewServer class >> debug [
	^ debug ifNil:[debug:=false]
]

{ #category : #accessing }
SCViewServer class >> debug: anObject [
	debug := anObject
]

{ #category : #debug }
SCViewServer class >> debugOff [
	debug:= false.
	servers keys do:[:aPort|
		(servers at:aPort ) debugOff.
		]
]

{ #category : #debug }
SCViewServer class >> debugOn [
	debug := true.
	servers keys do:[:aPort|
		(servers at:aPort ) debugOn.
		]
 
]

{ #category : #'instance creation' }
SCViewServer class >> handledId [
	^ self class asString
	


]

{ #category : #accessing }
SCViewServer class >> servers [
	^servers 
]

{ #category : #'instance creation' }
SCViewServer class >> start [
	^ self startOn:8181
 
	


]

{ #category : #'instance creation' }
SCViewServer class >> start: anIPAdress on:aPort [
	|aServer|
	servers ifNil:[servers:= Dictionary new].
	aServer:=SCViewServer new.
	aServer listenerAddress: anIPAdress.
	aServer startOn:aPort.
	^ servers at:aPort put:aServer
 
	


]

{ #category : #'instance creation' }
SCViewServer class >> startOn:aPort [
	|aServer|
	servers ifNil:[servers:= Dictionary new].
	aServer:=SCViewServer new.
	(aPort = #stdio) 
		ifTrue:[aServer startOnStandardIO ]
		ifFalse:[
			aServer startOn:aPort.
			servers at:aPort put:aServer].
	^ aServer


]

{ #category : #'instance creation' }
SCViewServer class >> stop [
	self stop:8181
 	
	


]

{ #category : #'instance creation' }
SCViewServer class >> stop:aPort [
	| s |
	s:=servers at:aPort ifAbsent:[^ nil].
	s stop.
	servers removeKey: aPort
 	
	


]

{ #category : #'instance creation' }
SCViewServer class >> stopAll [
	servers keys do:[:aPort|
		(servers at:aPort ) stop.
		servers removeKey: aPort
		]
 
	


]

{ #category : #accessing }
SCViewServer >> aServer [
	^ aServer
]

{ #category : #accessing }
SCViewServer >> aServer: anObject [
	aServer := anObject
]

{ #category : #accessing }
SCViewServer >> commStream [
	^ commStream
]

{ #category : #accessing }
SCViewServer >> commStream: anObject [
	commStream := anObject.
	
]

{ #category : #views }
SCViewServer >> compileMapFunction: aMethodSource [ 
	[
		funs ifNil:[ funs:=OrderedCollection new].
		funs add: (self runner compiledFunctions at: aMethodSource hash ifAbsentPut:[	
				Compiler evaluate:aMethodSource for: self runner logged:false ]).
		^'true'] 
		on: SyntaxErrorNotification , Error do:
		[:err| SCSyntaxException signal:  
			(err description ,'::', err messageText ,' on function:',aMethodSource)]
]

{ #category : #'design-docs' }
SCViewServer >> ddoc: jArg [ 
	| cmd ddocId funPath funArgs ddoc fun validateDocUpdate |

	cmd := jArg at: 2.
	cmd = 'new'
		ifTrue: [ddocId := jArg at: 3.
			self designDocs 
						at: ddocId
						put:(SCApp fromDictionary: (jArg at: 4) on:self).
			^ #true].
	"cmd is 'new' or docId"
	ddocId := cmd.
	ddoc := self designDocs 
						at: ddocId
						ifAbsent:[SCDdocNotFoundException 
										signal:'uncached design doc:' , ddocId asString].
	funPath := jArg at: 3.
	cmd := funPath at: 1.
	funArgs := jArg at: 4.
	validateDocUpdate:= (cmd ='validate_doc_update').
	
	fun := ddoc at: cmd ifAbsent:[SCMissingFunction signal: 'missing: ',cmd,' on Design doc' , ddocId].
	fun :=validateDocUpdate  
						ifTrue:[ ddoc at: (funPath at: 1)]
						ifFalse:[ fun at: (funPath at: 2)].
	^ self
		ddocCommand: cmd
		function: fun
		dDoc: ddoc
		fwithArguments: funArgs	
		funcName: (validateDocUpdate  
						ifTrue:[ cmd ]
						ifFalse:[funPath 
										at: 2 
										ifAbsent:[ SCMissingFunction 
														signal: 
															'missing: ',
															(funPath at: 2),
															' on Design doc',ddocId]]).
]

{ #category : #'design-docs' }
SCViewServer >> ddocCommand: cmd function: fun dDoc: ddoc fwithArguments: funArgs funcName: funcName [
| function|
"commands:= #('lists' 'shows' 'filters' 'views' 'updates' 'validate_doc_update')."

(cmd='lists') 
ifTrue:[
			function:= self evaluate:fun for:ddoc logged:false.
			ddoc listAt:funcName put:function.
			^ddoc renderer runList:function ddoc:ddoc args:funArgs].


(cmd='shows') 
ifTrue:[
			function:= self evaluate:fun for:ddoc  logged:false.
			ddoc showAt:funcName put:function.
			^ddoc renderer runShow:function ddoc:ddoc args:funArgs	].
			
(cmd='updates') 
ifTrue:[
			function:= self evaluate:fun for:ddoc logged:false.
			ddoc updateHandlerAt:funcName put:function.
			^ddoc renderer runUpdate:function ddoc:ddoc args:funArgs ].

(cmd='filters') 
ifTrue:[
			function:= self evaluate:fun for:ddoc logged:false.
			ddoc filterAt:funcName put:function.
			^ddoc filter runFilter:function ddoc:ddoc args:funArgs ].

(cmd='views') 
ifTrue:[
			function:= self evaluate:fun for:ddoc logged:false.
			ddoc viewAt:funcName put:function.
			^ddoc filter runFilterView:function ddoc:ddoc args:funArgs
	].

(cmd='validate_doc_update') 
ifTrue:[
			function:= self evaluate:fun for:(ddoc validator) logged:false.
			ddoc validateDocUpdate:function.
			ddoc validator args:funArgs.
			^ddoc validator runValidate:function ddoc:ddoc args:funArgs	]
]

{ #category : #'out-subsystem' }
SCViewServer >> debug:aMessage [
|aStream m fr |
	debug ifFalse: [^self].
	m:= '[', DateAndTime now asString,']' ,  (aMessage "truncateTo:256").
	fr := ( FileLocator home / (Date today yyyymmdd ,'ViewServer-debug.txt')) ensureCreateFile.
 	aStream := fr writeStream.
	aStream ifNil:[Transcript show:('Unable to write debug info, check for permissions' ). ^self].
	aStream setToEnd.
	aStream nextPutAll:DateAndTime current asString
		;nextPut:$-
		;nextPutAll:m
		;nextPutAll:String crlf.
	aStream flush.
	aStream close.
	Transcript show:m , String cr

	


]

{ #category : #debug }
SCViewServer >> debugOff [
	debug:=false.
]

{ #category : #debug }
SCViewServer >> debugOn [
	debug:=true.
]

{ #category : #accessing }
SCViewServer >> designDocs [
	^ designDocs ifNil: [designDocs := SCDesignDocsCache new].

]

{ #category : #compile }
SCViewServer >> evaluate:fun for:contextInstance logged:logged [

	(fun isKindOf:BlockClosure) ifTrue:[^fun].
	^ Compiler evaluate:fun for: contextInstance logged: logged
	


]

{ #category : #private }
SCViewServer >> exit [
	^ exit
]

{ #category : #private }
SCViewServer >> exit:aBoolean [
	exit:=aBoolean
]

{ #category : #fts }
SCViewServer >> ftsCommand:aJsonRequestObject [
	| ddoc indexer searchString response|
	"full text search needs an OIndexer"
	response:= SCJsonObject new.
	[ddoc:= self designDocs at:('_design/' , (aJsonRequestObject path at:3)).
	indexer:=ddoc indexerAt:(aJsonRequestObject path at:4).
	searchString:= aJsonRequestObject path at:5.
	] on: Exception do:[
		response code:510.
		self println:( self serializer  serialize:response).
		^self].
	response code:200.
	response json: (indexer findPhrase:searchString).
	self println:( self serializer  serialize:response)

]

{ #category : #'error handling' }
SCViewServer >> handleAnyError: e [
	| response |
	
	response := (self serializer serialize: 
												(Array 
													with:'error' 
													with: e signaler asString
													with: e description )).
	self debug: response.


	
]

{ #category : #'error handling' }
SCViewServer >> handleException: e [
	| response |
	
	response := (self serializer serialize: 
												(Array 
													with:'error' 
													with: e errorType 
													with: e description )).
	self debug: response.
	self println: response

	
]

{ #category : #'error handling' }
SCViewServer >> handleFatalError: e [

	self handleException:e.	
	"we tell the client it was a fatal error by clossing the connection"
	self commStream close
]

{ #category : #'as yet unclassified' }
SCViewServer >> help [
	^'/usr/local/bin/socat - TCP:127.0.0.1:8181
	/Applications/stviewserver.app/Contents/MacOS/Pharo --headless /Applications/stviewserver.app/Contents/Resources/Pharo5.0.image viewserver
'
]

{ #category : #initialize }
SCViewServer >> initialize [
	super initialize.
	debug:=false
]

{ #category : #accessing }
SCViewServer >> lastPrinted [
	^ lastPrinted
]

{ #category : #accessing }
SCViewServer >> lastPrinted: anObject [
	lastPrinted := anObject
]

{ #category : #accessing }
SCViewServer >> listenerAddress [
	ip
	ifNil:[ 	^#[0 0 0 0]]
	ifNotNil:[ 	^ip]	
	
]

{ #category : #accessing }
SCViewServer >> listenerAddress: address [
	ip:=address
	
]

{ #category : #'out-subsystem' }
SCViewServer >> log:aMessage [

	self println:( self serializer  serialize:(Array with:'log' with:aMessage)).
 
	


]

{ #category : #parsing }
SCViewServer >> mainLoop:jsonArray [
	|command argument finalArray keyArray valArray tmpArray tmp2Array reduceFunctions |

	(jsonArray isKindOf:Array) 
		ifFalse:[
			(jsonArray path at:2) = '_fts' ifTrue:[	self ftsCommand:jsonArray].
			^nil].

	command:= jsonArray at:1.
	(command='ddoc')  ifTrue:[ ^ self ddoc:jsonArray].
	(command='reset') ifTrue:[ ^ self reset ].
	(command='map_doc') 
		ifTrue:[		
			2 to:(jsonArray size ) do:[:arg|
				finalArray := self mapDoc:(jsonArray at:arg)].			
			^ self serializer serialize:finalArray].

	(command='add_fun') 
		ifTrue:[
			argument:=jsonArray at:2.
			^ self compileMapFunction: (argument trimSpaces)].

	((command='reduce') or:[command='rereduce']) 
		ifTrue:[	
			reduceFunctions:=jsonArray at:2.
			keyArray:=OrderedCollection new.
			valArray:=OrderedCollection new.
			finalArray:=OrderedCollection new.
			tmpArray:=(jsonArray at:3).	
			tmpArray do:[:aKeyDoc|
				tmp2Array:=aKeyDoc.
				(command='reduce') 
					ifTrue:[
						keyArray add:(tmp2Array at:1).
						valArray add:(tmp2Array at:2)]
					ifFalse:[ 	valArray add:aKeyDoc ]].
					
			(command='reduce') ifTrue:[self log:keyArray asString].
		
			reduceFunctions do:[:arFunc|
				finalArray add: (self reduce:arFunc  
												keys:keyArray 
												values:valArray 
												rereduce:(command='rereduce'))].

			^ self serializer serialize:(Array with:true with: finalArray).
		].
	^ nil
]

{ #category : #views }
SCViewServer >> mapDoc: aDoc [
	|resultArray|
	funs ifNil: [^ nil].
	resultArray:= OrderedCollection new.
	funs do:[:aBlock|
		[	aBlock value:aDoc.
			"the method fills the buffer doing emit..."
			resultArray add: self runner mapDoc.
		] on:Error do:[:err| 
			err resignalAs:(SCRuntimeException new messageText:  (err signaler asString, '::',err messageText ))].
	].
	^ resultArray
]

{ #category : #views }
SCViewServer >> mapFunctions [
	^funs
]

{ #category : #serialization }
SCViewServer >> materializer [
	^ materializer ifNil:[ materializer := SCMaterializer new defaultMapClass: SCDocument]
]

{ #category : #accessing }
SCViewServer >> port [
	^ port
]

{ #category : #accessing }
SCViewServer >> port: anObject [
	port := anObject
]

{ #category : #'out-subsystem' }
SCViewServer >> println:aMessage [	

	self debug:'[ViewServer]-Response: ',aMessage.
	"----just for testing package"
	self lastPrinted:aMessage.
	"-----"

	self session ifNotNil:[
		(self port = #stdio ) 
			ifTrue:[self session 
									nextPutAll: aMessage;
									lf]
			ifFalse:[
				self session 
						sendCommand: aMessage.].
	]
	

]

{ #category : #testing }
SCViewServer >> readFrom: aString [
	^ self materializer materialize: aString
]

{ #category : #'input-subsystem' }
SCViewServer >> readFromStreamAndWriteABuffer: aStream [	
	|  aBuffer  char |
	"can not read the stdin stream directly..."

	aBuffer := ReadWriteStream on:String new.	
	[char :=aStream next.
	[ (char = Character lf)  | (char = Character cr) ] whileFalse: [
		aBuffer nextPut:char.
      char :=aStream next ]] on:Error do:[:ex| self handleAnyError: ex ].
		self flag: #todo. "Reading from stdin does not work directly, hence we load everything a buffer first"	
	
	^ aBuffer

]

{ #category : #'input-subsystem' }
SCViewServer >> readJsonFrom: aStream [	
	| result buffer|
	buffer := self readFromStreamAndWriteABuffer: aStream.	
	[result := self materializer materializeFromStream: buffer] on:Error do:[:e| self debug:e messageText].
	result 
		ifNil:[self debug:'[ViewServer]-Read: nil']
		ifNotNil:[self debug:'[ViewServer]-Read: ', buffer contents].
	^ result

]

{ #category : #'socket-subsystem' }
SCViewServer >> readJsonFromCommStream [
	^ self readJsonFrom: self commStream
]

{ #category : #views }
SCViewServer >> reduce:rFunction  keys:keyArray values:valArray rereduce:aBoolean [
	"Execute a reduce function
	keyArray: [[key1,id1],[key2,id2],...,[keyn,idn]
	valArray: [val1, val2, val3,...,valn]"
	| res rfun reduceFunction|
	[  
  		reduceFunction:= rFunction trimSpaces. 
		rfun:=self runner compiledFunctions at: reduceFunction hash ifAbsentPut:[		
				Compiler evaluate:reduceFunction for: self runner logged:false ].
		res:= rfun valueWithEnoughArguments:( Array with:keyArray with:valArray with:aBoolean).
		^res
	] on:Error do:[:err| 
			self log:err description.
			^Array with:false with:nil].

		
]

{ #category : #views }
SCViewServer >> reset [
	funs:=nil.
	lib:= nil.
	runner:=nil.
	Smalltalk garbageCollect.
	^'true'.
	
	

	

	
]

{ #category : #accessing }
SCViewServer >> runner [
	"runner provide us a basic Application context where we can execute all the methods related to a View, Show, List... "
	^ runner ifNil:[ runner := SCAppContext on:self ]
	
	
]

{ #category : #serialization }
SCViewServer >> serializer [
	^ serializer ifNil:[ serializer := SCSerializer new serializeAllCollectionsAsArrays ]
]

{ #category : #accessing }
SCViewServer >> session [
	^ session
]

{ #category : #accessing }
SCViewServer >> session: anObject [
	"session could be the StandardFileStream stdout or a TCP session depending on the kind of connection"
	^ session := anObject
]

{ #category : #'socket-subsystem' }
SCViewServer >> start [
"Starts the server and reads the a Json Array from default port"
self startOn:8181
]

{ #category : #'socket-subsystem' }
SCViewServer >> startOn:aPort [
	"Starts the server and reads the a Json Array from net"
	
	self class stop:aPort.
	self port: aPort..
	self session:nil.
	exit:=false.


aServer:=[
	[ 	
	|  jsonArray msg  |
	[exit] whileFalse:[
	Transcript show: '- listening socket';cr.
			[self session isNil and:[self exit not]] whileTrue:[
				socket:=Socket newTCP. 			
				socket listenOn:port backlogSize:50 interface:self listenerAddress.
				Transcript show: '- Socket created';cr.
				socket isValid ifFalse: [ self error: 'Cannot listen on port ' , port asString ].
				"we need to wait a very high value...serial conection 
				will be up all the time the couchdb is running"
				self session: (socket waitForAcceptFor:604800000 ifTimedOut:[	
						Processor yield.
						(Delay forMilliseconds: 10) wait.
						socket destroy.
						])
			].
			self commStream: (SocketStream on: self session).
			jsonArray:=self readJsonFrom:commStream.
			jsonArray 
				ifNil:[
					Transcript show: '- Socket destroyed';cr.
					socket closeAndDestroy.
					self commStream close.
					self session:nil]
				ifNotNil:[	
					[[[[msg:=self mainLoop:jsonArray.
						msg ifNotNil:[self println:msg]]
					on:NetworkError do:["Nothing"]]
					on:SCViewServerException  do:[:ex| self handleException: ex ]]
					on:SCViewServerError do:[:ex| self handleFatalError: ex ]]
					on:Error do:[:ex| 
						socket closeAndDestroy.
						self handleAnyError: ex ].	
				] 				
			 ] 
	] ensure:
		[
		socket closeAndDestroy.
		self commStream ifNotNil:[self commStream close].
		self session ifNotNil:[self session closeAndDestroy].
		self session:nil].
	] forkNamed:('SCouchViewServerOn-' , port asString).


]

{ #category : #'socket-subsystem' }
SCViewServer >> startOnStandardIO [
	"Starts the server reading on standard io"

	|  jsonArray msg  |	
		
	"debug := self class debug."
	self port: #stdio.
	FileStream stdout wantsLineEndConversion: true; converter.
	self session: VTermOutputDriver stdout.
	self commStream: FileStream stdin.

	 [ (jsonArray:=self readJsonFrom:self commStream) isNil] whileFalse:[  
		[[[
					msg:=self mainLoop:jsonArray.
					msg ifNotNil:[self println:msg].
					Processor yield]	
					on:SCViewServerException  do:[:ex| self handleException: ex ]]
					on:SCViewServerError do:[:ex| self handleFatalError: ex ]]
					on:Error do:[:ex| self handleAnyError: ex ]].
		SessionManager default snapshot:false andQuit:true.
]

{ #category : #'socket-subsystem' }
SCViewServer >> stop [
	"stop this server"
	self exit:true.
	aServer ifNotNil:[
			aServer terminate.
			aServer:=nil
	].
]
