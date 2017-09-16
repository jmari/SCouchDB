private
blockForCollections
^[ :obj :stream| 
	|cobj|

	cobj := [obj asArray] on:Error do:[Array new].
	(self pool includesKey: obj) ifFalse:[
		self pool at:obj put:nil.
		stream nextPut:${.		
		(self writeIdRevInstanceOf: obj on:stream ) ifTrue:[stream nextPut:$,].
		stream nextPutAll:'"#values":['.				
		cobj  do:[:each| 	
				self serialize: each to: stream.
				stream nextPut:$,
		].
		cobj isNotEmpty ifTrue:[stream position: stream position -1].
		stream nextPut:$].
		stream nextPut:$}.
		]
		ifTrue:[
			stream nextPut:${.		
			self writeIdRevInstanceOf: obj on:stream.
			stream nextPut:$}]
	]

