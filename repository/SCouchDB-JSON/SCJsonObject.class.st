Class {
	#name : #SCJsonObject,
	#superclass : #Dictionary,
	#classInstVars : [
		'pool'
	],
	#category : #'SCouchDB-JSON-Core'
}

{ #category : #'instance creation' }
SCJsonObject class >> fromAssociations: collectionOfAssociations [

	| result |
	result := self new.
	
	collectionOfAssociations do: [:each |
		result at: each key  put: (
				self pool at: each value 
					ifPresent:[self pool at: each value]
					ifAbsentPut:[ each value asSCJsonObject ])
		].
	^ result
]

{ #category : #'instance creation' }
SCJsonObject class >> fromCollection: collection [

	| result |
	((collection size >= 1) and:[collection first isKindOf: Association ]) ifTrue:[^self fromAssociations:collection].
	result := Array new: collection size.
	
	collection doWithIndex: [:each :index |
		result at: index put:  (
				self pool at: each 
					ifPresent:[self pool at:each]
					ifAbsentPut:[ each asSCJsonObject ])
		].
	^ result
]

{ #category : #'instance creation' }
SCJsonObject class >> fromDictionary: aDictionary [

	| result |
	result := self new.
	
	aDictionary keysAndValuesDo: [:k :v|
		result at: k  put: (
				self pool at:k 
					ifPresent:[self pool at:k]
					ifAbsentPut:[ v asSCJsonObject ])
		].
	^ result
]

{ #category : #'instance creation' }
SCJsonObject class >> newFrom: anObject [

	| jsonObj |
	self pool removeAll.
	(anObject isKindOf: String ) ifTrue:[ ^ anObject]	.
	(anObject isKindOf: Boolean ) ifTrue:[ ^ anObject].		
	(anObject isKindOf: Number ) ifTrue:[ ^ anObject].
	
	^ (anObject isKindOf: Dictionary )
			ifTrue:[ self fromDictionary: anObject]
			ifFalse:[ 
				(anObject isKindOf: Collection )
					ifTrue: [  self fromCollection: anObject ]
					ifFalse: [ 
						jsonObj := self new.
						anObject class allInstVarNames do:[ :aiName|
							jsonObj at:aiName put: (anObject instVarNamed:aiName ) asSCJsonObject].
					jsonObj]]
]

{ #category : #accessing }
SCJsonObject class >> pool [
	^ pool ifNil:[ pool := WeakIdentityKeyDictionary  new ]
]

{ #category : #converting }
SCJsonObject >> asString [
	^ SCSerializer serialize: self
]

{ #category : #accessing }
SCJsonObject >> at: aKey [

	"make it work more like javascript objects"
	^ self at: aKey ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
SCJsonObject >> doesNotUnderstand: aMessage [
	| key |
	key := aMessage selector.
	key isUnary ifTrue: [^ self at: key ifAbsent: [nil]].
	^ (key isKeyword and: [(key occurrencesOf: $:) = 1])
		ifTrue: [key := key allButLast asSymbol.
				self at: key put: aMessage arguments first]
		ifFalse: [super doesNotUnderstand: aMessage]
				
	
]

{ #category : #testing }
SCJsonObject >> isSCJsonObject [ 
	^ true
]

{ #category : #accessing }
SCJsonObject >> name [
"override 'cause Object defines this"
	^self at: 'name'
]

{ #category : #accessing }
SCJsonObject >> value [
"override 'cause Object defines this"
	^self at: 'value'
]

{ #category : #accessing }
SCJsonObject >> valuesIn: anArrayOfSymbol [
	|values|
	values :=Array new: anArrayOfSymbol size.
	anArrayOfSymbol doWithIndex: [ :k :i |
		values at:i put:(self at:k) asString
		].
	^ values
]
