Class {
	#name : #SCNotOperator,
	#superclass : #SCCombinationOperator,
	#instVars : [
		'condition'
	],
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'instance creation' }
SCNotOperator class >> condition: aCondition [
	^ self new
		condition: aCondition;
		yourself
]

{ #category : #accessing }
SCNotOperator >> condition [
	^ condition
]

{ #category : #accessing }
SCNotOperator >> condition: anObject [
	condition := anObject
]

{ #category : #visiting }
SCNotOperator >> cqAccept: aVisitor [
	^ aVisitor visitNotCondition: self
]

{ #category : #accessing }
SCNotOperator >> label [
	^ '$not'
]
