Class {
	#name : #SCRuntimeException,
	#superclass : #SCViewServerException,
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCRuntimeException >> errorType [
	^'Runtime error'
]
