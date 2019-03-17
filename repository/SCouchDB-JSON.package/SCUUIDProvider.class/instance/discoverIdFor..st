as yet unclassified
discoverIdFor: jsonObject
	| possibleUUID |
	possibleUUID := (jsonObject isKindOf: Dictionary) ifTrue:[
								jsonObject at:self idField ifAbsent:[
								
										(jsonObject respondsTo:self idField asSymbol) 
											ifTrue:[ jsonObject perform: self idField asSymbol]
											ifFalse:[nil]]].
	possibleUUID 
		ifNil:[ possibleUUID := (SCObjectsCache instance  keyAtValue:jsonObject)].
	^ possibleUUID