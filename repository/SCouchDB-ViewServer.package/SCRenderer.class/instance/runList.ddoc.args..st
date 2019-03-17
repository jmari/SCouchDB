runner
runList:fun ddoc:ddoc args:args
	|tail head req|
	self resetList.
	mime := ddoc mime.
	mime resetProvides.
	head:=args at:1.
	req:=args at:2.
	tail:= fun valueWithEnoughArguments:args.
	(mime providesUsed) ifTrue:[ tail:= ((mime runProvides:(args at:2)) valueWithEnoughArguments:args )].
	self gotRow ifFalse:[self getRow].
	tail ifNotNil:[ ((tail isKindOf:SCApp) or:[(tail isKindOf:SCRenderer)]) ifFalse:[chunks push:tail]].
	self blowChunks:'end'.
	^ self doNotReturnAnything 