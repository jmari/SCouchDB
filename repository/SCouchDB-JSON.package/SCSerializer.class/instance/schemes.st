private
schemes
	^ schemes ifNil:[
		schemes := {
			UndefinedObject -> [ :obj :stream| stream nextPutAll: 'null'  ].
			True -> [ :obj :stream| stream nextPutAll: 'true'  ].
			False -> [ :obj :stream| stream nextPutAll: 'false'  ].
			Number -> [ :obj :stream| stream nextPutAll: obj asString  ].
			String -> [ :obj :stream| stream nextPut:$";nextPutAll: (self escapeString:obj);nextPut:$"].
			Array -> self blockForArrays.
			Collection -> self blockForCollections.
			Association -> self blockForAssociations. 
			Dictionary -> self blockForDictionaries.
			BlockClosure -> [ :obj :stream | stream nextPut:$";nextPutAll:(self escapeString: obj sourceCode);nextPut:$"].
			Object -> self blockForObjects. 
			} asDictionary ]
	