runner
runShow:fun ddoc:ddoc args:args
|resp providedResp req b str|
[
	self resetList.
	mime:= ddoc mime.
	mime resetProvides.
	resp:= fun valueWithEnoughArguments:args.

	resp ifNil:[resp:=SCJsonObject new].
	resp:=self maybeWrapResponse:resp.
	
	"handle list style API"
	(chunks size>0)
	ifTrue:[
		(resp at:'headers') ifNotNil:[
			(resp at:'headers') do:[:header|
				(resp at:'headers') at:header put: (startResp at:header) ]]].
	
	(chunks size > 0)
	ifTrue:[	
		b:= (String new join:chunks).
		resp at:'body' put: ( b,(resp at:'body'))]
	ifFalse:[	
		resp at:'body' put: (resp at:'body')].
	self resetList.
	(mime providesUsed) 
	ifTrue:[
		req:=args at:2.
		providedResp:= ((mime runProvides: req) valueWithEnoughArguments:args).
		providedResp ifNil:[providedResp:=SCJsonObject new].
		str := WriteStream on:String new.
		str 
			nextPutAll: (resp at:'body' ifAbsent:'');
			nextPutAll: (String new join:chunks);
			nextPutAll:	(providedResp at:'body' ifAbsent:'').
		resp at:'body' put: str contents.
		resp:= self applyContentType:resp mime: (mime responseContentType).
		self resetList.
		].
	
	((resp isKindOf:String) or:[resp isKindOf: SCJsonObject ]) 
	ifTrue:[
		self respond: (Array with:'resp' with:(self maybeWrapResponse:resp)).
		]
	ifFalse:[
		^ self serializer  serialize:(Array with:'error' with:'render_error' with:'Undefined response from show function').
		]
	] on:Error do:[:err|
		server debug: ('[SCouchDBRender] runShow: ', err asString).
		^ self serializer  serialize:(Array with:'error' with:'render_error' with:err description)]	.
	^nil
	
	