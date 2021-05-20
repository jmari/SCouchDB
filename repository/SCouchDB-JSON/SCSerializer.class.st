"
Serializes any Smalltalk Object to a json representation. 
This class assigns an ID to each object in order to support circular references
This ID is supplied by a SCUUIDProvider that uses the SCObjectCache couchCache to save these references. 

-Public API and Key Messages
areAllCollectionsSerializedAsArrays. Return true if the instance is setted to serialize all kind of collections as Arrays.
serialize: anObject. Serializes an object to a string.
serializeAllCollectionsAsArrays. Set the instance to serialice all the collections (Set, OrderedCollection, Stack...) as Json Arrays.

-On class side:
serialize: anObject. Serializes an object.

- How to create instances.
on: anAdaptor. Creates and return an Instance, this instance has a SCCouchUUIDProvider connected to the supplied adaptor. It uses the SCAdaptor to ask CouchDB for new uuids. 

- Instance Variables
	allColectionSerializedAsArray:		<Bool>
	pool:		<WeakIdentityKeyDictionary> used to keep in mind the objects already serialized.
	schemes:		<Dictionary> stores the {class -> Block} associations. Each block is responsible of the serialization of a class.
	uuidProvider:		<SCUUIDProvider> used to discover or get a new one uuid for an object 

"
Class {
	#name : #SCSerializer,
	#superclass : #Object,
	#instVars : [
		'schemes',
		'pool',
		'uuidProvider',
		'allColectionSerializedAsArray',
		'idPropertySymbol',
		'idField'
	],
	#category : 'SCouchDB-JSON'
}

