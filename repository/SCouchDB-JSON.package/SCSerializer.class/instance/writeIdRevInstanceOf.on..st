private
writeIdRevInstanceOf:obj on: stream
	| idRev uuid needComma cachedObject |

	needComma := false.
	uuid := self uuidProvider discoverIdFor: obj.
	uuid ifNotNil:[
		cachedObject := SCObjectsCache instance at:uuid.
		cachedObject = #deleted ifTrue:[
			needComma :=true.
			stream nextPutAll:'"_deleted":true']].
	
	((self areAllColectionsSerializedAsArray )| (self doNotneedIdRev: obj))
		ifTrue:[	^ needComma]
		ifFalse:[
			idRev := uuid 
						ifNotNil:[ ( uuid -> (self uuidProvider getRevFor:uuid ))]
						ifNil:[self uuidProvider getIdRevisionAssociationFor:obj]. 
			idRev key ifNotNil:[
				needComma ifTrue:[stream nextPut:$,].
				stream nextPutAll:'"_id":"';nextPutAll: idRev key asString;nextPut:$"].
			idRev value ifNotNil:[stream nextPut:$,;nextPutAll:'"_rev":"';nextPutAll:idRev value asString;nextPut:$"].
			stream  
					nextPut:$,;
					nextPutAll:'"#instanceOf":';
					nextPut:$";nextPutAll:obj class asString;nextPut:$".
		^ true]
		