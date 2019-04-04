Class {
	#name : #SCMissingFunction,
	#superclass : #SCViewServerException,
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCMissingFunction >> errorType [
	^ 'Function not found'
]
