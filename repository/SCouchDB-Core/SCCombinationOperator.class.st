Class {
	#name : #SCCombinationOperator,
	#superclass : #SCOperator,
	#instVars : [
		'conditions'
	],
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'instance creation' }
SCCombinationOperator class >> condition: aCondition [
	^ self new
		condition: aCondition;
		yourself
]

{ #category : #'instance creation' }
SCCombinationOperator class >> conditions: aCollection [
	^ self new
		conditions: aCollection;
		yourself
]

{ #category : #accessing }
SCCombinationOperator >> conditions [
	^ conditions
]

{ #category : #accessing }
SCCombinationOperator >> conditions: aCollection [
	conditions := aCollection
]

{ #category : #visiting }
SCCombinationOperator >> cqAccept: aVisitor [
	^ aVisitor visitLogicalCondition: self
]
