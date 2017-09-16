tests
testSelectAllSortBy
	
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



	
