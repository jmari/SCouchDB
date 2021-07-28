Class {
	#name : #SCQuery,
	#superclass : #Object,
	#instVars : [
		'label'
	],
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #accessing }
SCQuery >> at: aString [

	^ self fieldNamed: aString asString
]

{ #category : #forwarding }
SCQuery >> doesNotUnderstand: aMessage [
	^ aMessage selector isUnary
		ifTrue: [ self at: aMessage selector ]
		ifFalse: [ super doesNotUnderstand: aMessage ]
]

{ #category : #accessing }
SCQuery >> fieldNamed: aString [
	^ SCField labelled: aString
]

{ #category : #forwarding }
SCQuery >> name [
	^ self at: 'name'
]

{ #category : #comparing }
SCQuery >> respondsTo: aSymbol [
	^ SCExistsOperator new
		left:self;
		right: aSymbol;
		yourself
]

{ #category : #accessing }
SCQuery >> where: aString [
	^ SCWhereCondition javascript: aString
]
