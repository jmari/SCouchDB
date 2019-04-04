"
For custom host, use:

(SCouchDBAdaptorTests new host: 'yourhostname.com')
	testStoringConvertedDocuments
"
Class {
	#name : #SCouchDB1Tests,
	#superclass : #SCouchDBTests,
	#classVars : [
		'DefaultHost'
	],
	#category : 'SCouchDB-Core-Tests'
}

{ #category : #tests }
SCouchDB1Tests >> testAdding2000DocumentWithoutID [
	
	| db doc time |

	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0 . 'user'->'popo' } asDictionary.
	time:=[1 to:20 do:[:i|
				db documentPut: ( doc at:'val' put:i;yourself )]] timeToRun .
	
	self assert:  (db documents size) equals: 1 .
	self assert:  time < (Time seconds:130).

	db adaptor deleteDatabase: db name.
	

]

{ #category : #tests }
SCouchDB1Tests >> testAdding200Document [
	
	| db doc time|
	
	db := self createDB.
	doc := { 'name'->'Test'. 'val'->0  } asDictionary.
	time:=[1 to:20 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;copy )]] timeToRun .
	
	self assert:  (db documents size) equals: 20 .

	db adaptor deleteDatabase: db name.
	

]

{ #category : #tests }
SCouchDB1Tests >> testAddingDocument [
	
	| db doc |
	
	db := self createDB.
	doc := { 'name'->'Test'  } asDictionary.
	db documentAt: '1' put: ( doc  ).

	self assert:  ((db documentAt: '1') at: 'name') equals: 'Test' .
	db adaptor deleteDatabase: db name.
	

]

{ #category : #tests }
SCouchDB1Tests >> testAddingDocumentWithUUID [	
	| db docID |
	
	db := self createDB.
	docID := db adaptor nextUUID.
	
	db documentAt: docID put: ( { 'name'->'Test'  }  asDictionary ).	
	self assert:  ((db documentAt: docID) at: 'name') = 'Test' .
	db adaptor deleteDatabase: db name.
]

{ #category : #tests }
SCouchDB1Tests >> testBulkDocuments [
	
	| db arr time |
	db := self createDB.	
	
	arr := self largeObject. 				
	time := [db bulkDocs: arr] timeToRun.
	Transcript show: time asString.
	self assert:  db documents size equals: 1000.
	
	db bulkRemoveDocs: arr.
	self assert:  db documents size equals: 0.	

	"self couchdb deleteDatabase: db name."
				

]

{ #category : #tests }
SCouchDB1Tests >> testBulkDocuments2 [
	
	| db arr time |
	db := self createDB.	
	
	arr := self veryLargeObject. 				
	time := [db bulkDocs: arr] timeToRun.
	Transcript show: time asString.	
	time := [db bulkRemoveDocs: arr].

	Transcript show: time asString.
	"self couchdb deleteDatabase: db name."
				

]

{ #category : #tests }
SCouchDB1Tests >> testChanges [
	
	|r db doc |
	
	db := self createDB.
	doc := { 'name'->'Test'  } asDictionary.
	db documentAt: '1' put: ( doc  ).

	r := db changes.
	r inspect.
	self assert: r size > 0.

	

]

{ #category : #tests }
SCouchDB1Tests >> testCreateDeleteDB [


	
	(self couchdb databases includes: self dbname) ifTrue: [
		self couchdb deleteDatabase: self dbname.
		].
	self assert: (self couchdb databases includes: self dbname) not.

	self couchdb createDatabase: self dbname.
	
	self assert: (self couchdb databases includes: self dbname).
	self couchdb deleteDatabase: self dbname.
	

]

{ #category : #tests }
SCouchDB1Tests >> testDatabases [
	
	| db r |
	
	db := self createDB.
	r := db adaptor databases.
	self assert: r size > 0.
	db adaptor deleteDatabase: db name.
	

]

{ #category : #tests }
SCouchDB1Tests >> testErrorDeletingDB [


	
	(self couchdb databases includes: self dbname) ifTrue: [
		self couchdb deleteDatabase: self dbname.
		].

	self should: [ self couchdb deleteDatabase: self dbname]  raise: SCError


]

{ #category : #tests }
SCouchDB1Tests >> testErrorInvalidDocid [

	| db |
	
	db := self createFreshDB.

	self should: [ db documentAt: '2' ] raise: SCError.
	
	db adaptor deleteDatabase: db name


]

{ #category : #tests }
SCouchDB1Tests >> testErrorInvalidRev [

	| db re revList|
	
	db := self createFreshDB.

	db documentAt: '1' put: ( { 'name'->'Test'  } asDictionary   ).
	re:=db documentCurrentRevAt: '1'.
	self should: [ db documentAt: '1' rev: '99-97db6034a0321a88c96c592d870d01bc' ] raise: SCError.
	self assert:  ((db documentAt: '1' rev:re) at: 'name') = 'Test' .
	revList:=db documentRevisionsAt:'1'.
	revList:=db documentRevsInfoAt:'1'.
	
	
	db adaptor deleteDatabase: db name


]

{ #category : #tests }
SCouchDB1Tests >> testGetAList [
	| db app docs|
	self couchdb  deleteDatabase: 'test'.
	db := self couchdb ensureDatabase: 'test'.
	app := SCSimpleApp new.	
	db documentAt:app id put:app.
	app initDocs.
	
	docs := app list 
						name:'users';
						data:'users';
						limit:5;
						execute.
					
	self assert:(docs size > 10)
]

{ #category : #tests }
SCouchDB1Tests >> testGetAShow [
	| db app docs result|
	self couchdb  deleteDatabase: 'test'.
	db := self couchdb ensureDatabase: 'test'.
	app := SCSimpleApp new.	
	db documentAt:app id put:app.
	app initDocs.
	docs := db documents.

	result := app show 
					name:'user';
					data:(docs second at:'_id');
					execute.
					
	self assert:result equals:'lglLucía'
]

{ #category : #tests }
SCouchDB1Tests >> testGetAView [	
	| db app docs time doc |
	self couchdb  deleteDatabase: 'test'.
	db := self couchdb ensureDatabase: 'test'.
	app := SCSimpleApp new.	
	db documentAt:app id put:app.

	doc :=Dictionary new 
							at: 'user' put:'lgl';
							at: 'nickname' put:'Lucía';
							at: 'age' put:16;yourself.
							
	time:=[1 to:200 do:[:i|
				db documentAt: i asString put: ( doc at:'val' put:i;copy )]] timeToRun .
	docs := app view 
					name:'users';
					limit:50;
					execute.
					
	self assert: (docs size = 50)
]

{ #category : #tests }
SCouchDB1Tests >> testLogout [
	
	| db si i|
	
	db := self createDB.
	i:=db adaptor sessionInfo.
	db adaptor deleteDatabase: db name.
	si:=db adaptor logout.
		
	self assert:  (si at: 'ok') = true .
	

]

{ #category : #tests }
SCouchDB1Tests >> testMembership [
	
	| r |
	
	r := self couchdb membership.
	self assert: r size > 0.

	

]

{ #category : #tests }
SCouchDB1Tests >> testSessionInfo [
	
	| db si |
	
	db := self createDB.
	si:=db adaptor sessionInfo.
	self assert:  (si at: 'ok') = true .
		
	db adaptor deleteDatabase: db name.
	db adaptor logout
]

{ #category : #tests }
SCouchDB1Tests >> testStatistics [

	| adaptor stats |
	
	adaptor := self couchdb.

	stats := adaptor statistics:'couchdb@localhost'.
	stats inspect.
	self assert: (stats includesKey: 'couchdb')
]

{ #category : #tests }
SCouchDB1Tests >> testStoringConvertedDocuments [
	| db doc i|
	db := self createDB.
	i:=1.
	self objectsAsDocuments keysAndValuesDo: [:k :v| 
		"save object into couch db"
		db documentAt: i asString put: v.	
		"dict test fails by now"
		doc := db  documentAt:i asString.
		self assert: doc equals: v.
		i := i +1.
	].

	db adaptor deleteDatabase: db name.
	
]

{ #category : #tests }
SCouchDB1Tests >> testUnicodeChars [
	| db string |
	
	db := self createDB.
	string := {'unicode'->'♥'} asDictionary.
	db documentAt:'17' put: string.
	self assert:  ((db documentAt: '17') at:'unicode') equals: (string at:'unicode').
	db adaptor deleteDatabase: db name.

]

{ #category : #tests }
SCouchDB1Tests >> testUsersDatabase [
	
	| db i|
	
	db := self createDB.
	i:=db adaptor users.
	db adaptor deleteDatabase: db name.
	self assert:  (i at: 'db_name') = '_users' .
	db adaptor logout.

]

{ #category : #tests }
SCouchDB1Tests >> testUuids [
	
	| db i|
	
	db := self createDB.
	i:=db adaptor uuids.
	db adaptor deleteDatabase: db name.
	self assert:  (i includesKey: 'uuids').
	db adaptor logout.

]
