Class {
	#name : #SCWhereCondition,
	#superclass : #SCOperator,
	#instVars : [
		'javascript'
	],
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'instance creation' }
SCWhereCondition class >> javascript: aString [
	^ self new
		javascript: aString;
		yourself
]

{ #category : #accessing }
SCWhereCondition >> javascript [
	^ javascript
]

{ #category : #accessing }
SCWhereCondition >> javascript: anObject [
	javascript := anObject
]

{ #category : #accessing }
SCWhereCondition >> label [
	^ ''
]

{ #category : #visiting }
SCWhereCondition >> mqAccept: aVisitor [
	^ aVisitor visitWhereCondition: self
]
