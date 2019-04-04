Class {
	#name : #SCOperator,
	#superclass : #SCNode,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'logical operation' }
SCOperator >> & anOperator [
	^ SCAndOperator
		conditions: (Array with: self with: anOperator)
]

{ #category : #visiting }
SCOperator >> cqAccept: aVisitor [
	^ aVisitor visitOperator: self
]

{ #category : #'logical operation' }
SCOperator >> not [
	^ SCNotOperator condition: self
]

{ #category : #'logical operation' }
SCOperator >> | aCondition [
	^ SCOrOperator  
		conditions: (Array with: self with: aCondition)
]
