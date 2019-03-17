accessing
markAsdeleted: anObject
	| uuid |
	uuid := self keyAtValue: anObject.
	mutex critical:[
		objects at: uuid put: #deleted]