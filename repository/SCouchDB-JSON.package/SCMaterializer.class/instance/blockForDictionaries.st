private
blockForDictionaries
	^ [ :obj :json |	
		json keysAndValuesDo:[:k : v| 
			((k = '#instanceOf' ) or:[(k = '_id' ) or:[k = '_rev' ]])
			 ifFalse:[	obj at:k put: (self imaterialize:v)]	].
		self cacheNewObject:obj json:json.
		obj]
	
	