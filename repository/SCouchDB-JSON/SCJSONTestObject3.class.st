Class {
	#name : #SCJSONTestObject3,
	#superclass : #SCJSONTestObject2,
	#instVars : [
		'color',
		'transparent'
	],
	#category : #'SCouchDB-JSON-Tests'
}

{ #category : #'instance creation' }
SCJSONTestObject3 class >> example1 [
	^ super example1
		data: (String new: 8 withAll: $a);
		color: 'red';
		transparent: true;
		yourself
]

{ #category : #accessing }
SCJSONTestObject3 class >> neoJsonMapping: mapper [
	"For inheritance mapping to work, the schema/classname must be self,
	but the instance variables have to be enumerated manually per class"
	
	super neoJsonMapping: mapper.
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(color transparent) ]
]

{ #category : #comparing }
SCJSONTestObject3 >> = anObject [
	^ super = anObject 
		and: [ color = anObject color
			and: [ transparent = anObject transparent ] ]
]

{ #category : #converting }
SCJSONTestObject3 >> asDictionary [
	^ super asDictionary
		at: #color put: color;
		at: #transparent put: transparent;
		yourself
]

{ #category : #accessing }
SCJSONTestObject3 >> color [
	^ color
]

{ #category : #accessing }
SCJSONTestObject3 >> color: anObject [
	color := anObject
]

{ #category : #accessing }
SCJSONTestObject3 >> transparent [
	^ transparent
]

{ #category : #accessing }
SCJSONTestObject3 >> transparent: anObject [
	transparent := anObject
]
