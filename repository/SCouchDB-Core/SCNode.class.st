Class {
	#name : #SCNode,
	#superclass : #Object,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #visiting }
SCNode >> cqAccept: aVisitor [
	^ aVisitor visitNode: self
]

{ #category : #accessing }
SCNode >> label [
	self subclassResponsibility 
]
