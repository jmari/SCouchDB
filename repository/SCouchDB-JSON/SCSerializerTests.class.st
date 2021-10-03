Class {
	#name : #SCSerializerTests,
	#superclass : #TestCase,
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #testing }
SCSerializerTests >> testAssociation [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer serialize:object to: stream) ] ].
	"I know this is not valid as Json, we assume associoations will be inside a disctionary"
	self assert: (writer value: 'foo' -> 42) equals: '"foo":42'.
	self assert: (writer value: Association new) equals: '"nil":null'
]

{ #category : #testing }
SCSerializerTests >> testBooleans [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer serialize:object to: stream) ] ].
	self assert: (writer value: true) equals: 'true'.
	self assert: (writer value: false) equals: 'false'.
]

{ #category : #testing }
SCSerializerTests >> testByteArray [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				serializeAllCollectionsAsArrays;
				serialize:object to: stream) ] ].
	self assert: (writer value: #[1 2 3]) equals: '[1,2,3]'.
	self assert: (writer value: #[]) equals: '[]'

]

{ #category : #testing }
SCSerializerTests >> testDate [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new
				serializeDateAsString;
				serialize:object to: stream) ] ].
	self assert: (writer value: (Date fromString: '2012-06-08')) equals: '"2012-06-08"'
]

{ #category : #testing }
SCSerializerTests >> testDateAndTime [ 
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new
				serializeDateAsString;
				serialize:object to: stream) ] ].
	self 
		assert: (writer value: (DateAndTime year: 2012 month: 2 day: 14 hour: 16 minute: 40 second: 18 offset: 1 hour)) 
		equals: '"2012-02-14T16:40:18+01:00"'
]

{ #category : #testing }
SCSerializerTests >> testExtendedAsciiOnlyStrings [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer serialize:object to: stream) ] ].
	
	self assert: (writer value: 'élève français') equals: '"élève français"'.
	self assert: (writer value: 'foo') equals: '"foo"'.
	self assert: (writer value: 'Foo BAR') equals: '"Foo BAR"'.
	self assert: (writer value: '') equals: '""'.
	self
		assert: (writer value: (String withAll: ( OrderedCollection new 
			add: $";
			add: $\; 
			add: $/;
			add: Character tab;
			add: Character cr;
			add: Character lf;
			add: Character newPage; 
			add: Character backspace;
			yourself )))
		equals: '"\"\\\/\t\r\n\f\b"'


]

{ #category : #testing }
SCSerializerTests >> testFloatPrinter [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer 
				serialize:object to: stream) ] ].
	self assert: (writer value: 123.0) equals: '123.0'.
	self assert: (writer value: -123.0) equals: '-123.0'.
	self assert: (writer value: 0.0) equals: '0.0'.
	self assert: (writer value: 1.50) equals: '1.5'.
	self assert: (writer value: -1.25) equals: '-1.25'.
	self assert: (writer value: Float pi) equals: '3.141592653589793'.
	self assert: (writer value: 9.10938356e-31) equals: '9.10938356e-31'.
	self assert: (writer value: 5.9724e24) equals: '5.9724e24'.
	self assert: (writer value: 1234567890.1234567890) equals: '1.2345678901234567e9'.
	self assert: (writer value: (1/3) asFloat) equals: '0.3333333333333333'.
]

{ #category : #testing }
SCSerializerTests >> testFloats [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer 
				serialize:object to: stream) ] ].
	self assert: (writer value: 123.0) equals: '123.0'.
	self assert: (writer value: -123.0) equals: '-123.0'.
	self assert: (writer value: 0.0) equals: '0.0'.
]

{ #category : #testing }
SCSerializerTests >> testIntegers [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer 
				serialize:object to: stream) ] ].
	self assert: (writer value: 123) equals: '123'.
	self assert: (writer value: -123) equals: '-123'.
	self assert: (writer value: 0) equals: '0'.
]

