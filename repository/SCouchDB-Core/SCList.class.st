Class {
	#name : #SCList,
	#superclass : #SCView,
	#instVars : [
		'data',
		'sourceApp'
	],
	#category : 'SCouchDB-Core-Application'
}

{ #category : #accessing }
SCList >> data [
	^ data
]

{ #category : #accessing }
SCList >> data: anObject [
	data := anObject
]

{ #category : #'as yet unclassified' }
SCList >> execute [
	^ sourceApp 
			ifNil:[self database listAt: self app appName named: self name appliedTo: self data]
			ifNotNil:[self database listAt: self app appName named: self name appliedTo: self data inApp: self sourceApp]
]

{ #category : #accessing }
SCList >> sourceApp [
	^ sourceApp
]

{ #category : #accessing }
SCList >> sourceApp: anObject [
	sourceApp := anObject
]
