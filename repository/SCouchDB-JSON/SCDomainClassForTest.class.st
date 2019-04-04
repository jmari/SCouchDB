Class {
	#name : #SCDomainClassForTest,
	#superclass : #Object,
	#instVars : [
		'a',
		'b',
		'c'
	],
	#category : 'SCouchDB-JSON-Tests'
}

{ #category : #accessing }
SCDomainClassForTest >> a [
	^ a
]

{ #category : #accessing }
SCDomainClassForTest >> a: anObject [
	a := anObject
]

{ #category : #accessing }
SCDomainClassForTest >> b [
	^ b
]

{ #category : #'as yet unclassified' }
SCDomainClassForTest >> initialize [
	super initialize.
	a := 1.
	b := self.
	c := { 'hola'->'hello'.
			'me'->self } asDictionary
]