{ #category : #testing }
SCSerializerTests >> testLists [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer 
				serialize:object to: stream) ] ].
	self assert: (writer value: #(1 2 3)) equals: '[1,2,3]'.
	self assert: (writer value: #()) equals: '[]'.

]

{ #category : #testing }
SCSerializerTests >> testListsExtra [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				serializeAllCollectionsAsArrays;
				serialize:object to: stream) ] ].
		
	#( OrderedCollection LinkedList ByteArray IntegerArray SortedCollection ) do: [ :each |
		Smalltalk at: each ifPresent: [ :collectionClass |
			self assert: (writer value: (collectionClass withAll: #(1 2 3))) equals: '[1,2,3]'.
			self assert: (writer value: collectionClass new) equals: '[]' ] ]

]

{ #category : #testing }
SCSerializerTests >> testMapKeysMustBeStrings [
	self assert: (SCSerializer serialize: { 1->#a } asSCJsonObject) equals: '{"1":"a"}'.
	self assert: (SCSerializer serialize: { true->#a } asSCJsonObject)  equals:  '{"true":"a"}'.
	self assert: (SCSerializer serialize: { nil->#a } asSCJsonObject ) equals:  '{"nil":"a"}'.
	self assert: (SCSerializer serialize: { #()->#a } asSCJsonObject)  equals:  '{"#()":"a"}'.
	self assert: (SCSerializer serialize: { Dictionary new->#a } asSCJsonObject)  equals:  '{"a Dictionary()":"a"}'.
	self assert: (SCSerializer serialize: { Float pi->#a } asSCJsonObject ) equals:  '{"3.141592653589793":"a"}'.
]

{ #category : #testing }
SCSerializerTests >> testMaps [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				serialize:object to: stream) ] ].
	self assert: ((writer value: (Dictionary newFromPairs: #( 'x' 1 'y' 2))) includesSubstring: '"x":1').
	self assert: ((writer value: (Dictionary newFromPairs: #( 'x' 1 'y' 2))) includesSubstring: '"y":2').
	self assert: (writer value: SCJsonObject new) equals: '{}'.

]

{ #category : #testing }
SCSerializerTests >> testNonBMPCharacterEncoding [
	"Characters not in the Basic Multilingual Plane are encoded as a unicode base 16"

	| string json |
	string := 16r1D11E asCharacter asString. "MUSICAL SYMBOL G CLEF"
	
	json:=String streamContents: [ :stream |
			(SCSerializer serialize: string to: stream) ] .
	self assert: json equals: '"\u1D11E"'
]

{ #category : #testing }
SCSerializerTests >> testNull [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				serialize:object to: stream) ] ].
	self assert: (writer value: nil) equals: 'null'
]

{ #category : #testing }
SCSerializerTests >> testPoint [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				plainJson;
				serialize:object to: stream) ] ].
	self assert: (writer value: 1@2)  equals: '{"x":1,"y":2}'
]

{ #category : #testing }
SCSerializerTests >> testPoint1 [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				plainJson;
				serialize:object to: stream) ] ].
	self assert: (writer value: 1@2) equals: '{"x":1,"y":2}'.
	self assert: (writer value: Point new) equals: '{"x":null,"y":null}'
]

{ #category : #testing }
SCSerializerTests >> testStrings [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				serialize:object to: stream) ] ].
	self assert: (writer value: 'foo') equals: '"foo"'.
	self assert: (writer value: 'Foo BAR') equals: '"Foo BAR"'.
	self assert: (writer value: '') equals: '""'.
	self
		assert: (writer value: (String withAll: ( OrderedCollection new 
			add: $";
			add: $\; 
			add: $/;
			add: Character tab;
			add: Character cr;
			add: Character lf;
			add: Character newPage; 
			add: Character backspace;
			yourself )))
		equals: '"\"\\\/\t\r\n\f\b"'



]

{ #category : #testing }
SCSerializerTests >> testSymbol [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				serialize:object to: stream) ] ].
		
	self assert: (writer value: #foo) equals: '"foo"'.
	self assert: (writer value: #'FOO-1') equals: '"FOO-1"'

]

{ #category : #testing }
SCSerializerTests >> testTime [
	| writer |
	writer := [ :object | 
		String streamContents: [ :stream |
			(SCSerializer new 
				serializeDateAsString;
				serialize:object to: stream) ] ].
		
	self assert: ((writer value: (Time fromSeconds: 52208)) includesSubstring: '"seconds":52208')
]
