Class {
	#name : #SCouchDBTests,
	#superclass : #TestCase,
	#instVars : [
		'couchdb',
		'host',
		'port'
	],
	#category : 'SCouchDB-Core-Tests'
}

{ #category : #utils }
SCouchDBTests >> couchdb [

	^ couchdb ifNil:[couchdb := SCAdaptor new host: self host port: self port userName:'admin' password:'admin'].

]

{ #category : #utils }
SCouchDBTests >> createDB [
	^ self couchdb ensureDatabase: self dbname.

]

{ #category : #utils }
SCouchDBTests >> createFreshDB [

	(self couchdb databases includes: self dbname) ifTrue: [
		self couchdb deleteDatabase: self dbname. ].
	^ self couchdb  createDatabase: self dbname
]

{ #category : #utils }
SCouchDBTests >> dbname [

	^  'scouch-test'
]

{ #category : #utils }
SCouchDBTests >> host [
	^ host ifNil: [ host := 'localhost']
]

{ #category : #utils }
SCouchDBTests >> host: aHostName [
	host := aHostName
]

{ #category : #'as yet unclassified' }
SCouchDBTests >> largeObject [
   | lo |
	lo := Array new:1000.
	1 to:1000 do:[:i | lo at:i put: self objects ].
	^ lo
]

{ #category : #tests }
SCouchDBTests >> objects [
	| dict  |
	dict := Dictionary new.
	dict at: '1' put: 10;
		at: 'foo' put: 'bar';
		at: 'table' put: #(4 5 6);
		at: 'bool' put: true.		
	^ dict
]

{ #category : #tests }
SCouchDBTests >> objectsAsDocuments [
	| dict |
	dict := Dictionary new.
	dict at: '1' put: 10;
		at: 'foo' put: 'bar';
		at: 'table' put: #(4 5 6);
		at: 'bool' put: true.		

	^ {
		#Array -> #(1 2 3) asOrderedCollection.
		#Point -> (1 @ 2).
		#Set -> #(1 2 3 4 true) asSet.
		"A json limitation: Dictionary keys should be strings"
		#Dictionary ->  dict .
	} asDictionary
]

{ #category : #utils }
SCouchDBTests >> port [
	^ port ifNil: [ 5984 ] 
]

{ #category : #utils }
SCouchDBTests >> port: aPortNum [
	port := aPortNum
]

{ #category : #'as yet unclassified' }
SCouchDBTests >> veryLargeObject [
   | lo |
	lo := Array new:100000.
	1 to:100000 do:[:i | lo at:i put: self objects ].
	^ lo
]
