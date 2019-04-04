Class {
	#name : #SCListException,
	#superclass : #SCFatalException,
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCListException >> errorType [
	^ 'list_error'
]
