Class {
	#name : #SCConditionOperator,
	#superclass : #SCOperator,
	#instVars : [
		'left',
		'right'
	],
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'instance creation' }
SCConditionOperator class >> left: aField right: anotherField [
	^ self new
		left: aField;
		right: anotherField;
		yourself
]

{ #category : #visiting }
SCConditionOperator >> cqAccept: aVisitor [
	^ aVisitor visitConditionOperator: self
]

{ #category : #accessing }
SCConditionOperator >> left [
	^ left
]

{ #category : #accessing }
SCConditionOperator >> left: anObject [
	left := anObject
]

{ #category : #accessing }
SCConditionOperator >> right [
	^ right
]

{ #category : #accessing }
SCConditionOperator >> right: anObject [
	right := anObject
]
