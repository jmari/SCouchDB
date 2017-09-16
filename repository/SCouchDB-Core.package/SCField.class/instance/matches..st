comparing
matches: aString
	^ SCRegExpOperator new
		left: self;
		right: aString;
		yourself