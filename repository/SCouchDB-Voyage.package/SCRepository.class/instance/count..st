persistence
count: aClass
	|app appName index|
	index := self indexForClassSortedBy:#().
	appName := (index ddoc findTokens: $/) at:2.
	app := self database applicationAt: appName.
	^ ((app view 
			name:index name;
			key: (Array with:aClass name) ;
			reduce;
			execute) at:1) at:'value'