{ #category : #'static-methods' }
SCSerializer class >> serialize: anObject [
	^ self new serialize: anObject 
]

{ #category : #'static-methods' }
SCSerializer class >> serialize: anObject to: aStream [
	| serializer |
	serializer:= self new.
	serializer pool removeAll.
	serializer serialize: anObject to:aStream
]

{ #category : #accessing }
SCSerializer >> areAllColectionsSerializedAsArray [
	^ allColectionSerializedAsArray ifNil:[ allColectionSerializedAsArray := false]
]

{ #category : #private }
SCSerializer >> blockForArrays [
^[ :obj :stream| 


		self pool at:obj put:nil.
		stream nextPut:$[.				
		obj do:[:each| 	
				self serialize: each to: stream.
				stream nextPut:$,
		].

		obj ifNotEmpty:[stream position: stream position -1].
		stream nextPut:$].

		]
	


]

{ #category : #private }
SCSerializer >> blockForAssociations [
	^ [ :obj :stream| 
				stream nextPut:$";nextPutAll: obj key asString;nextPut:$";nextPut:$:. 
				self serialize: obj value to:stream].
]

{ #category : #private }
SCSerializer >> blockForCollections [
^[ :obj :stream| 
	|cobj|

	cobj := [obj asArray] on:Error do:[Array new].
	(self pool includesKey: obj) ifFalse:[
		self pool at:obj put:nil.
		stream nextPut:${.		
		(self writeIdRevInstanceOf: obj on:stream ) ifTrue:[stream nextPut:$,].
		stream nextPutAll:'"#values":['.				
		cobj  do:[:each| 	
				self serialize: each to: stream.
				stream nextPut:$,
		].
		cobj isNotEmpty ifTrue:[stream position: stream position -1].
		stream nextPut:$].
		stream nextPut:$}.
		]
		ifTrue:[
			stream nextPut:${.		
			self writeIdRevInstanceOf: obj on:stream.
			stream nextPut:$}]
	]


]

{ #category : #private }
SCSerializer >> blockForDictionaries [
^[ :obj :stream| 

	(self pool includesKey: obj) ifFalse:[
		self pool at:obj put:nil.
		stream nextPut:${.		
		(self writeIdRevInstanceOf: obj on:stream ) ifTrue:[obj ifNotEmpty:[stream nextPut:$,]].
		obj associationsDo:[:each| 
			self serialize:  each to: stream.
			stream nextPut:$, ].
		obj ifNotEmpty:[stream position: stream position -1].
		stream nextPut:$}.
		]
		ifTrue:[
			stream nextPut:${.		
			self writeIdRevInstanceOf: obj on:stream.
			stream nextPut:$}]
	]
]

{ #category : #private }
SCSerializer >> blockForObjects [

^[ :obj :stream| 
	| instanceVariables |
	(self pool includesKey: obj) ifFalse:[
		self pool at:obj put:nil.
		stream nextPut:${.		
		instanceVariables := (obj respondsTo: #scInstanceVarsToSerialize)
										ifTrue:[obj scInstanceVarsToSerialize]
										ifFalse:[obj class allInstVarNames].

		(self writeIdRevInstanceOf: obj on:stream ) ifTrue:[instanceVariables ifNotEmpty:[stream nextPut:$,]].
		instanceVariables do:[:varName|
			stream 
				nextPut:$";
				nextPutAll: varName asString;
				nextPut:$";
				nextPut:$:.
				self serialize: ( obj instVarNamed:varName ) to: stream.
			stream 	nextPut:$,
			 ].
		instanceVariables ifNotEmpty:[stream position: stream position -1].
		stream nextPut:$}]
	ifTrue:[
		stream nextPut:${.		
		self writeIdRevInstanceOf: obj on:stream.
		stream nextPut:$}]]
]

{ #category : #private }
SCSerializer >> blockForRootObjects [

^[ :obj :rootStream| 
	| instanceVariables nextObject stream|
	stream:= WriteStream on:String new.
	(self pool includesKey: obj) ifFalse:[
		self pool at:obj put:nil.
		
		instanceVariables := (obj respondsTo: #scInstanceVarsToSerialize)
										ifTrue:[obj scInstanceVarsToSerialize]
										ifFalse:[obj class allInstVarNames].
		stream nextPut:${.	
		(self writeIdRevInstanceOf: obj on:stream ) ifTrue:[instanceVariables ifNotEmpty:[stream nextPut:$,]].
		instanceVariables do:[:varName|
			stream 
				nextPut:$";
				nextPutAll: varName asString;
				nextPut:$";
				nextPut:$:.
				nextObject := obj instVarNamed:varName.
				"serialize other root objects in a new Stream, we will join them later
				 once the object is serialized, we will only include its reference"
				nextObject class isVoyageRoot ifTrue:[
					self serialize: nextObject to: rootStream.
					rootStream nextPut:$,].
				self serialize: nextObject to: stream.
			stream 	nextPut:$,
			 ].
		instanceVariables ifNotEmpty:[stream position: stream position -1].
		stream nextPut:$}]
	ifTrue:[
		stream nextPut:${.		
		self writeIdRevInstanceOf: obj on:stream.
		stream nextPut:$}].
	rootStream nextPutAll: stream contents.
	]
]

{ #category : #private }
SCSerializer >> doNotneedIdRev: anObject [
	^ ((anObject isSCJsonObject) & ((anObject isSCAppContext ) not))
]

{ #category : #private }
SCSerializer >> escapeString: aString [
	
	| c oldStream newStream code |

	oldStream := ReadStream on:aString.
	newStream := WriteStream on:String new.
	[oldStream atEnd] whileFalse:[
		c := oldStream next.
		c == $/ ifTrue: [newStream nextPut:$\;nextPut:$/] ifFalse:[
		c == $\ ifTrue: [newStream nextPut:$\;nextPut:$\] ifFalse:[
		c == $" ifTrue: [newStream nextPut:$\;nextPut:$"] ifFalse:[
		c == Character backspace ifTrue: [newStream nextPut:$\;nextPut:$b] ifFalse:[
		c == Character lf ifTrue:[newStream nextPut:$\;nextPut:$n]ifFalse:[
		c == Character newPage ifTrue:[newStream nextPut:$\;nextPut:$f]ifFalse:[
		c == Character cr ifTrue:[newStream nextPut:$\;nextPut:$r]ifFalse:[
		c == Character tab ifTrue:[newStream nextPut:$\;nextPut:$t]ifFalse:[
		c codePoint > 255 ifTrue:[
			code :=(c asUnicode printStringBase:16). 
			[code size<4] whileTrue:[code:= '0', code].
			newStream nextPutAll: '\u';nextPutAll:code ]ifFalse:[newStream nextPut:c]]]]]]]]].

	].
	^ newStream contents.
]

{ #category : #accessing }
SCSerializer >> idField [
	^ idField ifNil:[ idField := #_id ]
]

{ #category : #accessing }
SCSerializer >> idField: aField [
	idField  := aField 
]

{ #category : #private }
SCSerializer >> pool [
	^ pool ifNil:[ pool := WeakIdentityKeyDictionary  new ]
]

{ #category : #private }
SCSerializer >> schemeFor:aClass [

	^  self schemes at: aClass ifAbsent:[ self schemeFor:aClass superclass ].
	

]

{ #category : #private }
SCSerializer >> schemes [
	^ schemes ifNil:[
		schemes := {
			UndefinedObject -> [ :obj :stream| stream nextPutAll: 'null'  ].
			True -> [ :obj :stream| stream nextPutAll: 'true'  ].
			False -> [ :obj :stream| stream nextPutAll: 'false'  ].
			Number -> [ :obj :stream| stream nextPutAll: obj asString  ].
			String -> [ :obj :stream| stream nextPut:$";nextPutAll: (self escapeString:obj);nextPut:$"].
			Array -> self blockForArrays.
			Collection -> self blockForCollections.
			Association -> self blockForAssociations. 
			Dictionary -> self blockForDictionaries.
			BlockClosure -> [ :obj :stream | stream nextPut:$";nextPutAll:(self escapeString: obj sourceCode);nextPut:$"].
			Object -> self blockForObjects. 
			} asDictionary ]
	
]

{ #category : #serializing }
SCSerializer >> serialize: anObject [ 
	| str |
	self pool removeAll.
	str := WriteStream on:String new.
	self serialize:anObject to: str.
	^ str contents	


]

{ #category : #private }
SCSerializer >> serialize: anObject to: aStream [

	(self schemeFor: anObject class) value: anObject value: aStream.


]

{ #category : #accessing }
SCSerializer >> serializeAllCollectionsAsArrays [
	allColectionSerializedAsArray := true.
	self schemes at:Collection put:self blockForArrays 
]

{ #category : #private }
SCSerializer >> uuidProvider [
	^ uuidProvider ifNil:[ uuidProvider := SCSmalltalkUUIDProvider 
																					new
																						idField: self idField;
																						yourself	]
]

{ #category : #private }
SCSerializer >> uuidProvider: anObject [
	uuidProvider := anObject
]

{ #category : #private }
SCSerializer >> writeIdRevInstanceOf:obj on: stream [
	| idRev uuid needComma cachedObject |

	needComma := false.
	uuid := self uuidProvider discoverIdFor: obj.
	uuid ifNotNil:[
		cachedObject := SCObjectsCache instance at:uuid.
		cachedObject = #deleted ifTrue:[
			needComma :=true.
			stream nextPutAll:'"_deleted":true']].
	
	((self areAllColectionsSerializedAsArray )| (self doNotneedIdRev: obj))
		ifTrue:[	^ needComma]
		ifFalse:[
			idRev := uuid 
						ifNotNil:[ ( uuid -> (self uuidProvider getRevFor:uuid ))]
						ifNil:[self uuidProvider getIdRevisionAssociationFor:obj]. 
			idRev key ifNotNil:[
				needComma ifTrue:[stream nextPut:$,].
				stream nextPut:$";nextPutAll:self idField;nextPutAll: '":"';nextPutAll: idRev key asString;nextPut:$"].
			idRev value ifNotNil:[stream nextPut:$,;nextPutAll:'"_rev":"';nextPutAll:idRev value asString;nextPut:$"].
			stream  
					nextPut:$,;
					nextPutAll:'"#instanceOf":';
					nextPut:$";nextPutAll:obj class asString;nextPut:$".
		^ true]
		
]
