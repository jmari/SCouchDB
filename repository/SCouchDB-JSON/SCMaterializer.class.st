"
This class reads and writes JSON format data - strings, numbers, boolean, nil, arrays and dictionaries. See http://www.crockford.com/JSON/index.html. It has been extended with syntax for invoking a prearranged list of constructors on read objects.
"
Class {
	#name : #SCMaterializer,
	#superclass : #Object,
	#instVars : [
		'stream',
		'adaptor',
		'schemes',
		'defaultMapClass',
		'idField'
	],
	#classInstVars : [
		'escapeArray'
	],
	#category : #'SCouchDB-JSON-Core'
}

{ #category : #'as yet unclassified' }
SCMaterializer class >> materializeFrom: aStream [


	^ self new materializeFromStream: aStream.
]

{ #category : #'as yet unclassified' }
SCMaterializer class >> materializeFromString: aString [
	"materializes as a Dictionary nor a Smalltalk class"
	| aStream |
	
	aStream :=ReadStream on:aString.
	^ self new materializeFromStream: aStream.
]

{ #category : #'as yet unclassified' }
SCMaterializer class >> readFrom: aStream [
	"materializes as a Dictionary nor a Smalltalk class"
	^ self new readFrom: aStream.
]

{ #category : #'as yet unclassified' }
SCMaterializer class >> readFromString: aString [
	"materializes as a Dictionary nor a Smalltalk class"
	| aStream |
	
	aStream :=ReadStream on:aString.
	^ self new readFrom: aStream.
]

{ #category : #private }
SCMaterializer >> blockForCollections [
	
	^ [ :obj :json |
		| nObj nArray|
		(obj isKindOf: ArrayedCollection) 
				ifTrue:[					
					nObj := (json isKindOf:Dictionary)
									ifTrue:[ json at:'#values' ]
									ifFalse:[ json ].
					nArray := obj class new: nObj size.
					nObj doWithIndex:[:each :index|
						nArray at:index put: (self imaterialize:each)].
					nArray]
				ifFalse:[
					obj removeAll.
					(json at:'#values') do:[:each| obj add: (self imaterialize:each)].
					obj]]
	
	
]

{ #category : #private }
SCMaterializer >> blockForDictionaries [
	^ [ :obj :json |	
		"comented because problems in the view server...."
		json keysAndValuesDo:[:k : v| 
			((k = '#instanceOf' ) "or:[(k = '_id' ) or:[k = '_rev' ]]")
			 ifFalse:[	obj at:k put: (self imaterialize:v)]	].
		self cacheNewObject:obj json:json.
		obj]
	
	
]

{ #category : #private }
SCMaterializer >> blockForJSON [
	^ [ :obj :json |	
		json keysAndValuesDo:[:k : v| 
			(k = '#instanceOf' ) ifFalse:[	obj at:k put: (self imaterialize:v)]].
		self cacheNewObject:obj json:json.
		obj]
	
	
]

{ #category : #private }
SCMaterializer >> blockForObjects [
	^ [ :obj :json |	
		json keysAndValuesDo:[:k : v| 
			(obj class allInstVarNames includes:k) ifTrue:[
					obj instVarNamed:k put: (self imaterialize:v)]].
		self cacheNewObject:obj json:json.
		obj]
	
	
]

{ #category : #private }
SCMaterializer >> cacheNewObject: anObject json:json [
"insert it in the cache"
	| id rev |
	id :=json at:self idField.
	rev := json at:'_rev'. 
	id ifNotNil:[SCObjectsCache instance at:id put: anObject].
	rev ifNotNil:[SCObjectsCache instance at:id putRevision: rev].	
			
]

{ #category : #private }
SCMaterializer >> consume: aString returning: anObject [
	aString do: [:c | stream next == c ifFalse: [SCJsonSyntaxError signal: 'Expected ''', aString, ''''] ].
	^ anObject
]

{ #category : #accessing }
SCMaterializer >> defaultMapClass [
	"SCJsonObject or SCDocument or Dictionary or..."
	^ defaultMapClass ifNil:[defaultMapClass := SCJsonObject ]
]

{ #category : #accessing }
SCMaterializer >> defaultMapClass: mapClass [
	"SCJsonObject or SCDocument or Dictionary..."
	defaultMapClass := mapClass
]

{ #category : #accessing }
SCMaterializer >> idField [
	^ idField ifNil:[ idField := '_id' ]
]

{ #category : #accessing }
SCMaterializer >> idField: aField [
	 idField := aField
]

{ #category : #private }
SCMaterializer >> imaterialize: json [

	| className binding objectCached |

	objectCached := json copy.
	(json isKindOf:Dictionary) ifTrue:[
		objectCached := SCObjectsCache instance at:(json at:self idField ifAbsent:[nil]) ifAbsent:[nil].		
		objectCached ifNil:[
			className := json at: '#instanceOf' ifAbsent:[self defaultMapClass asString].
			"we're intentionally avoid using any globals here, such as Smalltalk"
			binding := (self class environment bindingOf: className asSymbol)
								ifNil: [ 
									"try to materialize in the Default class"
									self class environment bindingOf:self defaultMapClass asString asSymbol ].
			objectCached :=binding value new.
			self cacheNewObject: objectCached json:json.]].

	^ self injectValuesFrom: json into: objectCached. 
	
]

{ #category : #private }
SCMaterializer >> injectValuesFrom: json into: anObject [
	|  mtz|

	mtz := self schemeFor: anObject class.
	^ mtz value:anObject value:json
	
]

{ #category : #private }
SCMaterializer >> interpretStringEscape [
	| c |
	c := stream next.
	c == $b ifTrue: [^ Character backspace].
	c == $n ifTrue: [^ Character lf].
	c == $f ifTrue: [^ Character newPage].
	c == $r ifTrue: [^ Character cr].
	c == $t ifTrue: [^ Character tab].
	c == $u ifTrue: [^ self unescapeUnicode].
	^ c.
]

{ #category : #materializer }
SCMaterializer >> materialize: jsonString [
	"materializes a json object serialized in a string as an Smalltalk Object"
	| aStream |

	aStream := ReadStream on: jsonString.
	^ self imaterialize: ( self readFrom: aStream)
]

{ #category : #materializer }
SCMaterializer >> materializeFromJsonDictionary: jsonDictionary [
	"materializes a json object (not in string form) as an Smalltalk Object"

	^ self imaterialize: jsonDictionary
]

{ #category : #materializer }
SCMaterializer >> materializeFromStream: jsonStream [
	"materializes a json object serialized in a stream as an Smalltalk Object"
	
	^ self imaterialize: ( self readFrom: jsonStream)
]

{ #category : #parsing }
SCMaterializer >> numbersMayContain: aChar [
	^ aChar isDigit or: [#($- $+ $. $e $E) includes: aChar]
]

{ #category : #parsing }
SCMaterializer >> numbersStartByContain: aChar [
	"a number should not start by + we leave it anyway"
	^ aChar isDigit or: [#($- $+) includes: aChar]
]

{ #category : #parsing }
SCMaterializer >> readAny [
	"This is the main entry point for the JSON parser. See also readFrom: on the class side."
	| c |
	(self skipWhitespace) ifNil:[^nil].
	c := stream peek asLowercase.
	c == ${ ifTrue: [stream next. ^ self readDictionary].
	c == $[ ifTrue: [stream next. ^ self readArray].
	c == $" ifTrue: [stream next. ^ self readString].
	c == $t ifTrue: [^ self consume: 'true' returning: true].
	c == $f ifTrue: [^ self consume: 'false' returning: false].
	c == $n ifTrue: [^ self consume: 'null' returning: nil].
	
	(self numbersStartByContain: c) ifTrue: [^ self readNumber].
	SCJsonSyntaxError signal: 'Unknown Json input'
]

{ #category : #private }
SCMaterializer >> readArray [
	| a |
	a := OrderedCollection new.

	self skipWhitespace.
	(stream peekFor: $]) ifTrue: [ ^ #() ].	

	[
		a add: self readAny.
		self skipWhitespace.
		(stream peekFor: $]) ifTrue: [ ^ a asArray].
		(stream peekFor: $, ) ifFalse: [SCJsonSyntaxError signal: 'Missing comma'].
	] repeat.

]

{ #category : #private }
SCMaterializer >> readDictionary [
	| m k v needComma |
	m := SCJsonObject new.
	needComma := false.
	[
		self skipWhitespace.
		(stream peekFor: $}) ifTrue: [ ^ m].
		needComma
			ifTrue: [ (stream peekFor: $,) ifFalse: [SCJsonSyntaxError signal: 'Missing comma'].
					self skipWhitespace]
			ifFalse: [needComma := true].
"		k := self readAny. "
		(stream peekFor: $") 
			ifTrue:[ 
				k:= self readString.
				self skipWhitespace.
				(stream peekFor: $:) ifFalse: [SCJsonSyntaxError signal: 'Missing colon']. ]
			ifFalse: [ 
				k:= self readUnquotedPropertyName.
				self skipWhitespace. ].
		
		
		v := self readAny.
		m at: k put: v.
	] repeat.

]

{ #category : #parsing }
SCMaterializer >> readFrom: aStream [
	self stream: aStream.
	^ self readAny
]

{ #category : #parsing }
SCMaterializer >> readFromString: aString [
	
	self stream: (ReadStream on: aString).
	^ self readAny
]

{ #category : #private }
SCMaterializer >> readNumber [
	| acc c |
	acc := WriteStream on: ''.
	[
		c := stream peek.
		(c isNil not and: [self numbersMayContain: c]) ifFalse: [
			[^ acc contents asNumber] on: Error do: [SCJsonSyntaxError signal: 'Invalid number']].
		acc nextPut: c.
		stream next.
	] repeat.
]

{ #category : #private }
SCMaterializer >> readString [
	| s c |
	s := WriteStream on: ''.
	[
		c := stream next.
		c == $\
			ifTrue: [s nextPut: self interpretStringEscape.]
			ifFalse: [c == $" ifTrue: [^ s contents.].
					s nextPut: c]
	] repeat.
]

{ #category : #private }
SCMaterializer >> readUnquotedPropertyName [
	| s c |
	s := WriteStream on: ''.
	[
		c := stream next.
		c == $\
			ifTrue: [s nextPut: self interpretStringEscape.]
			ifFalse: [(c == $:) ifTrue: [ ^ s contents trimBoth].
					(c isNil) ifTrue:[SCJsonSyntaxError signal: 'Missing colon'].
					s nextPut: c]
	] repeat.
]

{ #category : #private }
SCMaterializer >> reset [

	schemes := nil.
]

{ #category : #private }
SCMaterializer >> schemeFor:aClass [
	|scheme|
	scheme := self schemes at: aClass ifAbsent:[ self schemeFor:aClass superclass ].
	^scheme
]

{ #category : #private }
SCMaterializer >> schemes [

	^ schemes ifNil:[
		schemes := {
			UndefinedObject -> [ :obj :json|  nil  ].
			True -> [ :obj :json| true  ].
			False -> [ :obj :json| false  ].
			Number -> [ :obj :json| json ].
			String -> [ :obj :json| json ].
			Collection -> self blockForCollections.
			"Association -> self blockForAssociations. "
			SCJsonObject -> self blockForJSON.
			Dictionary -> self blockForDictionaries.
			BlockClosure -> [ :obj :json | json].
			Object -> self blockForObjects. 
			} asDictionary ]
	
]

{ #category : #private }
SCMaterializer >> skipComment [
	stream peek == $/ ifTrue: [
		stream next.
		stream peek == $/
			ifTrue: [self skipToEndOfLine]
			ifFalse: [stream peek == $*
						ifTrue: [stream next. self skipCommentBody]
						ifFalse: [SCJsonSyntaxError signal: 'Invalid comment syntax']]]

]

{ #category : #private }
SCMaterializer >> skipCommentBody [
	[
		[stream next == $*] whileFalse.
		stream peek == $/
	] whileFalse.
	stream next. "skip that last slash"
	self skipWhitespace.
]

{ #category : #private }
SCMaterializer >> skipToEndOfLine [
	| cr lf |
	cr := Character cr. lf := Character lf.
	[ | c | (c := stream peek) == cr or: [ c == lf]] whileFalse: [stream next].
	self skipWhitespace
]

{ #category : #private }
SCMaterializer >> skipWhitespace [
	stream peek ifNil:[^nil].
	[stream peek isSeparator] whileTrue: [stream next].
	self skipComment.
]

{ #category : #private }
SCMaterializer >> stream [
	"Answer the value of stream"

	^ stream
]

{ #category : #private }
SCMaterializer >> stream: anObject [
	"Set the value of stream"

	stream := anObject.
	(stream respondsTo: #reset) ifTrue: [
		stream reset.
	].

]

{ #category : #private }
SCMaterializer >> unescapeUnicode [
	|string|
	string := (String with: stream next with: stream next with: stream next with: stream next) asUppercase.
	^ Unicode value: (Integer readFrom: string readStream base: 16)
]
