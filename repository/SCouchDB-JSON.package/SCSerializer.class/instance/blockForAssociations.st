private
blockForAssociations
	^ [ :obj :stream| 
				stream nextPut:$";nextPutAll: obj key asString;nextPut:$";nextPut:$:. 
				self serialize: obj value to:stream].