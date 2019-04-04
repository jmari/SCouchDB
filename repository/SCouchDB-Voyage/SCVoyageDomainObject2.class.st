Class {
	#name : #SCVoyageDomainObject2,
	#superclass : #Object,
	#instVars : [
		'firstName',
		'address'
	],
	#category : 'SCouchDB-Voyage-Tests'
}

{ #category : #'as yet unclassified' }
SCVoyageDomainObject2 class >> isVoyageRoot [ 
	^ true
]

{ #category : #accessing }
SCVoyageDomainObject2 >> address [
	^ address
]

{ #category : #accessing }
SCVoyageDomainObject2 >> address: anObject [
	address := anObject
]

{ #category : #accessing }
SCVoyageDomainObject2 >> firstName [
	^ firstName
]

{ #category : #accessing }
SCVoyageDomainObject2 >> firstName: anObject [
	firstName := anObject
]
