Class {
	#name : #SCJSONMockStream,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #'instance creation' }
SCJSONMockStream class >> on: stream [
	^ self new
		stream: stream;
		yourself
]

{ #category : #testing }
SCJSONMockStream >> atEnd [
	^ stream atEnd
]

{ #category : #accessing }
SCJSONMockStream >> close [
	^ stream close
]

{ #category : #accessing }
SCJSONMockStream >> next [
	^ stream next
]

{ #category : #accessing }
SCJSONMockStream >> nextPut: character [
	^ stream nextPut: character
]

{ #category : #accessing }
SCJSONMockStream >> nextPutAll: string [
	^ stream nextPutAll: string
]

{ #category : #accessing }
SCJSONMockStream >> peek [
	^ stream peek
]

{ #category : #accessing }
SCJSONMockStream >> peekFor: char [
	^ stream peekFor: char
]

{ #category : #accessing }
SCJSONMockStream >> space [
	^ stream space
]

{ #category : #'initialize-release' }
SCJSONMockStream >> stream: anObject [
	stream := anObject
]
