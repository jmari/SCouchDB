Class {
	#name : #SCQueryBuilder,
	#superclass : #Object,
	#instVars : [
		'label'
	],
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'instance creation' }
SCQueryBuilder class >> queryFor: aBlock [
	^ self new buildQueryFor: aBlock
]

{ #category : #building }
SCQueryBuilder >> buildAllMatchFor: aBlock [
	^ self newGenerator visit: (aBlock value: self newAllMatch)
]

{ #category : #building }
SCQueryBuilder >> buildElementMatchFor: aBlock [
	^ self newGenerator visit: (aBlock value: self newElementMatch)
]

{ #category : #building }
SCQueryBuilder >> buildQueryFor: aBlock [
	^ self newGenerator visit: (aBlock value: self newQuery)
]

{ #category : #factory }
SCQueryBuilder >> newAllMatch [
	^ SCAllMatch new
]

{ #category : #factory }
SCQueryBuilder >> newElementMatch [
	^ SCElementMatch new
]

{ #category : #factory }
SCQueryBuilder >> newGenerator [
	^ SCouchQueryGenerator new
]

{ #category : #factory }
SCQueryBuilder >> newQuery [
	^ SCQuery new
]
