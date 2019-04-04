"
The forbidden error is widely used by Validate Document Update Functions to stop further function processing and prevent on disk store of the new document version. Since this error actually is not an error, but an assertion against user actions, CouchDB doesn’t log it at “error” level, but returns HTTP 403 Forbidden response with error information object.

- errorType  

"
Class {
	#name : #SCForbiddenException,
	#superclass : #SCViewServerException,
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCForbiddenException >> errorType [
	^'Permissions error'
]
