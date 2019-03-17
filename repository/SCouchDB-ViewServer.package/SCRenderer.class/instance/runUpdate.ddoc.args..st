runner
runUpdate:fun ddoc:ddoc args:args
|method result doc resp |
[
	method:=(args at:2) method.
	"for analytics logging applications you might want to remove the next line"
	"(method = 'GET') ifTrue:[^ self serializer serialize: (Array with:'error' with:'method not allowed' with:'Update method do not allow GET')]."
	result := fun valueWithEnoughArguments:args.
	doc := result at:1.
	resp := result at:2.
	
	((resp isKindOf:String) or:[resp isKindOf: SCJsonObject ]) 
	 ifTrue:[
		self respond: (Array 
			with:'up' 
			with:doc 
			with: ( self maybeWrapResponse:resp))
	]
	ifFalse:[
		SCRenderException signal]
	] on:Error do:[:err|
		server debug: ('[SCouchDBRender] runUpdate: ', err asString).
		^ self serializer  serialize:(Array with:'error' with:'render_error' with:err description)
]