logical operation
= anInteger
	anInteger isInteger ifFalse: [ SCQueryError signal: 'Array size must be an Integer'].
	
	self right: anInteger