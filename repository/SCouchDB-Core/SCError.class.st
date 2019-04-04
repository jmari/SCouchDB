Class {
	#name : #SCError,
	#superclass : #Error,
	#instVars : [
		'object'
	],
	#category : 'SCouchDB-Core'
}

{ #category : #accessing }
SCError >> object [
	^ object
]

{ #category : #accessing }
SCError >> object: anObject [
	object := anObject
]
