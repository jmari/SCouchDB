tests
testGetAView	
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