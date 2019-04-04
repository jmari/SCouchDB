Class {
	#name : #SCEqualOperator,
	#superclass : #SCConditionOperator,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #visiting }
SCEqualOperator >> cqAccept: aVisitor [
	^ aVisitor visitEqualCondition: self
]

{ #category : #accessing }
SCEqualOperator >> label [
	^ '$eq'
]

{ #category : #'logical operation' }
SCEqualOperator >> not [

	^ SCNotEqualOperator left: self left right: self right
]
