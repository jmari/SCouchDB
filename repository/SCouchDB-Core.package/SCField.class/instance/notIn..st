testing
notIn: aCollection
	^ SCNotInOperator new
		left: self;
		right: aCollection;
		yourself