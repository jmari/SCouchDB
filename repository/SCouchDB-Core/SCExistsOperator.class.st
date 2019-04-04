Class {
	#name : #SCExistsOperator,
	#superclass : #SCConditionOperator,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'as yet unclassified' }
SCExistsOperator >> cqAccept: aVisitor [
	^ aVisitor visitExistsCondition: self
]

{ #category : #accessing }
SCExistsOperator >> label [
	^ '$exists'
]
