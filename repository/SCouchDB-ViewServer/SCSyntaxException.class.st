Class {
	#name : #SCSyntaxException,
	#superclass : #SCViewServerException,
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCSyntaxException >> errorType [
	^'Compilation error'
]
