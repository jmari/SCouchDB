Class {
	#name : #SCTypeOperator,
	#superclass : #SCConditionOperator,
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #visiting }
SCTypeOperator >> = aClass [ 
	
	self right: aClass name
]

{ #category : #accessing }
SCTypeOperator >> label [
	^ '$type'
]
