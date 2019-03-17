private
blockForDictionaries
	^ [ :obj :json |	
		"comented because problems in the view server...."
		json keysAndValuesDo:[:k : v| 
			((k = '#instanceOf' ) "or:[(k = '_id' ) or:[k = '_rev' ]]")
			 ifFalse:[	obj at:k put: (self imaterialize:v)]	].
		self cacheNewObject:obj json:json.
		obj]
	
	