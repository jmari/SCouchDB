as yet unclassified
discoverIdFor: jsonObject
	| possibleUUID |
	possibleUUID := (jsonObject isKindOf: Dictionary) ifTrue:[
								jsonObject at:'_id' ifAbsent:[
									(jsonObject respondsTo:#id) 
										ifTrue:[ jsonObject id]
										ifFalse:[nil]]].
	possibleUUID 
		ifNil:[ possibleUUID := (SCObjectsCache instance  keyAtValue:jsonObject)].
	^ possibleUUID