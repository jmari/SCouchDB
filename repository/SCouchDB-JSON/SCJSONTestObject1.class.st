Class {
	#name : #SCJSONTestObject1,
	#superclass : #Object,
	#instVars : [
		'id',
		'name',
		'timestamp',
		'points',
		'bytes'
	],
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #examples }
SCJSONTestObject1 class >> example1 [
	^ self new
		id: 123;
		name: 'Example1';
		timestamp: (DateAndTime year: 2012 month: 06 day: 08 hour: 14 minute: 30 second: 15 offset: 1 hour);
		points: (Array with: 1@2 with: 3@4);
		bytes: #[ 2 4 6 8 ];
		yourself
]

{ #category : #comparing }
SCJSONTestObject1 >> = anObject [
	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ id = anObject id
		and: [
			name = anObject name
				and: [
					timestamp = anObject timestamp
						and: [
							points = anObject points
								and: [ bytes = anObject bytes ] ] ] ]
]

{ #category : #accessing }
SCJSONTestObject1 >> bytes [
	^ bytes
]

{ #category : #accessing }
SCJSONTestObject1 >> bytes: byteArray [
	bytes := byteArray
]

{ #category : #accessing }
SCJSONTestObject1 >> hash [
	^ id hash bitXor: (name hash bitXor: (timestamp hash bitXor: (points hash bitXor: bytes hash)))
]

{ #category : #accessing }
SCJSONTestObject1 >> id [
	^ id
]

{ #category : #accessing }
SCJSONTestObject1 >> id: integer [
	id := integer
]

{ #category : #accessing }
SCJSONTestObject1 >> name [
	^ name
]

{ #category : #accessing }
SCJSONTestObject1 >> name: string [
	name := string
]

{ #category : #accessing }
SCJSONTestObject1 >> points [
	^ points
]

{ #category : #accessing }
SCJSONTestObject1 >> points: arrayOfPoints [
	points := arrayOfPoints 
]

{ #category : #accessing }
SCJSONTestObject1 >> timestamp [
	^ timestamp
]

{ #category : #accessing }
SCJSONTestObject1 >> timestamp: dateAndTime [ 
	timestamp := dateAndTime 
]
