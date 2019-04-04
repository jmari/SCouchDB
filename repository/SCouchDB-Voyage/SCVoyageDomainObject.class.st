Class {
	#name : #SCVoyageDomainObject,
	#superclass : #Object,
	#instVars : [
		'firstName',
		'address'
	],
	#category : 'SCouchDB-Voyage-Tests'
}

{ #category : #'as yet unclassified' }
SCVoyageDomainObject class >> isVoyageRoot [ 
	^ true
]

{ #category : #accessing }
SCVoyageDomainObject >> address [
	^ address
]

{ #category : #accessing }
SCVoyageDomainObject >> address: anObject [
	address := anObject
]

{ #category : #accessing }
SCVoyageDomainObject >> firstName [
	^ firstName
]

{ #category : #accessing }
SCVoyageDomainObject >> firstName: anObject [
	firstName := anObject
]
