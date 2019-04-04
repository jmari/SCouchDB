Class {
	#name : #SCVisitor,
	#superclass : #Object,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #visiting }
SCVisitor >> visit: anObject [
	^ anObject cqAccept: self
]

{ #category : #visiting }
SCVisitor >> visitConditionOperator: aSCOperator [
	^ self visitOperator: aSCOperator
]

{ #category : #visiting }
SCVisitor >> visitEqualCondition: aSCCondition [
	^ self visitConditionOperator: aSCCondition
]

{ #category : #visiting }
SCVisitor >> visitField: aField [
	^ self visitNode: aField
]

{ #category : #visiting }
SCVisitor >> visitLogicalCondition: aLogicalCondition [
	^ self visitOperator: aLogicalCondition 
]

{ #category : #visiting }
SCVisitor >> visitNode: aSCNode [
	^ self visitObject: aSCNode
]

{ #category : #visiting }
SCVisitor >> visitNotCondition: aSCNotCondition [
	^ self visitOperator: aSCNotCondition
]

{ #category : #visiting }
SCVisitor >> visitObject: anObject [
]

{ #category : #visiting }
SCVisitor >> visitOperator: aSCOperator [
	^ self visitNode: aSCOperator
]

{ #category : #visiting }
SCVisitor >> visitWhereCondition: aWhereCondition [
	^ self visitOperator: aWhereCondition 
]
