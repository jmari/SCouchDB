Class {
	#name : #SCouchVoyageTests,
	#superclass : #TestCase,
	#category : 'SCouchDB-Voyage-Tests'
}

{ #category : #tests }
SCouchVoyageTests >> testRemoveAll [
	
	| repo doc objects doc2 objects2  |
	
	repo := SCRepository userName:'admin' password:'admin'.
	
	doc := SCVoyageDomainObject new. 
	doc2 := SCVoyageDomainObject2 new. 
	1 to:20 do:[: i |
				repo save: ( doc firstName:i ;copy )].
			
	1 to:20 do:[: i |
				repo save: ( doc2 firstName:i;copy )].
	"database is full of objects...remove all of them"
	"we need to do garbageCollect because we don't want repo objects cached"
	Smalltalk garbageCollect.
	
	objects :=repo removeAll: SCVoyageDomainObject.
	objects2 :=repo removeAll: SCVoyageDomainObject2.
	objects explore.
	objects2 explore.



	

]

{ #category : #'as yet unclassified' }
SCouchVoyageTests >> testRendering [

	| cosa |
	cosa:= [ :each|( each name = 'john') & (each orders > 10) ] asMangoQuery.
	
	cosa inspect
]

{ #category : #tests }
SCouchVoyageTests >> testSaveObject [
	
	| repo doc docs |
	
	repo := SCRepository userName:'admin' password:'admin'.
	repo enableSingleton.
	
	doc := 1@1 corner:10@10.
	doc save.
	doc := nil.
	doc := Rectangle selectOne:[:aRect| aRect corner x =  10].
	doc inspect. 
	docs := Rectangle selectMany:[:aRect| aRect corner x =  10].
	docs inspect. 
	doc privateSetCorner: 13@13.
	doc save.



	

]

{ #category : #tests }
SCouchVoyageTests >> testSaveRootObject [
	
	| repo doc docs |
	
	repo := SCRepository userName:'admin' password:'admin'.
	repo enableSingleton.
	
	doc := 1@1 corner:10@10.
	doc save.
	doc := nil.
	doc := Rectangle selectOne:[:aRect| aRect corner x =  10].
	doc inspect. 
	docs := Rectangle selectMany:[:aRect| aRect corner x =  10].
	docs inspect. 
	doc privateSetCorner: 13@13.
	doc save.



	

]

{ #category : #tests }
SCouchVoyageTests >> testSelectAll [
	
	| repo doc objects doc2 objects2  |
	
	repo := SCRepository userName:'admin' password:'admin'.

	doc := SCVoyageDomainObject new. 
	doc2 := SCVoyageDomainObject2 new. 
	1 to:20 do:[: i |
				repo save: ( doc firstName:i ;copy )].
			
	1 to:20 do:[: i |
				repo save: ( doc2 firstName:i asString;copy )].
	"database is full of objects...select all of the objects"
	objects :=repo selectAll: SCVoyageDomainObject.
	objects2 :=repo selectAll: SCVoyageDomainObject2.
	self assert: objects size equals:20.
	self assert: objects2 size equals:20.



	

]

{ #category : #tests }
SCouchVoyageTests >> testSelectAllSortBy [
	
	| repo doc objects objects2  |
	
	repo := SCRepository userName:'admin' password:'admin'.

	doc := SCVoyageDomainObject new. 

	1 to:20 do:[: i |
				repo save: ( doc firstName:i ;copy )].
			
	"ordered by the server"
	objects :=repo selectAll: SCVoyageDomainObject sortBy:{#firstName}.
	objects explore.
	"ordered by the pharo"
	objects2 :=repo selectAll: SCVoyageDomainObject sortBy:[:a :b | a firstName > b firstName].
	objects2 explore.



	

]

{ #category : #tests }
SCouchVoyageTests >> testSingletonCount [
	
	| repo doc objects doc2 objects2  |
	
	repo := SCRepository userName:'admin' password:'admin'.
	repo enableSingleton.
	
	doc := SCVoyageDomainObject new. 
	doc2 := SCVoyageDomainObject2 new. 
	1 to:20 do:[: i |
				( doc firstName:i ;copy ) save].
			
	1 to:15 do:[: i |
				( doc2 firstName:i asString;copy ) save].
	"database is full of objects...select all of the objects"
	
	Smalltalk garbageCollect.
	
	objects := SCVoyageDomainObject count.
	objects2 := SCVoyageDomainObject2 count.
	objects explore.
	objects2 explore.



	

]

{ #category : #tests }
SCouchVoyageTests >> testSingletonRemoveAll [
	
	| repo doc objects doc2 objects2  |
	
	repo := SCRepository userName:'admin' password:'admin'.
	repo enableSingleton.
	
	doc := SCVoyageDomainObject new. 
	doc2 := SCVoyageDomainObject2 new. 
	1 to:20 do:[: i |
				( doc firstName:i ;copy ) save].
			
	1 to:20 do:[: i |
				( doc2 firstName:i asString;copy ) save].
	"database is full of objects...select all of the objects"
	
	Smalltalk garbageCollect.
	
	objects := SCVoyageDomainObject removeAll.
	objects2 := SCVoyageDomainObject2 removeAll.
	objects explore.
	objects2 explore.



	

]

{ #category : #tests }
SCouchVoyageTests >> testSingletonSelectAll [
	
	| repo doc objects doc2 objects2  |
	
	repo := SCRepository userName:'admin' password:'admin'.
	repo enableSingleton.
	
	doc := SCVoyageDomainObject new. 
	doc2 := SCVoyageDomainObject2 new. 
	1 to:20 do:[: i |
				( doc firstName:i ;copy ) save].
			
	1 to:20 do:[: i |
				( doc2 firstName:i asString;copy ) save].
	"database is full of objects...select all of the objects"
	objects := SCVoyageDomainObject selectAll.
	objects2 := SCVoyageDomainObject2 selectAll.
	objects explore.
	objects2 explore.



	

]
