private
schemes

	^ schemes ifNil:[
		schemes := {
			UndefinedObject -> [ :obj :json|  nil  ].
			True -> [ :obj :json| true  ].
			False -> [ :obj :json| false  ].
			Number -> [ :obj :json| json ].
			String -> [ :obj :json| json ].
			Collection -> self blockForCollections.
			"Association -> self blockForAssociations. "
			SCJsonObject -> self blockForJSON.
			Dictionary -> self blockForDictionaries.
			BlockClosure -> [ :obj :json | json].
			Object -> self blockForObjects. 
			} asDictionary ]
	