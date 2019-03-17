private
blockForJSON
	^ [ :obj :json |	
		json keysAndValuesDo:[:k : v| 
			(k = '#instanceOf' ) ifFalse:[	obj at:k put: (self imaterialize:v)]].
		self cacheNewObject:obj json:json.
		obj]
	
	