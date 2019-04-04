Class {
	#name : #SCSizeOperator,
	#superclass : #SCConditionOperator,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'logical operation' }
SCSizeOperator >> = anInteger [
	anInteger isInteger ifFalse: [ SCQueryError signal: 'Array size must be an Integer'].
	
	self right: anInteger
]

{ #category : #accessing }
SCSizeOperator >> label [
	^ '$size'
]
