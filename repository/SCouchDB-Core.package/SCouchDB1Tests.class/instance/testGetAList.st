tests
testGetAList
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