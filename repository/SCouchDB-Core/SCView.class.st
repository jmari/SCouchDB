Class {
	#name : #SCView,
	#superclass : #Object,
	#instVars : [
		'database',
		'app',
		'name'
	],
	#category : 'SCouchDB-Core-Application'
}

{ #category : #accessing }
SCView >> adaptor [
	^ self database adaptor
]

{ #category : #accessing }
SCView >> app [
	^ app
]

{ #category : #accessing }
SCView >> app: anObject [
	app := anObject
]

{ #category : #query }
SCView >> count: anInteger [
	
	self adaptor znClient queryAt: 'count' put: anInteger.
	
]

{ #category : #accessing }
SCView >> database [
	^ database
]

{ #category : #accessing }
SCView >> database: anObject [
	database := anObject
]

{ #category : #query }
SCView >> descending [
	"Return the documents in descending by key order. Default is false"
	self adaptor znClient queryAt: 'descending' put: true.
	
]

{ #category : #query }
SCView >> endKey: anObject [
	"Stop returning records when the specified key is reached. Optional"
	self adaptor znClient queryAt: 'endkey' put: (self database plainSerializer serialize:anObject).
	
]

{ #category : #query }
SCView >> endKeyDocId: anObject [
	"Stop returning records when the specified document ID is reached. Optional"
	self adaptor znClient queryAt: 'endkey_doc_id' put: anObject.
	
]

{ #category : #execute }
SCView >> execute [
	^ self database viewAt: self app appName named: self name

]

{ #category : #query }
SCView >> group [
	"group rows by its key"
	self adaptor znClient queryAt: 'group' put: true.
	
]

{ #category : #query }
SCView >> groupLevel: anInteger [
	"group rows by its key"
	self adaptor znClient queryAt: 'group_level' put: anInteger asString.
	
]

{ #category : #query }
SCView >> includeDocs [
	"Include the full content of the documents in the return. Default is false"
	self adaptor znClient queryAt: 'include_docs' put: true.
	
]

{ #category : #query }
SCView >> inclusiveEnd [
	"Specifies whether the specified end key should be included in the result. Default is true."
	self adaptor znClient queryAt: 'inclusive_end' put: true.
	
]

{ #category : #query }
SCView >> key: anObject [
	" Return only documents that match the specified key. Optional"
	self adaptor znClient queryAt: 'key' put: (self database plainSerializer serialize:anObject).
	
]

{ #category : #query }
SCView >> keys: anObject [
	"Return only documents that match the specified keys. Optional"
	self adaptor znClient queryAt: 'keys' put: (self database plainSerializer serialize:anObject).
	
]

{ #category : #query }
SCView >> limit: anInteger [
	"Limit the number of the returned documents to the specified number. Optional"
	self adaptor znClient queryAt: 'limit' put: anInteger.

]

{ #category : #accessing }
SCView >> name [
	^ name
]

{ #category : #accessing }
SCView >> name: anObject [
	name := anObject
]

{ #category : #query }
SCView >> queryAt: varName put: value [
	
	self adaptor znClient queryAt: varName put: value.
	
]

{ #category : #query }
SCView >> reduce [
	"group rows by its key"
	self adaptor znClient queryAt: 'reduce' put: true.
	
]

{ #category : #query }
SCView >> skip: anInteger [
	"Skip this number of records before starting to return the results. Default is 0"
	self adaptor znClient queryAt: 'skip' put: anInteger.

	
]

{ #category : #query }
SCView >> staleOk [
	"Allow the results from a stale view to be used, without triggering a rebuild of all views within the encompassing design doc. Supported values: ok and update_after"
	self adaptor znClient queryAt: #staleOk put: 'ok'.
	
]

{ #category : #query }
SCView >> staleUpdateAfter [
	"Allow the results from a stale view to be used, without triggering a rebuild of all views within the encompassing design doc. Supported values: ok and update_after"
	self adaptor znClient queryAt: 'stale' put: 'update_after'.
	
]

{ #category : #query }
SCView >> startKey: anObject [
	"Return records starting with the specified key. Optional"
	self adaptor znClient queryAt: 'startkey' put: (self database plainSerializer serialize:anObject).
	
]

{ #category : #query }
SCView >> startKeyDocId: anObject [
	"Return records starting with the specified document ID. Optional"
	self adaptor znClient queryAt: 'startkey_doc_id' put: anObject.
	
]
