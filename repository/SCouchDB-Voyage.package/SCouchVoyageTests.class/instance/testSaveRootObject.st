tests
testSaveRootObject
	
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



	
