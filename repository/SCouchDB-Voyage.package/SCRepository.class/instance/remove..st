persistence
remove: anObject
	
	| uuid |
	uuid := self uuidProvider discoverIdFor: anObject.
	uuid ifNil:[ SCError signal:'Object does not have an ID.'].
	^ self database deleteDocument: uuid.