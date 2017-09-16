runner
maybeWrapResponse:resp

^ (resp isKindOf:String) 
		ifTrue:[ SCJsonObject new
										at:'body' put:resp;
										yourself]
		ifFalse:[ resp]