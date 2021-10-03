Class {
	#name : #SCMaterializerTests,
	#superclass : #TestCase,
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #testing }
SCMaterializerTests >> testArray [
	| json list |
	json := '[ 1, 2, 3 ]'.
	list := (SCMaterializer materializeFrom:  json readStream).
	
	self 
		assert: list 
		equals: (Array with: 1 with: 2 with: 3).
	self 
		assert: list class 
		equals: Array
]

{ #category : #testing }
SCMaterializerTests >> testAssociation [
	| reader |
	reader := [ :input | SCMaterializer materializeFrom: input readStream].
	self assert: (reader value: '{"key":"foo","value":42}') equals: {'key'->'foo'. 'value'-> 42} asSCJsonObject. 
	self assert: (reader value: '{}') equals: SCJsonObject new
]

{ #category : #testing }
SCMaterializerTests >> testBooleans [
	self assert: (SCMaterializer materializeFrom: 'true' readStream)  equals: true.
	self assert: (SCMaterializer materializeFrom:  'false' readStream) equals: false.
	self should: [ (SCMaterializer materializeFrom:  'tru' readStream) ] raise: SCJsonSyntaxError.
	self should: [ (SCMaterializer materializeFrom:  'falsE' readStream) next ] raise: SCJsonSyntaxError.
]

{ #category : #testing }
SCMaterializerTests >> testByteArray [
	| reader |
	reader := [ :input | SCMaterializer materializeFrom: input readStream].
	self assert: (reader value: '[ 1, 2, 3 ]') equals: #(1 2 3).
	self assert: (reader value: '[ ]') equals: Array new
]

{ #category : #testing }
SCMaterializerTests >> testDate [
	| reader |
	reader := [ :input | SCMaterializer materializeFrom: input readStream].
	self assert: (reader value: ' "2012-06-08" ') equals: '2012-06-08' 
]

{ #category : #testing }
SCMaterializerTests >> testDateAndTime [ 
	| reader |
	reader := [ :input | SCMaterializer materializeFrom: input readStream].
	self 
		assert: (reader value: ' "2012-02-14T16:40:18+01:00" ') 
		equals: '2012-02-14T16:40:18+01:00'
]

{ #category : #testing }
SCMaterializerTests >> testFloats [
	| reader |
	reader := [ :string |
		(SCMaterializer materializeFrom: string readStream) ].
	self assert: ((reader value: '123.0') closeTo: 123.0).
	self assert: ((reader value: '-123.0') closeTo: -123.0).
	self assert: ((reader value: '123.0e0') closeTo: 123.0).
	self assert: ((reader value: '123e6') closeTo: 123e6).
	"self assert: ((reader value: '123e+6') closeTo: 123e6)."
	self assert: ((reader value: '123e-6') closeTo: 123e-6).
	"self assert: ((reader value: '123E6') closeTo: 123e6)."
	"self assert: ((reader value: '123E+6') closeTo: 123e6)."
	"self assert: ((reader value: '123E-6') closeTo: 123e-6)."
	self assert: ((reader value: '-123e6') closeTo: -123e6).
	self assert: ((reader value: '-123e-6') closeTo: -123e-6).
	"self assert: ((reader value: '-123E6') closeTo: -123e6)."
	"self assert: ((reader value: '-123E-6') closeTo: -123e-6)."
	self assert: ((reader value: '3.14159') closeTo: Float pi).
	self assert: ((reader value: '0.123e6') closeTo: 0.123e6).
	self assert: ((reader value: '0.123e-6') closeTo: 0.123e-6).
	"self assert: ((reader value: '-0.123E6') closeTo: -0.123e6)."
	"self assert: ((reader value: '-0.123E-6') closeTo: -0.123e-6)."

]

{ #category : #testing }
SCMaterializerTests >> testIntegers [
	| reader |
	reader := [ :string |
		(SCMaterializer materializeFrom: string readStream) ].
	self assert: (reader value: '123') equals: 123.
	self assert: (reader value: '00123') equals: 123.
	self assert: (reader value: '-123') equals: -123.
	self assert: (reader value: '-0123') equals: -123.
	self assert: (reader value: '0') equals: 0.
	self assert: (reader value: '-0') equals: 0.
	self assert: (reader value: '00') equals: 0.
	self assert: (reader value: ' 123	') equals: 123.
	self should: [ reader value: '+1' ] raise: SCJsonSyntaxError.
	self should: [ reader value: ' - ' ] raise: SCJsonSyntaxError.

]

{ #category : #testing }
SCMaterializerTests >> testLists [
	| reader |
	reader := [ :string |
		(SCMaterializer materializeFrom: string readStream) ].
	self assert: (reader value: '[1,2,3]') equals: #(1 2 3).
	self assert: (reader value: '[]') equals: #().
	self assert: (reader value: ' [ 1 , 2 , 3 ] ') equals: #(1 2 3).
	self assert: (reader value: ' [ ] ') equals: #().
	self should: [ reader value: '[1,]' ] raise: SCJsonSyntaxError . 
	self should: [ reader value: '[' ] raise: SCJsonSyntaxError.
	self should: [ reader value: ']' ] raise: SCJsonSyntaxError.
	self should: [ reader value: '[}' ] raise: SCJsonSyntaxError
]

{ #category : #testing }
SCMaterializerTests >> testMaps [
	| reader |
	reader := [ :input | SCMaterializer materializeFrom: input readStream].
	
	self assert: (reader value: '{"x":1,"y":2}') equals: (SCJsonObject newFromPairs: #( 'x' 1 'y' 2)).
	self assert: (reader value: '{}') equals: SCJsonObject new.
	self assert: (reader value: ' { "x" : 1 , "y" : 2 } ' ) equals: (SCJsonObject newFromPairs: #( 'x' 1 'y' 2)).
	self assert: (reader value: ' { } ') equals: SCJsonObject new.
	self should: [ reader value: '{"foo":}' ] raise: SCJsonSyntaxError. 
	self should: [ reader value: '{"foo":9,}' ] raise: SCJsonSyntaxError. 
	self should: [ reader value: '{9:true,}' ] raise: SCJsonSyntaxError. 
	self should: [ reader value: '{' ] raise: SCJsonSyntaxError.
	self should: [ reader value: '}' ] raise: SCJsonSyntaxError.
	self should: [ reader value: '{]' ] raise: SCJsonSyntaxError
]

{ #category : #testing }
SCMaterializerTests >> testNonBMPCharacterDecoding [
	"Characters not in the Basic Multilingual Plane are encoded as a 4 HEX digits unicode"

	| string object |
	string := 16r1D11 asCharacter asString. "MUSICAL SYMBOL G CLEF"
	object := (SCMaterializer materializeFromString: '"\u1D11"').
	self assert: object equals: string
]

{ #category : #testing }
SCMaterializerTests >> testNull [
	self assert: (SCMaterializer materializeFrom:  'null' readStream)  equals: nil.
	self assert: (SCMaterializer materializeFrom:  '	null ' readStream)  equals: nil.
	self should: [ (SCMaterializer materializeFrom:  '	nil ' readStream) ] raise: SCJsonSyntaxError.
]

{ #category : #testing }
SCMaterializerTests >> testParseErrors [
	self should: [ SCMaterializer materializeFromString:  'zero' ] raise: SCJsonSyntaxError.
	self should: [ SCMaterializer materializeFromString:  '#' ] raise: SCJsonSyntaxError.
	self should: [ SCMaterializer materializeFromString:  '@' ] raise: SCJsonSyntaxError.
	
	"SCMaterializer doesnt rise exception y the object is right serialized and ignores the rest of the stream"
	self shouldnt: [ (SCMaterializer materializeFrom: '[1,2,3]true' readStream) ] raise: SCJsonSyntaxError.
	self shouldnt: [ (SCMaterializer materializeFrom: '{"foo":1}"extra"' readStream)] raise: SCJsonSyntaxError.
	self shouldnt: [ (SCMaterializer materializeFrom: '[]"extra"' readStream) ] raise: SCJsonSyntaxError.
]
