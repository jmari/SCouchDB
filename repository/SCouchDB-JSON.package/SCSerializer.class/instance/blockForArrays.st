private
blockForArrays
^[ :obj :stream| 


		self pool at:obj put:nil.
		stream nextPut:$[.				
		obj do:[:each| 	
				self serialize: each to: stream.
				stream nextPut:$,
		].

		obj ifNotEmpty:[stream position: stream position -1].
		stream nextPut:$].

		]
	

