as yet unclassified
getUUIDFor:obj
	| uuid |

	uuid := SCObjectsCache instance keyAtValue:obj. 
	uuid ifNil: [ 
		uuid := self adaptor nextUUID.
		SCObjectsCache instance at:uuid put:obj ].
	^ uuid 