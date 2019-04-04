Class {
	#name : #SCField,
	#superclass : #SCNode,
	#instVars : [
		'label'
	],
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'instance creation' }
SCField class >> labelled: aString [
	^ self new 
		initializeWithLabel: aString; 
		yourself
]

{ #category : #comparing }
SCField >> % anObject [
	^ SCModOperator new
		left: self;
		right: anObject;
		yourself
]

{ #category : #comparing }
SCField >> < anObject [
	^ SCLessThanOperator new
		left: self;
		right: anObject;
		yourself
]

{ #category : #comparing }
SCField >> <= anObject [
	^ SCLessThanEqualOperator new
		left: self;
		right: anObject;
		yourself
]

{ #category : #comparing }
SCField >> = anObject [
	^ SCEqualOperator new
		left: self;
		right: anObject;
		yourself
]

{ #category : #comparing }
SCField >> == anObject [
	^ SCTypeOperator new
		left: self;
		right: anObject;
		yourself
]

{ #category : #comparing }
SCField >> > anObject [
	^ SCGreaterThanOperator new
		left: self;
		right: anObject;
		yourself
]

{ #category : #comparing }
SCField >> >= anObject [
	^ SCGreaterThanEqualOperator new
		left: self;
		right: anObject;
		yourself
]

{ #category : #comparing }
SCField >> all: anArrayOfObjects [
	^ self includesAll: anArrayOfObjects
]

{ #category : #comparing }
SCField >> allMatches: aBlock [

	^ SCQueryBuilder new buildAllMatchFor: aBlock
		
]

{ #category : #'as yet unclassified' }
SCField >> at: aString [
	^ self label: self label ,'.', aString
]

{ #category : #visiting }
SCField >> cqAccept: aVisitor [
	^ aVisitor visitField: self
]

{ #category : #'as yet unclassified' }
SCField >> doesNotUnderstand: aMessage [
	^ aMessage selector isUnary
		ifTrue: [ self at: aMessage selector ]
		ifFalse: [ super doesNotUnderstand: aMessage ]
]

{ #category : #comparing }
SCField >> elementMatches: aBlock [

	^ SCQueryBuilder new buildElementMatchFor: aBlock
		
]

{ #category : #testing }
SCField >> includes: anObject [
	"Mongo doesn't use any special query for values in arrays"
	
	^ self = anObject
]

{ #category : #comparing }
SCField >> includesAll: anArrayOfObjects [
	^ SCAllOperator new
		left: self;
		right: anArrayOfObjects;
		yourself
]

{ #category : #initialization }
SCField >> initializeWithLabel: aString [
	label := aString
]

{ #category : #testing }
SCField >> isMemberOf: aClass [
	^ SCTypeOperator
		new  left: self;
		right: aClass name;
		yourself
]

{ #category : #comparing }
SCField >> isNil [ 
	^ SCEqualOperator new
		left: self;
		right: 'nul';
		yourself
]

{ #category : #accessing }
SCField >> label [
	^ label
]

{ #category : #'as yet unclassified' }
SCField >> label: aLabel [
	label:=aLabel
]

{ #category : #comparing }
SCField >> matches: aString [
	^ SCRegExpOperator new
		left: self;
		right: aString;
		yourself
]

{ #category : #testing }
SCField >> notIn: aCollection [
	^ SCNotInOperator new
		left: self;
		right: aCollection;
		yourself
]

{ #category : #comparing }
SCField >> notNil [ 
	^ SCNotEqualOperator new
		left: self;
		right: 'nul';
		yourself
]

{ #category : #'as yet unclassified' }
SCField >> respondsTo: aSymbol [
	^ SCExistsOperator new
		left: self;
		right: aSymbol;
		yourself
]

{ #category : #testing }
SCField >> size [
	^ SCSizeOperator
		new  left: self
]

{ #category : #testing }
SCField >> type [
	^ SCTypeOperator
		new  left: self
]

{ #category : #testing }
SCField >> where: aString [
	^ SCWhereCondition new
		javascript: aString;
		yourself
]

{ #category : #comparing }
SCField >> ~= anObject [
	^ SCNotEqualOperator new
		left: self;
		right: anObject;
		yourself
]
