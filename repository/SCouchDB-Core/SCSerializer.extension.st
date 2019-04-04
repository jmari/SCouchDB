Extension { #name : #SCSerializer }

{ #category : #'*SCouchDB-Core' }
SCSerializer class >> on: anAdaptor [
	^ self new 
			uuidProvider: (SCCouchUUIDProvider on: anAdaptor)
]
