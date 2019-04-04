Extension { #name : #ZnMimeType }

{ #category : #'*SCouchDB-Core' }
ZnMimeType class >> multiPartRelated [
	^ self main: 'multipart' sub: 'related'
]
