Class {
	#name : #SCEventlyQuery,
	#superclass : #SCJsonObject,
	#category : 'SCouchDB-Deprecated-Evently-Core'
}

{ #category : #'as yet unclassified' }
SCEventlyQuery >> descending: aBoolean [
	self at:'descending' put:aBoolean
]

{ #category : #'as yet unclassified' }
SCEventlyQuery >> limit: anInteger [
	self at:'limit' put: anInteger
]

{ #category : #'as yet unclassified' }
SCEventlyQuery >> view: aViewName [
	self at:'view' put:aViewName
]
