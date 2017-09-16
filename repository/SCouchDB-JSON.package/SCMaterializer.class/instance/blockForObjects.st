private
blockForObjects
	^ [ :obj :json |	
		json keysAndValuesDo:[:k : v| 
			(obj class allInstVarNames includes:k) ifTrue:[
					obj instVarNamed:k put: (self imaterialize:v)]].
		self cacheNewObject:obj json:json.
		obj]
	
	