initialization
initialize:size
	super initialize:size.
	self language:'smalltalk'.
	self at:'_id' ifAbsentPut:[ '_design/' , self className asLowercase  ].
	self initialize
