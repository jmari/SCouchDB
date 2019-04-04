"
SCObjectsCache  
a singleton class variable accessible at ""instance"" class method. 
It maintains a key value  index  for uuid-->Instance and another index instance-->uuid, it also keeps the revision of an object. Each time an object is saved/readed from couchdb this revision field is updated.


    Instance Variables
	compactLimit:		anInteger, when this value is overflooded the compact method is called
	mutex:		Mutex for mutual exclusion.
	objects:		<uuid --> Object>  WeakValueDictionary
	reversedObjects:		<object --> uuid>  WeakIdentityKeyDictionary
	versions:		<uuid --> version>  Dictionary


"
Class {
	#name : #SCObjectsCache,
	#superclass : #Object,
	#instVars : [
		'compactLimit',
		'objects',
		'reversedObjects',
		'versions',
		'mutex'
	],
	#classInstVars : [
		'couchCache'
	],
	#category : 'SCouchDB-JSON'
}

{ #category : #defaults }
SCObjectsCache class >> defaultCompactLimit [ 
	^	5000
]

{ #category : #'as yet unclassified' }
SCObjectsCache class >> instance [
	^ couchCache ifNil:[ 
			couchCache := self basicNew.
			couchCache initialize]
]

{ #category : #defaults }
SCObjectsCache class >> maximumCompactLimit [ 
	^200000
]

{ #category : #defaults }
SCObjectsCache class >> minimumCompactLimit [ 
	^50000
]

{ #category : #'instance creation' }
SCObjectsCache class >> new [
	self error:'Singleton class, access using #instance class method'
]

{ #category : #'as yet unclassified' }
SCObjectsCache class >> new: anObject [
	self new
]

{ #category : #'as yet unclassified' }
SCObjectsCache class >> reset [
	couchCache := nil
]

{ #category : #accessing }
SCObjectsCache >> at: anUUID [
	anUUID isArray ifTrue: [^ self at: ((anUUID at:1),'/',(anUUID at:2)) ].
	^ self at: anUUID ifAbsent: [ nil ]
]

{ #category : #accessing }
SCObjectsCache >> at: anUUID ifAbsent: aBlock [

	^ objects at: anUUID ifAbsent:[ aBlock value]
]

{ #category : #accessing }
SCObjectsCache >> at: anUUID put: anObject [ 
	anUUID isArray ifTrue: [^ self at: ((anUUID at:1),'/',(anUUID at:2)) put: anObject ].
	self compactIfNeeded.
	self mutex critical: [ 
		reversedObjects at: anObject ifAbsent:[
					objects at: anUUID put: anObject.
					reversedObjects at: anObject put:anUUID.
					versions removeKey: anUUID ifAbsent:[nil]]]
]

{ #category : #accessing }
SCObjectsCache >> at: anUUID putRevision: aNumber [
	anUUID isArray ifTrue: [^ self at: ((anUUID at:1),'/',(anUUID at:2)) putRevision: aNumber ].
	self mutex critical: [ 
		versions at: anUUID put: aNumber ]
]

{ #category : #private }
SCObjectsCache >> compactIfNeeded [ 
	objects size > self compactLimit
		ifTrue: [ 
			self mutex critical: [ self performCompact ]. 
			self recalculateCompactLimit ].
			
]

{ #category : #accessing }
SCObjectsCache >> compactLimit [ 
	^compactLimit ifNil: [ compactLimit := self class defaultCompactLimit ]
]

{ #category : #accessing }
SCObjectsCache >> compactLimit: aNumber [
	compactLimit := aNumber
]

{ #category : #accessing }
SCObjectsCache >> flush [
	self mutex critical: [
		objects := WeakValueDictionary new.
		reversedObjects := WeakIdentityKeyDictionary new.
		versions := Dictionary new.
		self compactLimit: self class minimumCompactLimit ].
]

{ #category : #removing }
SCObjectsCache >> flush: anObject [
	| oid o |
	self mutex critical: [ 
		oid := (self keyAtValue: anObject).
		o := self at:oid.
		(o = #deleted ) ifTrue:[
			objects removeKey: oid ifAbsent: [].
			reversedObjects removeKey: anObject ifAbsent: [].
			versions removeKey: oid ifAbsent: [] ]]
]

{ #category : #initialization }
SCObjectsCache >> initialize [ 
	super initialize.
	mutex := Mutex new. 
	self flush.
]

{ #category : #accessing }
SCObjectsCache >> keyAtValue: anObject [
	^ self keyAtValue: anObject ifAbsent: [ nil ]
]

{ #category : #accessing }
SCObjectsCache >> keyAtValue: anObject ifAbsent: aBlock [
	^ reversedObjects at: anObject ifAbsent: aBlock
]

{ #category : #accessing }
SCObjectsCache >> markAsdeleted: anObject [
	| uuid |
	uuid := self keyAtValue: anObject.
	mutex critical:[
		objects at: uuid put: #deleted]
]

{ #category : #private }
SCObjectsCache >> mutex [ 
	^ mutex 
]

{ #category : #private }
SCObjectsCache >> performCompact [ 
	| deadKeys |
	
	deadKeys := Set new.
	objects keysAndValuesDo:  [ :key :value | 
		((value isNil) | (value = #deleted)) ifTrue: [ deadKeys add: key ] ].
	deadKeys do: [ :each | 
		objects removeKey: each ifAbsent:[].
		versions removeKey: each ifAbsent:[]].
	objects compact.
	reversedObjects finalizeValues; compact.
	versions compact.
	
]

{ #category : #printing }
SCObjectsCache >> printOn: aStream [
	aStream 
		nextPutAll: 'Cache';
		nextPut: $(;
		nextPutAll: objects size asString;
		space;
		nextPutAll: 'objects';
		nextPut: $).
]

{ #category : #private }
SCObjectsCache >> recalculateCompactLimit [ 
	| occupiedPercent newSize |
	occupiedPercent := (objects size * 100) / self compactLimit.
	
	(occupiedPercent >= 85) 
		ifTrue: [ 
			newSize := self compactLimit  + (self compactLimit * 20 / 100) truncated.
			self compactLimit: (newSize min: self class maximumCompactLimit) ].

	(occupiedPercent <= 50)
		ifTrue: [ 
			newSize := self compactLimit  - (self compactLimit * 20 / 100) truncated.
			self compactLimit: (newSize max: self class minimumCompactLimit  )]
]

{ #category : #removing }
SCObjectsCache >> removeValue: anObject [
	| oid |
	self mutex critical: [ 
		oid := (self keyAtValue: anObject) .
		objects removeKey: oid ifAbsent: [].
		reversedObjects removeKey: anObject ifAbsent: [].
		versions removeKey: oid ifAbsent: [] ]
]

{ #category : #accessing }
SCObjectsCache >> revisionAt: anUUID [

	^ versions at: anUUID ifAbsent: [ nil ]
]
