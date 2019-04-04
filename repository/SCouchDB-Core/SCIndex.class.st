Class {
	#name : #SCIndex,
	#superclass : #Dictionary,
	#instVars : [
		'database'
	],
	#category : 'SCouchDB-Core-Indexes'
}

{ #category : #'as yet unclassified' }
SCIndex class >> onDatabase: aCouchDatabase [
	^ self new database: aCouchDatabase
]

{ #category : #accessing }
SCIndex >> adaptor [
	^ self database adaptor
]

{ #category : #'as yet unclassified' }
SCIndex >> command [
	^ '_index'
]

{ #category : #accessing }
SCIndex >> database [
	^ database
]

{ #category : #accessing }
SCIndex >> database: anObject [
	database := anObject
]

{ #category : #accessing }
SCIndex >> ddoc [
	^ self at:'ddoc' ifAbsent:[nil]
]

{ #category : #accessing }
SCIndex >> ddoc: anStrings [
	self at:'ddoc' put:anStrings
]

{ #category : #operations }
SCIndex >> delete: index [
	| path result |


	path :=  Array with:self database name with: '_index' with: index ddoc with:'json' with:index name.
		
	result := self adaptor delete:	path.
	^ result 
]

{ #category : #accessing }
SCIndex >> fields [
	^ self at:'index' ifPresent:[ (self at:'index') at:#fields ifAbsent:[nil]]
]

{ #category : #accessing }
SCIndex >> fields: anArrayOfStrings [
	self at:'index' put: (Dictionary new at:#fields put:anArrayOfStrings;yourself)
]

{ #category : #operations }
SCIndex >> get [
	^ self adaptor get: (Array with: self database name with:'_index')

]

{ #category : #accessing }
SCIndex >> index [
	^ self at:'index' ifAbsent:[nil]
]

{ #category : #accessing }
SCIndex >> index: aDictionary [
	self at:'index' put: aDictionary
]

{ #category : #accessing }
SCIndex >> name [
	^ self at:'name' ifAbsent:[nil]
]

{ #category : #accessing }
SCIndex >> name: anStrings [
	self at:'name' put:anStrings
]

{ #category : #operations }
SCIndex >> new [
	| jsonString result|

	jsonString := self database plainSerializer serialize: self.


	result:= self adaptor  post:(Array with:self database name with: self command)
						entity: ((ZnStringEntity 
										text:jsonString) contentType: ZnMimeType applicationJson ).
	self ddoc: (result at:'id').
	self name: (result at:'name').
	^ self 
]
