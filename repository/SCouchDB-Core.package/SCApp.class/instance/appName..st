accessing
appName: anObject
	appName := anObject.
	self at:'_id' put: '_design/' , self appName .