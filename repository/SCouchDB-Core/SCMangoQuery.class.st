Class {
	#name : #SCMangoQuery,
	#superclass : #Dictionary,
	#instVars : [
		'database'
	],
	#category : 'SCouchDB-Core-MangoQueries'
}

{ #category : #'as yet unclassified' }
SCMangoQuery class >> onDatabase: aCouchDatabase [
	^ self new database: aCouchDatabase
]

{ #category : #accessing }
SCMangoQuery >> adaptor [
	^ self database adaptor
]

{ #category : #accessing }
SCMangoQuery >> command [
	^ '_find'
]

{ #category : #accessing }
SCMangoQuery >> database [
	^ database
]

{ #category : #accessing }
SCMangoQuery >> database: anObject [
	database := anObject
]

{ #category : #execution }
SCMangoQuery >> execute [
	| result jsonString |

	jsonString := self database plainSerializer serialize: self.


	result := self database adaptor post:
						(Array with: self database name with: self command)
						entity: ((ZnStringEntity 
										text:jsonString) contentType: ZnMimeType applicationJson ).
	
	^ result at:'docs'
]

{ #category : #accessing }
SCMangoQuery >> fields [
	^ self at:'fields' ifAbsent:[nil]
]

{ #category : #accessing }
SCMangoQuery >> fields: anArrayOfStrings [
		"{'field1 field2 ...} or
		 { {'field1' -> 'asc'} asDictionary}"
		 self at:'fields' put:anArrayOfStrings
]

{ #category : #accessing }
SCMangoQuery >> limit [
		"default limit is 25"
	^ 	 self at:'limit' ifAbsent:[25]
]

{ #category : #accessing }
SCMangoQuery >> limit: anInteger [
	"default limit is 25"
	 self at:'limit' put:anInteger
]

{ #category : #options }
SCMangoQuery >> query: aDictionary [
	self addAll: aDictionary
	
]

{ #category : #options }
SCMangoQuery >> selector [
	|selector |
	^ selector :=self at:'selector' ifAbsent: [nil].
	
]

{ #category : #options }
SCMangoQuery >> selector: aBlock [
	| selector |
	selector := self at:'selector'  
				ifPresent: [(self at:'selector') ]
				ifAbsent: [self at:'selector' put: (Dictionary new at:'$and' put:OrderedCollection new ;yourself)].
	(selector at:'$and') add: (SCQueryBuilder queryFor:aBlock);yourself			
	 
]

{ #category : #accessing }
SCMangoQuery >> skip [
	^ self at:'skip' ifAbsent: [nil]
]

{ #category : #accessing }
SCMangoQuery >> skip: anInteger [
	 self at:'skip' put:anInteger
]

{ #category : #options }
SCMangoQuery >> sort [
	^ self at:'sort' ifAbsent:[nil]
]

{ #category : #options }
SCMangoQuery >> sort: anArrayOfStrings [
		 self at:'sort' put:anArrayOfStrings
]

{ #category : #accessing }
SCMangoQuery >> useIndex [
	^ self at:'use_index' ifAbsent:[nil]
]

{ #category : #accessing }
SCMangoQuery >> useIndex: anIndex [
	"'design-doc' 'index_name'"
	self at:'use_index' put: (Array with:anIndex ddoc with:anIndex name)
]
