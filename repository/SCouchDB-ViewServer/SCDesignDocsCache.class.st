"
SCDesignDocsCache stores a materialized SCApp.  
    Instance Variables
	cache:		Dictionary used to store  Apps by name
	mutex:		mutual exclusion


    Implementation Points
"
Class {
	#name : #SCDesignDocsCache,
	#superclass : #Object,
	#instVars : [
		'mutex',
		'cache'
	],
	#category : 'SCouchDB-ViewServer'
}

{ #category : #'as yet unclassified' }
SCDesignDocsCache class >> cacheSize [
	^ 250
]

{ #category : #'as yet unclassified' }
SCDesignDocsCache >> at: appName [
	
	^ self at: appName ifAbsent:[nil]
	
]

{ #category : #'as yet unclassified' }
SCDesignDocsCache >> at: appName ifAbsent:aBlock [
	| compiledCode |
	mutex critical:[ compiledCode := self cache at: appName ifAbsent:[nil]].
	^ compiledCode ifNil:[aBlock value].


	
]

{ #category : #'as yet unclassified' }
SCDesignDocsCache >> at: appName ifAbsentPut:aBlock [
	| compiledCode |
	self manageCacheSize.
	mutex critical:[ compiledCode := self cache at: appName ifAbsentPut:aBlock].
	^ compiledCode .


	
]

{ #category : #'as yet unclassified' }
SCDesignDocsCache >> at: appName put:aCompiledSourceCode [	
	self manageCacheSize.
	mutex critical: [	self cache at: appName put:aCompiledSourceCode	].

	
]

{ #category : #'as yet unclassified' }
SCDesignDocsCache >> cache [
	^ cache ifNil:[ cache := Dictionary new]
]

{ #category : #'as yet unclassified' }
SCDesignDocsCache >> initialize [
	mutex := Mutex new 
]

{ #category : #'as yet unclassified' }
SCDesignDocsCache >> manageCacheSize [
	"removes the elements from 1 to cacheSize/2 if the size is greater than #cacheSize "
	mutex critical:[
		(self cache size > self class cacheSize) ifTrue:[
			self cache keys do:[:aKey|
				self cache removeKey: aKey.
				(self cache size < ((self class cacheSize / 2 ))) ifTrue:[
				 	^self]]]]
]

{ #category : #'as yet unclassified' }
SCDesignDocsCache >> removeAll [
	mutex critical: [
		[self cache removeAll]  on:Error do:["nothing"]]



]
