tests
testSingletonCount
	
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



	
