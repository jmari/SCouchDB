Class {
	#name : #SCDdocNotFoundException,
	#superclass : #SCFatalException,
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCDdocNotFoundException >> errorType [
	^ 'query_protocol_error'
]
