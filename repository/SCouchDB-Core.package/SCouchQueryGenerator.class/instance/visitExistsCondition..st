visiting
visitExistsCondition: anExistsCondition 
	^ Dictionary new
		at: anExistsCondition label
		put: anExistsCondition right;
		yourself