Class {
	#name : #SCOrOperator,
	#superclass : #SCCombinationOperator,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #accessing }
SCOrOperator >> label [
	^ '$or'
]

{ #category : #'logical operation' }
SCOrOperator >> not [
	^ SCNorOperator conditions: self conditions
]

{ #category : #'logical operation' }
SCOrOperator >> | aCondition [
	^ SCOrOperator conditions: self conditions, { aCondition }
]
