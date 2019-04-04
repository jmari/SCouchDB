Extension { #name : #Object }

{ #category : #'*SCouchDB-Core' }
Object >> asSCApp [
	"we use the same procedure than Dictionary"
	^ self as: SCApp
]

{ #category : #'*SCouchDB-Core' }
Object >> asSCDocument [
	"we use the same procedure than Dictionary"
	^ self as: SCDocument 
]

{ #category : #'*SCouchDB-Core-MangoQueries' }
Object >> cqAccept: aVisitor [
	^ aVisitor visitObject: self
]

{ #category : #'*SCouchDB-Core' }
Object >> deleted [
	"mark the object as deleted in the cache"
	SCObjectsCache instance markAsdeleted:self
]
