"
The unauthorized error mostly acts like forbidden one, but with the meaning of please authorize first. This small difference helps end users to understand what they can do to solve the problem. CouchDB doesn’t log it at “error” level, but returns HTTP 401 Unauthorized response with error information object.

"
Class {
	#name : #SCUnauthorizedException,
	#superclass : #SCViewServerException,
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCUnauthorizedException >> errorType [
	^'Permissions error'
]
