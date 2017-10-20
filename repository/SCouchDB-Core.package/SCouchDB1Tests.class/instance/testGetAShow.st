tests
testGetAShow
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