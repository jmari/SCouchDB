comparing
respondsTo: aSymbol
	^ SCExistsOperator new
		left:self;
		right: aSymbol;
		yourself