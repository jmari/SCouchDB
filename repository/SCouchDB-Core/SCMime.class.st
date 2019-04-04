Class {
	#name : #SCMime,
	#superclass : #Object,
	#instVars : [
		'mimeFuns',
		'providesUsed',
		'responseContentType',
		'mimeParser',
		'server',
		'keysByMime',
		'mimesByKey'
	],
	#category : 'SCouchDB-Core'
}

{ #category : #'as yet unclassified' }
SCMime >> bestKeyForRequest:req [
	| supportedMimes bestFun bestKey accept mimeKey |

	supportedMimes:=OrderedCollection new.
	bestFun:=nil.
	bestKey:=nil.
	accept:=(req at:'headers') at:'Accept'.
	(req at:'query') ifNil:[
		accept ifNotNil:[
			mimeFuns reverse do:[:mimeFun|
				mimeKey:=mimeFun first.
				(self mimesByKey:mimeKey) 
						ifNotNil:[ supportedMimes add:(self mimesByKey:mimeKey) ]].
			responseContentType := mimeParser bestMatch:supportedMimes header:accept.
			bestKey:=self keyByMime: responseContentType.
		] ifNil:[
			bestKey:=(mimeFuns first) first.
			responseContentType:= (self mimesByKey:bestKey) first ]]
	ifNotNil:[
		bestKey:=(mimeFuns first) first.
		responseContentType:= (self mimesByKey:bestKey) first.
		((req at:'query') at:'format') ifNotNil:[
			bestKey:=((req at:'query') at:'format').
			responseContentType:= (self mimesByKey:bestKey) first]].
	
	^ bestKey 
]

{ #category : #initalize }
SCMime >> initialize [
	super initialize.
	providesUsed:=false.
	mimeFuns:=OrderedCollection new.
	keysByMime := SCJsonObject new.
	mimesByKey := SCJsonObject new.
	mimeParser:=SCMimeParser new.
	self registerType:'all' type:'*/*'.
	self registerType:'text' type:'text/plain; charset=utf-8' type:'txt'.
	self registerType:'html' type:'text/html; charset=utf-8'.
	self registerType:'xhtml' type:'application/xhtml;+xml' type:'xhtml'.
	self registerType:'xml' type:'application/xml' type:'text/xml' 	type:'application/x-xml'.
	self registerType:'js' type:'text/javascript' type:'application/javascript' 	type:'application/x-javascript'.
	self registerType:'css' type:'text/css'.
	self registerType:'ics' type:'text/calendar'.
	self registerType:'csv' type:'text/csc'.
	self registerType:'rss' type:'application/rss+xml'.
	self registerType:'atom' type:'application/atom+xml'.
	self registerType:'yaml' type:'application/yaml' type:'text/yaml'.
	self registerType:'multipart_form' type:'multipart/form-data'.
	self registerType:'url_encoded_form' type:'application/x-www-form-urlencoded'.
	self registerType:'json' type:'application/json' type:'text/x-json'


]

{ #category : #accessing }
SCMime >> keyByMime:mime [
	^ keysByMime at:mime
]

{ #category : #accessing }
SCMime >> mimesByKey:key [
	^ mimesByKey at:key
]

{ #category : #'as yet unclassified' }
SCMime >> provides:type aBlock:aBlock [
	providesUsed:=true.
	mimeFuns add:(Array with:type with:aBlock)
]

{ #category : #accessing }
SCMime >> providesUsed [

	^ providesUsed
]

{ #category : #'as yet unclassified' }
SCMime >> registerType:key type:type [

	self registerType:key type:type type:nil type:nil

]

{ #category : #'as yet unclassified' }
SCMime >> registerType:key type:type type:type2 [

	self registerType:key type:type type:type2 type:nil


]

{ #category : #'as yet unclassified' }
SCMime >> registerType:key type:type type:type2 type:type3 [

	type2 
		ifNil:[
			mimesByKey at:key put: (Array with:type).
			keysByMime at:type put:key]
		ifNotNil:[
			type3
				ifNil:[
					mimesByKey at:key put: (Array with:type with:type2).
					keysByMime at:type put:key.
					keysByMime at:type2 put:key]
				ifNotNil:[
					mimesByKey at:key put: (Array with:type with:type2 with:type3).
					keysByMime at:type put:key.
					keysByMime at:type2 put:key.
					keysByMime at:type3 put:key]]
]

{ #category : #'as yet unclassified' }
SCMime >> resetProvides [
	providesUsed:=false.
	mimeFuns removeAll.
	responseContentType:=nil.
]

{ #category : #accessing }
SCMime >> responseContentType [
	^ responseContentType
]

{ #category : #accessing }
SCMime >> responseContentType: anObject [
	^ responseContentType := anObject
]

{ #category : #'as yet unclassified' }
SCMime >> runProvides:req [
	| bestFun bestKey |

	bestKey := self bestKeyForRequest: req.
	bestKey ifNotNil:[
		mimeFuns do:[:mimeFun|
			(bestKey = (mimeFun first)) ifTrue:[bestFun:= (mimeFun at:2)]]].

	bestFun 
		ifNil:[
			SCError new  
					messageText:(
						'not_acceptable:Content-type ',
						bestKey asString);
					signal]
		ifNotNil:[^ bestFun]

]
