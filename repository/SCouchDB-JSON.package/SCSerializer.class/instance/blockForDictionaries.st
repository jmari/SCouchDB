private
blockForDictionaries
^[ :obj :stream| 

	(self pool includesKey: obj) ifFalse:[
		self pool at:obj put:nil.
		stream nextPut:${.		
		(self writeIdRevInstanceOf: obj on:stream ) ifTrue:[obj ifNotEmpty:[stream nextPut:$,]].
		obj associationsDo:[:each| 
			self serialize:  each to: stream.
			stream nextPut:$, ].
		obj ifNotEmpty:[stream position: stream position -1].
		stream nextPut:$}.
		]
		ifTrue:[
			stream nextPut:${.		
			self writeIdRevInstanceOf: obj on:stream.
			stream nextPut:$}]
	]