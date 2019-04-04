Class {
	#name : #SCViewServerException,
	#superclass : #Exception,
	#instVars : [
		'errorType'
	],
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCViewServerException >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	UnhandledError signalForException: self
]

{ #category : #'as yet unclassified' }
SCViewServerException >> errorType [
	^ self subclassResponsibility 
]
