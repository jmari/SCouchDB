Class {
	#name : #SCRenderException,
	#superclass : #SCViewServerException,
	#instVars : [
		'arrorCode',
		'arrorDescription'
	],
	#category : 'SCouchDB-ViewServer-Exceptions'
}

{ #category : #'as yet unclassified' }
SCRenderException >> errorType [
	^'Rendering error'
]
