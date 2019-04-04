Class {
	#name : #SCMultiPartRelatedEntity,
	#superclass : #ZnEntity,
	#instVars : [
		'parts',
		'representation'
	],
	#category : 'SCouchDB-Core'
}

{ #category : #testing }
SCMultiPartRelatedEntity class >> designatedMimeType [
	^ ZnMimeType multiPartRelated  
]

{ #category : #testing }
SCMultiPartRelatedEntity class >> matches: mimeType [
	^ mimeType matches: 'multipart/*' asZnMimeType
]

{ #category : #accessing }
SCMultiPartRelatedEntity >> addPart: mimePart [
	self invalidateRepresentation.
	self parts add: mimePart
]

{ #category : #private }
SCMultiPartRelatedEntity >> computeRepresentation [
	representation := ByteArray streamContents: [ :stream | 
		self writeRepresentationOn: (ZnBivalentWriteStream on: stream) ].
	contentLength := representation size
]

{ #category : #accessing }
SCMultiPartRelatedEntity >> contentLength [
	contentLength isNil ifTrue: [ self computeRepresentation ].
	^ contentLength
]

{ #category : #accessing }
SCMultiPartRelatedEntity >> contentType: object [
	"We only allow assignment compatible with our designated mime type.
	The main/sub must be equal but the parameters must be allowed to be different"
	
	| newType |
	newType := object asZnMimeType.
	(self class matches: newType)
		ifTrue: [ contentType := newType ]
]

{ #category : #accessing }
SCMultiPartRelatedEntity >> contents [
	^ self parts
]

{ #category : #private }
SCMultiPartRelatedEntity >> generateBoundary [
	^ String streamContents: [ :stream | | letters |
			stream nextPutAll: 'Boundary-Zn-'.
			letters := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
			8 timesRepeat: [ stream nextPut: letters atRandom ] ]
	
]

{ #category : #accessing }
SCMultiPartRelatedEntity >> getBoundary [
	"Return the multipart/form-data MIME part boundary.
	This should really be there, set externally or internally.
	See #initialize and #mimeTypeWithBoundary"
	
	^ (self contentType parameterAt: 'boundary') withoutQuoting 
]

{ #category : #'initialize-release' }
SCMultiPartRelatedEntity >> initialize [
	super initialize.
	self contentType: self mimeTypeWithBoundary  
	
]

{ #category : #private }
SCMultiPartRelatedEntity >> invalidateRepresentation [
	representation := nil.
	contentLength := nil
]

{ #category : #testing }
SCMultiPartRelatedEntity >> isEmpty [
	^ parts isNil or: [ parts isEmpty ]
]

{ #category : #private }
SCMultiPartRelatedEntity >> mimeTypeWithBoundary [
	| mimeType |
	mimeType := self class designatedMimeType copy.
	mimeType parameterAt: 'boundary' put: self generateBoundary.
	^ mimeType
]

{ #category : #private }
SCMultiPartRelatedEntity >> parse: bytes boundary: boundary binary: binary [
	| next start fullBoundary |
	fullBoundary := '--' asByteArray, boundary.
	"Sometimes there is whitespace in front of the first boundary"
	start := (bytes
		indexOfSubCollection: fullBoundary
		startingAt: 1) + 1.
	next := bytes
		indexOfSubCollection: fullBoundary
		startingAt: start 
		ifAbsent: [ bytes size ].
	[ next < (bytes size - 2) ] whileTrue: [ | partReadStream |
		partReadStream := ReadStream on: bytes from: start + 2 to: next - 3.
		self addPart: (ZnMimePart perform: (binary ifTrue: [ #readBinaryFrom: ] ifFalse: [ #readFrom: ]) with: partReadStream).
		start := next + fullBoundary size.
		next := bytes
			indexOfSubCollection: fullBoundary
			startingAt: start
			ifAbsent: [ bytes size ] ]
]

{ #category : #accessing }
SCMultiPartRelatedEntity >> partNamed: fieldName [
	^ self partNamed: fieldName ifNone: [ self error: 'Cannot find part named ', fieldName asString ]
]

{ #category : #accessing }
SCMultiPartRelatedEntity >> partNamed: fieldName ifNone: block [
	parts isNil ifTrue: [ block value ].
	^ self parts detect: [ :each | each fieldName = fieldName ] ifNone: block
]

{ #category : #accessing }
SCMultiPartRelatedEntity >> parts [
	parts isNil ifTrue: [ parts := OrderedCollection new ].
	^ parts
]

{ #category : #enumerating }
SCMultiPartRelatedEntity >> partsDo: block [
	parts isNil ifTrue: [ ^ self ].
	parts do: block  
]

{ #category : #printing }
SCMultiPartRelatedEntity >> printContentsOn: stream [
	super printContentsOn: stream.
	self isEmpty
		ifTrue: [ ^ self ].
	stream space.
	self parts printElementsOn: stream
]

{ #category : #'initialize-release' }
SCMultiPartRelatedEntity >> readBinaryFrom: stream [
	"Switch to streaming implementation later on"
	
	| bytes |
	"We have to use the contentLength instance variable instead of the accessor else a representation will be computed"
	contentLength isNil
		ifTrue: [ 
			bytes := ZnUtils readUpToEnd: stream limit: ZnConstants maximumEntitySize ]
		ifFalse: [
			self contentLength > ZnConstants maximumEntitySize ifTrue: [ ZnEntityTooLarge signal ].
			bytes := ByteArray ofSize: contentLength.
			stream next: contentLength into: bytes ].
	self parse: bytes boundary: self getBoundary asByteArray binary: true
]

{ #category : #'initialize-release' }
SCMultiPartRelatedEntity >> readFrom: stream [
	"Switch to streaming implementation later on"
	
	| bytes |
	"We have to use the contentLength instance variable instead of the accessor else a representation will be computed"
	contentLength isNil
		ifTrue: [ 
			bytes := ZnUtils readUpToEnd: stream limit: ZnConstants maximumEntitySize ]
		ifFalse: [
			self contentLength > ZnConstants maximumEntitySize ifTrue: [ ZnEntityTooLarge signal ].
			bytes := ByteArray ofSize: contentLength.
			stream next: contentLength into: bytes ].
	self parse: bytes boundary: self getBoundary asByteArray binary: false
]

{ #category : #writing }
SCMultiPartRelatedEntity >> writeOn: stream [
	"We always go via our representation because we need a bivalent stream"
	
	representation isNil ifTrue: [ self computeRepresentation ].
	ZnUtils nextPutAll: representation on: stream
]

{ #category : #writing }
SCMultiPartRelatedEntity >> writeRepresentationOn: stream [
	| boundary |
	boundary := self getBoundary.
	self parts do: [ :each |
		stream nextPutAll: '--'; nextPutAll: boundary; nextPutAll: String crlf.
		stream nextPutAll: 'Content-Type: '; nextPutAll:  each contentType asString; nextPutAll: String crlf; nextPutAll: String crlf.
		each writeOn: stream.
		stream nextPutAll: String crlf ].
	stream nextPutAll: '--'; nextPutAll: boundary; nextPutAll: '--'

]
