as yet unclassified
getUUIDFor:obj
	| uuid |
	"saving the id in the cache allows us to serialize recursive structures"
	uuid := SCObjectsCache instance keyAtValue:obj. 
	uuid ifNil: [ 
		uuid := self generateUUID.
		SCObjectsCache instance at:uuid put:obj ].
	^ uuid 