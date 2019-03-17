tests
testSelectAll
	
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



	
