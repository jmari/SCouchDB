Class {
	#name : #SCAndOperator,
	#superclass : #SCCombinationOperator,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'logical operation' }
SCAndOperator >> & aCondition [
	^ SCAndOperator conditions: self conditions, { aCondition }
]

{ #category : #accessing }
SCAndOperator >> label [
	^ '$and'
]

{ #category : #'logical operation' }
SCAndOperator >> not [
	^ self copy 
		conditions: (self conditions collect: [ :each | each not ]);
		yourself
]
