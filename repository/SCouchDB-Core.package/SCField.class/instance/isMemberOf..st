testing
isMemberOf: aClass
	^ SCTypeOperator
		new  left: self;
		right: aClass name;
		yourself