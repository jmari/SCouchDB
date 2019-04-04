Class {
	#name : #SCRepository,
	#superclass : #VORepository,
	#instVars : [
		'indexForClass',
		'adaptor',
		'database',
		'uuidProvider',
		'sortingIndexes',
		'maxObjectsInMem'
	],
	#category : 'SCouchDB-Voyage'
}

{ #category : #'as yet unclassified' }
SCRepository class >> database: databaseString [
	|repo|
	repo :=self
				host: self defaultHost 
				port: self defaultPort.
		
	repo database: (repo adaptor ensureDatabase: databaseString).

	^ repo
	
]

{ #category : #'as yet unclassified' }
SCRepository class >> defaultHost [
	^ 'localhost'
]

{ #category : #'as yet unclassified' }
SCRepository class >> defaultPort [
	^  5984
]

{ #category : #'as yet unclassified' }
SCRepository class >> host: aHost port: aPort [ 
	| repo |
	repo := self new.
	repo adaptor: (SCAdaptor new host: aHost port: aPort ).
	^ repo
]

{ #category : #'as yet unclassified' }
SCRepository class >> host: aHost port: aPort userName:aUserName password:aPassword [
	| repo |
	repo := self new.
	repo adaptor: (SCAdaptor new host: aHost port: aPort userName:aUserName password:aPassword).
	^ repo
]

{ #category : #accessing }
SCRepository class >> platformIdentifier [
	self shouldBeImplemented
]

{ #category : #'as yet unclassified' }
SCRepository class >> userName:aUserName password:aPassword [

	^ self host: self defaultHost  port: self defaultPort  userName:aUserName password:aPassword
]

{ #category : #accessing }
SCRepository >> adaptor [
	^ adaptor 
]

{ #category : #accessing }
SCRepository >> adaptor: anAdaptor [
	adaptor := anAdaptor
]

{ #category : #persistence }
SCRepository >> commit: aBlock [
	self shouldBeImplemented
]

{ #category : #persistence }
SCRepository >> count: aClass [
	|app appName index|
	index := self indexForClassSortedBy:#().
	appName := (index ddoc findTokens: $/) at:2.
	app := self database applicationAt: appName.
	^ ((app view 
			name:index name;
			key: (Array with:aClass name) ;
			reduce;
			execute) at:1) at:'value'
]

{ #category : #persistence }
SCRepository >> count: aClass where: aWhereBlock [
	| index mq|
	"@todo we need to convert the where block to query parameters in order to call the view like count"
	mq := self database mangoQuery 
						selector:[:aDoc| (aDoc at:'#instanceOf') = aClass name];
						fields: #(#_id);
						limit: self maxObjectsInMem.
	aWhereBlock ifNotNil:[ mq selector: aWhereBlock].
	index := self indexForClassSortedBy: #().

	^ (mq	
		useIndex: index;
		execute) size
				
			
]

{ #category : #accessing }
SCRepository >> database [
	^ database ifNil:[ self database:	self defaultDatabaseName. database].
]

{ #category : #accessing }
SCRepository >> database: aDatabaseName [
	database := self adaptor ensureDatabase: aDatabaseName
]

{ #category : #accessing }
SCRepository >> defaultDatabaseName [
	^ #smalltalk_image
]

{ #category : #accessing }
SCRepository >> flushCache [
	self shouldBeImplemented
]

{ #category : #accessing }
SCRepository >> futureClass [
	self shouldBeImplemented
]

{ #category : #private }
SCRepository >> indexForClassSortedBy: arrayInSortSyntax [
	| oc |
	oc := Array with:'#instanceOf'withAll: arrayInSortSyntax.
		
	^ self sortingIndexes 
			at: oc asString 
			ifAbsentPut:[ self database index 
													name: oc asString;
													fields:  oc;
													new]
]

{ #category : #initialization }
SCRepository >> initialize [
	super initialize.

]

{ #category : #testing }
SCRepository >> isNew: anObject [ 
	"checks the revision field (HEAD is the most lighweight call)"
	| isNew |
	isNew := false.
	[self database documentCurrentRevAt: anObject ] on:SCError do:[ isNew := true ].
	^ isNew
 
]

{ #category : #accessing }
SCRepository >> lazyProxyClass [
	self shouldBeImplemented
]

{ #category : #accessing }
SCRepository >> maxObjectsInMem [
	^ maxObjectsInMem ifNil:[maxObjectsInMem := 65536]
]

{ #category : #accessing }
SCRepository >> maxObjectsInMem: anInteger [
	maxObjectsInMem := anInteger
]

{ #category : #persistence }
SCRepository >> remove: anObject [
	
	| uuid |
	uuid := self uuidProvider discoverIdFor: anObject.
	uuid ifNil:[ SCError signal:'Object does not have an ID.'].
	^ self database deleteDocument: uuid.
]

{ #category : #persistence }
SCRepository >> removeAll: aClass [
	
	| index objects |
	index := self indexForClassSortedBy:#().

	objects:= self database mangoQuery 
						selector:[:aDoc| (aDoc at:'#instanceOf') = aClass name];
						fields:#(#_id #_rev);
						useIndex: index;
						limit: self maxObjectsInMem;
						execute.
	
	^ self database bulkRemoveDocs: objects.
	

]

{ #category : #persistence }
SCRepository >> save: aDoc [

	self database documentPut:aDoc

]

{ #category : #persistence }
SCRepository >> selectAll: aClass [
	^ self selectMany: aClass where: nil sortBy: #() limit: self maxObjectsInMem
						  
]

{ #category : #persistence }
SCRepository >> selectAll: aClass sortBy: sortBlockOrArray [
	^ self selectMany: aClass where: nil sortBy: sortBlockOrArray limit: self maxObjectsInMem
]

{ #category : #persistence }
SCRepository >> selectMany: aClass where: aBlock [
	^ self selectMany: aClass where: aBlock sortBy: #() limit: self maxObjectsInMem
]

{ #category : #persistence }
SCRepository >> selectMany: aClass where: aWhereBlock sortBy: sortBlockOrArray [
	^ self selectMany: aClass where: aWhereBlock sortBy: sortBlockOrArray limit: self maxObjectsInMem
]

{ #category : #persistence }
SCRepository >> selectMany: aClass where: aWhereBlock sortBy: sortBlockOrArray limit: limit [
	^ self selectMany: aClass where: aWhereBlock  sortBy: sortBlockOrArray limit: limit offset: 0 
]

{ #category : #persistence }
SCRepository >> selectMany: aClass where: aWhereBlock sortBy: sortBlockOrArray limit: limit offset: offset [
	| index mq|
	
	"TO-DO: voyage object must be recursivelly completed "
	mq := self database mangoQuery 
						selector:[:aDoc| (aDoc at:'#instanceOf') = aClass name];
						limit: limit;
						skip: offset.
	aWhereBlock ifNotNil:[ mq selector: aWhereBlock].
	^ (sortBlockOrArray isKindOf: BlockClosure ) 
					ifTrue:  [ mq execute sort: sortBlockOrArray]
					ifFalse: [
							index := self indexForClassSortedBy: sortBlockOrArray.
						 	mq	
								useIndex: index;
								sort: (Array with:'#instanceOf' withAll:sortBlockOrArray);
								execute]
				
			
]

{ #category : #persistence }
SCRepository >> selectOne: aClass where: aWhereBlock [	
	| arr |
	arr:=(self selectMany: aClass where: aWhereBlock sortBy: #() limit: 1).
	^ arr size > 0
		ifTrue:[ arr at:1]
		ifFalse: [nil]
]

{ #category : #private }
SCRepository >> sortingIndexes [ 
	^ sortingIndexes ifNil:[sortingIndexes := Dictionary new]
			
]

{ #category : #accessing }
SCRepository >> uuidProvider [
	^ uuidProvider ifNil:[ uuidProvider := SCCouchUUIDProvider on:self database]
]
