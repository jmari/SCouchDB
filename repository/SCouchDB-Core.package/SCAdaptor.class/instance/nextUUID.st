server-level
nextUUID
	| uuid |
	[uuid := self uuidsPile pop] 
	on:CollectionIsEmpty 
	do:[
		( self newUUIDs: (self class maxUUIDsInMemory + 1)) do:[:each| self uuidsPile push:each].
		uuid := self uuidsPile pop].
	
	^ uuid