"
By default the changes feed emits all database documents changes. But if you’re waiting for some special changes, processing all documents is inefficient.

Filters are special design document functions that allow the changes feed to emit only specific documents that pass filter rules.

    Instance Variables
	serializer:		used to serialize to objects to JSON
	server:		SCViewServer processing this filter
	viewEmit:		true if a view calls emit:

View filters are the same as classic filters above, with one small difference: they use the map instead of the filter function of a view, to filter the changes feed. Each time a key-value pair is emitted from the map function, a change is returned. This allows avoiding filter functions that mostly do the same work as views.
"
Class {
	#name : #SCFilter,
	#superclass : #Object,
	#instVars : [
		'server',
		'viewEmit',
		'serializer'
	],
	#category : 'SCouchDB-ViewServer'
}

{ #category : #'as yet unclassified' }
SCFilter class >> on:aViewServer [
"We need to know the server instance to send print messages"
	| a |
	super initialize.
	a:=self new.
	a server:aViewServer.
	^a

]

{ #category : #runner }
SCFilter >> doNotReturnAnything [
 ^ nil
]

{ #category : #runner }
SCFilter >> respond:aJsonObj [
"test function"
	server println:(self serializer  serialize:aJsonObj)
]

{ #category : #runner }
SCFilter >> runFilter:fun ddoc:ddoc args:args [
	|results docs req |
	results:= Stack new.
	docs:=(args at:1).
	req:=(args at:2).
	docs do:[:aDoc|
		results push:( fun valueWithEnoughArguments:(Array 
													with:aDoc
													with: req) )].
	self respond:(Array with:true with:results).
	^ self doNotReturnAnything 

]

{ #category : #runner }
SCFilter >> runFilterView:fun ddoc:ddoc args:args [
"recompile"
	|results  docs |
	results:= Stack new.

	docs:=args at:1.

	docs do:[:doc|
		viewEmit:=false.
		fun valueWithEnoughArguments:args.
		results push:(self viewEmit).
		self viewEmit:false ].
	self respond:(Array with:true with:results).
	^ self doNotReturnAnything 

]

{ #category : #'as yet unclassified' }
SCFilter >> serializer [
	^ serializer ifNil:[ serializer := SCSerializer new serializeAllCollectionsAsArrays ]
]

{ #category : #accessing }
SCFilter >> server [
	^ server
]

{ #category : #accessing }
SCFilter >> server: anObject [
	server := anObject
]

{ #category : #accessing }
SCFilter >> viewEmit [
	^ viewEmit
]

{ #category : #accessing }
SCFilter >> viewEmit: anObject [
	viewEmit := anObject
]
