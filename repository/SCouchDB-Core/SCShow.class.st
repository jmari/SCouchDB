Class {
	#name : #SCShow,
	#superclass : #SCList,
	#category : 'SCouchDB-Core-Application'
}

{ #category : #'as yet unclassified' }
SCShow >> execute [
	^ self database showAt: self app appName named: self name appliedTo: self data
]
