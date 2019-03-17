as yet unclassified
bestKeyForRequest:req
	| supportedMimes bestFun bestKey accept mimeKey |

	supportedMimes:=OrderedCollection new.
	bestFun:=nil.
	bestKey:=nil.
	accept:=(req at:'headers') at:'Accept'.
	(req at:'query') ifNil:[
		accept ifNotNil:[
			mimeFuns reverse do:[:mimeFun|
				mimeKey:=mimeFun first.
				(self mimesByKey:mimeKey) 
						ifNotNil:[ supportedMimes add:(self mimesByKey:mimeKey) ]].
			responseContentType := mimeParser bestMatch:supportedMimes header:accept.
			bestKey:=self keyByMime: responseContentType.
		] ifNil:[
			bestKey:=(mimeFuns first) first.
			responseContentType:= (self mimesByKey:bestKey) first ]]
	ifNotNil:[
		bestKey:=(mimeFuns first) first.
		responseContentType:= (self mimesByKey:bestKey) first.
		((req at:'query') at:'format') ifNotNil:[
			bestKey:=((req at:'query') at:'format').
			responseContentType:= (self mimesByKey:bestKey) first]].
	
	^ bestKey 